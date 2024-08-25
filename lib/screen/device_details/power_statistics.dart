import 'dart:async';
import 'dart:convert';

import 'package:country_flags/country_flags.dart';
import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/model/country_data.dart';
import 'package:enavatek_mobile/model/energy.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/menu/live_data.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/dropdown.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:country_picker/country_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class PowerStatisticsScreen extends StatefulWidget {
  final String deviceId;
  final List<String> deviceList;
  final int tabIndex;

  const PowerStatisticsScreen({
    Key? key,
    required this.deviceId,
    required this.deviceList,
    required this.tabIndex,
  }) : super(key: key);

  @override
  PowerStatisticsScreenState createState() => PowerStatisticsScreenState();
}

class PowerStatisticsScreenState extends State<PowerStatisticsScreen>
    with SingleTickerProviderStateMixin {
  String? totalPower = "", acPower = "", dcPower = "";
  double? acValue = 0,
      dcValue = 0,
      acVoltage = 0,
      dcVoltgae = 0,
      acCurrent = 0,
      dcCurrent = 0,
      acEnergy = 0,
      dcEnergy = 0;
  Timer? timer;
  List<EnergyData> energyDataList = [];
  List<CountryData> countryList = [];

  String energyType = "intraday";
  String totalTree = "0";
  String totalSavings = "0";
  String totalEnergy = "0";

  String periodType = "day";
  ValueNotifier<bool> energyNotiifer = ValueNotifier(true);
  ValueNotifier<bool> treeNotiifer = ValueNotifier(false);
  ValueNotifier<bool> savingNotiifer = ValueNotifier(false);
  ValueNotifier<int> selectedTabIndex = ValueNotifier<int>(0);
  ValueNotifier<String> selectedCountryNotifier = ValueNotifier<String>('sg');
  ValueNotifier<int> countryId = ValueNotifier<int>(4);

  TooltipPosition _tooltipPosition = TooltipPosition.pointer;

  @override
  void initState() {
    super.initState();
    DateTime currentDate = DateTime.now();
    String formattedDate =
        "${currentDate.day}-${currentDate.month}-${currentDate.year}";
    fetchData(energyType);
    powerusages("day", formattedDate);
    fetchCountry(false);
    if (widget.tabIndex == 1) {
      energyNotiifer.value = true;
      savingNotiifer.value = false;
      treeNotiifer.value = false;
      selectedTabIndex.value = 0;
    } else if (widget.tabIndex == 2) {
      energyNotiifer.value = false;
      savingNotiifer.value = true;
      treeNotiifer.value = false;
      selectedTabIndex.value = 1;
    } else if (widget.tabIndex == 3) {
      energyNotiifer.value = false;
      savingNotiifer.value = false;
      treeNotiifer.value = true;
      selectedTabIndex.value = 2;
    }
  }

  int getCountryIdByCurrencyType(String currencyType) {
    for (var country in countryList) {
      if (country.currencyType.toLowerCase() == currencyType.toLowerCase()) {
        return country.id;
      }
    }
    throw Exception('Country with currency type $currencyType not found');
  }

  Future<void> fetchData(String periodType) async {
    try {
      int? userId = await SharedPreferencesHelper.instance.getUserID();
      int? countryId =
          getCountryIdByCurrencyType(selectedCountryNotifier.value);
      print(countryId);
      final data = await RemoteServices.fetchEnergyData(
        deviceId: widget.deviceList,
        periodType: periodType,
        userId: userId!,
        countryId: countryId
      );
      setState(() {
        energyDataList = data;
        totalTree =
            calculateTotalTreesPlanted(energyDataList).toStringAsFixed(2);
        totalSavings =
            calculateAverageSavings(energyDataList).toStringAsFixed(2);
        totalEnergy =
            calculateTotalEnergySaving(energyDataList).toStringAsFixed(2);
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  Future<void> fetchCountry(bool status) async {
    try {
      String? authToken = await SharedPreferencesHelper.instance.getAuthToken();

      final data = await RemoteServices.fetchCountryList(token: authToken!);
      setState(() {
        countryList = data;
        if (status) {
          countrySelection();
        }
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  Future<void> powerusages(String periodType, String periodValue) async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? userId = await SharedPreferencesHelper.instance.getUserID();

    final response = await RemoteServices.powerusages(
        authToken!, "", periodType, periodValue, "all", userId!);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (!mounted) return;

      setState(() {
        totalPower = responseData['total_power'];
        acPower = responseData['ac_power'];
        dcPower = responseData['dc_power'];
        String acPowerValueStr = acPower!.replaceAll(RegExp(r'[^0-9.]'), '');
        String dcPowerValueStr = dcPower!.replaceAll(RegExp(r'[^0-9.]'), '');
        String acVoltageStr =
            responseData['ac_voltage'].replaceAll(RegExp(r'[^0-9.]'), '');
        String dcVoltageStr =
            responseData['dc_voltage'].replaceAll(RegExp(r'[^0-9.]'), '');
        String acCurrentStr =
            responseData['ac_current'].replaceAll(RegExp(r'[^0-9.]'), '');
        String dcCurrentStr =
            responseData['dc_current'].replaceAll(RegExp(r'[^0-9.]'), '');
        String acEnergyStr =
            responseData['ac_energy'].replaceAll(RegExp(r'[^0-9.]'), '');
        String dcEnergyStr =
            responseData['dc_energy'].replaceAll(RegExp(r'[^0-9.]'), '');

        acValue = double.parse(acPowerValueStr);
        dcValue = double.parse(dcPowerValueStr);
        acVoltage = double.parse(acVoltageStr);
        dcVoltgae = double.parse(dcVoltageStr);
        acCurrent = double.parse(acCurrentStr);
        dcCurrent = double.parse(dcCurrentStr);
        acEnergy = double.parse(acEnergyStr);
        dcEnergy = double.parse(dcEnergyStr);
      });

      print('Total Power: $totalPower');
      print('AC Power: $acPower');
      print('DC Power: $dcPower');
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('message') &&
          responseData['message'] == 'No record(s) found') {
        setState(() {
          totalPower = "0W";
          acPower = "0W";
          dcPower = "0W";
          acValue = 0;
          dcValue = 0;
          acVoltage = 0;
          dcVoltgae = 0;
          acCurrent = 0;
          dcCurrent = 0;
          acEnergy = 0;
          dcEnergy = 0;
        });
      }
    }
  }

  calculateTotalTreesPlanted(List<EnergyData> energyDataList) {
    double totalDcTree = 0.0;

    for (var data in energyDataList) {
      totalDcTree += data.treesPlanted;
    }
    setState(() {
      totalTree = totalDcTree.toString();
    });
    return totalDcTree;
  }

  double calculateAverageSavings(List<EnergyData> energyDataList) {
    if (energyDataList.isEmpty) {
      return 0.0;
    }
    double totalSaving =
        energyDataList.fold(0.0, (sum, data) => sum + data.energySaving);
    return totalSaving / energyDataList.length;
  }

  double calculateTotalEnergySaving(List<EnergyData> energyDataList) {
    if (energyDataList.isEmpty) {
      return 0.0;
    }
    double totalenergy =
        energyDataList.fold(0.0, (sum, data) => sum + data.totalEnergy);
    return totalenergy / energyDataList.length;
  }

  Future<void> countrySelection() async {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    // Future<void> createCountry(
    //     String countryName, String currencyType, double energyRate) async {
    //   String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    //   print(authToken);
    //   Response response = await RemoteServices.createCountry(
    //       authToken!, countryName, currencyType, energyRate);
    //   var data = jsonDecode(response.body);

    //   if (response.statusCode == 200) {
    //     if (data.containsKey("message")) {
    //       String message = data["message"];
    //       SnackbarHelper.showSnackBar(context, message);
    //       Navigator.pop(context);
    //     }
    //   } else {
    //     SnackbarHelper.showSnackBar(context, "Failed to create country");
    //   }
    // }

    String currency = "";
    String radioValue = "";
    TextEditingController countryController = TextEditingController();
    TextEditingController energyController = TextEditingController();

    return showDialog(
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              contentPadding: EdgeInsets.zero,
              insetPadding: const EdgeInsets.all(14),
              actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              actions: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.82,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Country',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ConstantColors.appColor,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.close),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Divider(
                          thickness: 1,
                          color: Colors.black12,
                        ),
                      ),
                      // Country Selection Radio Buttons
                      ...countryList.map((country) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CountryFlag.fromCountryCode(
                              country.currencyType,
                              shape: const Circle(),
                              height: 25,
                              width: 25,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              country.name,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: ConstantColors.appColor,
                              ),
                            ),
                            const Spacer(),
                            Transform.scale(
                              scale: 1,
                              child: Radio(
                                value: country.currencyType,
                                groupValue: radioValue,
                                hoverColor: ConstantColors.borderButtonColor,
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) =>
                                        ConstantColors.borderButtonColor),
                                onChanged: (value) {
                                  setState(() {
                                    radioValue = value.toString();
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      const SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Container(
                      //       height: 25,
                      //       width: 25,
                      //       decoration: const BoxDecoration(
                      //         color: ConstantColors.iconColr,
                      //         shape: BoxShape.circle,
                      //       ),
                      //     ),
                      //     const SizedBox(width: 20),
                      //     Text(
                      //       'Custom',
                      //       style: GoogleFonts.roboto(
                      //         fontSize: 14,
                      //         color: ConstantColors.appColor,
                      //       ),
                      //     ),
                      //     const Spacer(),
                      //     Transform.scale(
                      //       scale: 1,
                      //       child: Radio(
                      //         value: "Custom",
                      //         groupValue: radioValue,
                      //         hoverColor: ConstantColors.borderButtonColor,
                      //         fillColor: MaterialStateColor.resolveWith(
                      //             (states) => ConstantColors.borderButtonColor),
                      //         onChanged: (value) {
                      //           setState(() {
                      //             radioValue = value.toString();
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 10),
                      // Conditional Display of Country Picker and Energy Rate Input
                      if (radioValue == "Custom") ...[
                        Container(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 0,
                            top: isTablet ? 20 : 0,
                            bottom: isTablet ? 20 : 0,
                          ),
                          decoration: BoxDecoration(
                            color: ConstantColors.inputColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                showPhoneCode: false,
                                onSelect: (Country country) {
                                  countryController.text = country.name;
                                  currency = country.countryCode;
                                },
                              );
                            },
                            controller: countryController,
                            autocorrect: false,
                            readOnly: true,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.expand_more,
                                size: screenWidth * 0.05,
                                color: ConstantColors.mainlyTextColor,
                              ),
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.roboto(
                                fontSize: screenWidth * 0.04,
                              ),
                              hintText: 'Select Country',
                            ),
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 0,
                            top: isTablet ? 20 : 0,
                            bottom: isTablet ? 20 : 0,
                          ),
                          decoration: BoxDecoration(
                            color: ConstantColors.inputColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: energyController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                child: Text(
                                  'USD | ',
                                  style: GoogleFonts.roboto(
                                    fontSize: screenWidth * 0.04,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.roboto(
                                fontSize: screenWidth * 0.04,
                              ),
                              hintText: 'Energy rate',
                            ),
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      RoundedButton(
                        text: radioValue == "Custom" ? "Create" : "Apply",
                        backgroundColor: ConstantColors.borderButtonColor,
                        textColor: ConstantColors.whiteColor,
                        onPressed: () {
                          if (radioValue == "Custom") {
                            if (countryController.text.isEmpty) {
                              SnackbarHelper.showSnackBar(
                                  context, "Please select country");
                            } else if (energyController.text.isEmpty) {
                              SnackbarHelper.showSnackBar(
                                  context, "Please select energy");
                            } else {
                              // createCountry(
                              //   countryController.text,
                              //   currency,
                              //   double.parse(energyController.text),
                              // );
                            }
                          } else {
                            setState(() {
                              print(radioValue);
                              selectedCountryNotifier.value = radioValue;
                              Navigator.pop(context);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<void> exportCSV(String csvContent, String fileName) async {
    final path = '/storage/emulated/0/Download/$fileName';
    final file = File(path);

    await file.writeAsString(csvContent);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('CSV downloaded successfully to $path'),
      ),
    );

    print('File saved at $path');
  }

  Future<void> exportPowerConsumptionData() async {
    try {
      int? userId = await SharedPreferencesHelper.instance.getUserID();
      var response = await RemoteServices().export(
        deviceId: widget.deviceList,
        periodType: energyType,
        userId: userId!,
      );

      if (response.statusCode == 200) {
        final csvContent = response.body;
        final fileName =
            'power_consumption_data_${DateFormat('dd_MM_yyyy').format(DateTime.now())}.csv';

        exportCSV(csvContent, fileName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to download CSV ')),
        );
      }
    } catch (e) {
      print('Error exporting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.liveBgColor,
      bottomNavigationBar: Footer(),
      appBar: AppBar(
        backgroundColor: ConstantColors.darkBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        'Power Statistics',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ConstantColors.appColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              fetchCountry(true);
            },
            child: ValueListenableBuilder<String>(
              valueListenable: selectedCountryNotifier,
              builder: (context, value, child) {
                return CountryFlag.fromCountryCode(
                  value,
                  shape: const Circle(),
                  height: 30,
                  width: 30,
                );
              },
            ),
          ),
          const Icon(Icons.arrow_drop_down_sharp),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LiveDataScreen(),
                ),
              );
            },
            child: Image.asset(
              ImgPath.liveData,
              height: 30,
              width: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, menuRoute);
            },
            child: Image.asset(
              ImgPath.pngMenu,
              height: 30,
              width: 30,
              color: ConstantColors.borderButtonColor,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: ConstantColors.darkBackgroundColor,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              ImgPath.pngSolarPlane,
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              '2 W',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          ImgPath.leftArrow1,
                          height: 15,
                        ),
                        Image.asset(
                          ImgPath.leftArrow1,
                          height: 15,
                        ),
                        Image.asset(
                          ImgPath.leftArrow1,
                          height: 15,
                        ),
                        Image.asset(
                          ImgPath.leftArrow1,
                          height: 15,
                        ),
                        Image.asset(
                          ImgPath.leftArrow2,
                          height: 15,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Image.asset(
                          ImgPath.totalPower,
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Image.asset(
                          ImgPath.rightArrow1,
                          height: 15,
                        ),
                        Image.asset(
                          ImgPath.rightArrow2,
                          height: 15,
                        ),
                        Image.asset(
                          ImgPath.rightArrow3,
                          height: 15,
                        ),
                        Image.asset(
                          ImgPath.rightArrow4,
                          height: 15,
                        ),
                        Image.asset(
                          ImgPath.rightArrow5,
                          height: 15,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              ImgPath.pngTower,
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              '912 W',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'DC Power',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              dcPower!,
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.appColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Total Power',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.iconColr,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              totalPower!,
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.iconColr,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'AC Power',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.appColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              acPower!,
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.appColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: selectedTabIndex,
              builder: (context, value, child) {
                return Container(
                  color: ConstantColors.liveBgColor,
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            selectedTabIndex.value = 0;
                            energyNotiifer.value = true;
                            treeNotiifer.value = false;
                            savingNotiifer.value = false;
                            setState(() {
                              energyType = "intraday";
                            });
                            fetchData("intraday");
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              Image.asset(
                                ImgPath.energyIcon,
                                width: 30,
                                height: 30,
                                color: value == 0
                                    ? ConstantColors.borderButtonColor
                                    : ConstantColors.appColor,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Energy Saving',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: ConstantColors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        const SizedBox(width: 60),
                        GestureDetector(
                          onTap: () {
                            selectedTabIndex.value = 1;
                            energyNotiifer.value = false;
                            treeNotiifer.value = false;
                            savingNotiifer.value = true;
                            setState(() {
                              energyType = "Intraday";
                            });
                            fetchData("intraday");
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              Image.asset(
                                ImgPath.dollerSymbol,
                                width: 30,
                                height: 30,
                                color: value == 1
                                    ? ConstantColors.borderButtonColor
                                    : ConstantColors.appColor,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Saving',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: ConstantColors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        const SizedBox(width: 60),
                        GestureDetector(
                          onTap: () {
                            selectedTabIndex.value = 2;
                            energyNotiifer.value = false;
                            treeNotiifer.value = true;
                            savingNotiifer.value = false;
                            fetchData("intraday");
                            setState(() {
                              energyType = "intraday";
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              Image.asset(
                                ImgPath.treeIcon,
                                width: 30,
                                height: 30,
                                color: value == 2
                                    ? ConstantColors.borderButtonColor
                                    : ConstantColors.appColor,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Tree Planted',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: ConstantColors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            ValueListenableBuilder(
                valueListenable: energyNotiifer,
                builder: (context, value, child) {
                  return Visibility(
                    visible: energyNotiifer.value,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Total Energy Saving',
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '$totalEnergy %',
                                      style: GoogleFonts.roboto(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          color:
                                              ConstantColors.borderButtonColor,
                                          width: 10,
                                          height: 2,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'AC',
                                          style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          color: ConstantColors.greenColor,
                                          width: 10,
                                          height: 2,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'DC',
                                          style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                SizedBox(
                                  width: 120,
                                  child: CustomDropdownButton(
                                    value: "Intraday",
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Intraday',
                                        child: Text('Intraday'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Day',
                                        child: Text('Day'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Week',
                                        child: Text('Week'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Month',
                                        child: Text('Month'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Year',
                                        child: Text('Year'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      print(' selected: $value');
                                      if (value == "Intraday") {
                                        setState(() {
                                          energyType = "intraday";
                                        });
                                        fetchData("intraday");
                                      } else if (value == "Day") {
                                        setState(() {
                                          energyType = "day";
                                        });
                                        fetchData("day");
                                      } else if (value == "Week") {
                                        setState(() {
                                          energyType = "week";
                                        });
                                        fetchData("week");
                                      } else if (value == "Month") {
                                        setState(() {
                                          energyType = "month";
                                        });
                                        fetchData("month");
                                      } else {
                                        setState(() {
                                          energyType = "year";
                                        });
                                        fetchData("year");
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ValueListenableBuilder(
                valueListenable: savingNotiifer,
                builder: (context, value, child) {
                  return Visibility(
                    visible: savingNotiifer.value,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Total saving in SGD',
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      totalSavings,
                                      style: GoogleFonts.roboto(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                SizedBox(
                                  width: 120,
                                  child: CustomDropdownButton(
                                    value: "Intraday",
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Intraday',
                                        child: Text('Intraday'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Day',
                                        child: Text('Day'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Week',
                                        child: Text('Week'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Month',
                                        child: Text('Month'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Year',
                                        child: Text('Year'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      print(' selected: $value');
                                      if (value == "Intraday") {
                                        setState(() {
                                          energyType = "intraday";
                                        });
                                        fetchData("intraday");
                                      } else if (value == "Day") {
                                        setState(() {
                                          energyType = "day";
                                        });
                                        fetchData("day");
                                      } else if (value == "Week") {
                                        setState(() {
                                          energyType = "week";
                                        });
                                        fetchData("week");
                                      } else if (value == "Month") {
                                        setState(() {
                                          energyType = "month";
                                        });
                                        fetchData("month");
                                      } else {
                                        setState(() {
                                          energyType = "year";
                                        });
                                        fetchData("year");
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ValueListenableBuilder(
                valueListenable: treeNotiifer,
                builder: (context, value, child) {
                  return Visibility(
                    visible: treeNotiifer.value,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Total Tree Planted',
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      totalTree,
                                      style: GoogleFonts.roboto(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          color: ConstantColors.greenColor,
                                          width: 10,
                                          height: 2,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Tree Planted',
                                          style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          color:
                                              ConstantColors.borderButtonColor,
                                          width: 10,
                                          height: 2,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'S\$ Savings',
                                          style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          color: ConstantColors.appColor,
                                          width: 10,
                                          height: 2,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'CO2',
                                          style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                SizedBox(
                                  width: 120,
                                  child: CustomDropdownButton(
                                    value: "Intraday",
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Intraday',
                                        child: Text('Intraday'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Day',
                                        child: Text('Day'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Week',
                                        child: Text('Week'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Month',
                                        child: Text('Month'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Year',
                                        child: Text('Year'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      print(' selected: $value');
                                      if (value == "Intraday") {
                                        setState(() {
                                          energyType = "intraday";
                                        });
                                        fetchData("intraday");
                                      } else if (value == "Day") {
                                        setState(() {
                                          energyType = "day";
                                        });
                                        fetchData("day");
                                      } else if (value == "Week") {
                                        setState(() {
                                          energyType = "week";
                                        });
                                        fetchData("week");
                                      } else if (value == "Month") {
                                        setState(() {
                                          energyType = "month";
                                        });
                                        fetchData("month");
                                      } else {
                                        setState(() {
                                          energyType = "year";
                                        });
                                        fetchData("year");
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            // const SizedBox(
            //   height: 20,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      exportPowerConsumptionData();
                    },
                    child: Image.asset(
                      ImgPath.export,
                      height: 25,
                      width: 25,
                      color: ConstantColors.iconColr,
                    )),
                const SizedBox(width: 20),
              ],
            ),
            ValueListenableBuilder(
              valueListenable: energyNotiifer,
              builder: (context, value, child) {
                return Visibility(
                    visible: energyNotiifer.value,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        height: 350,
                        child: SfCartesianChart(
                          primaryXAxis: const CategoryAxis(),
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            shared: true,
                            tooltipPosition: TooltipPosition.auto,
                          ),
                          series: <CartesianSeries>[
                            ColumnSeries<EnergyData, String>(
                              dataSource: energyDataList,
                              xValueMapper: (EnergyData data, _) {
                                if (energyType == "intraday") {
                                  return data.getFormattedTime();
                                } else if (energyType == "day" ||
                                    energyType == "week") {
                                  return data.getFormattedDate();
                                } else if (energyType == "month") {
                                  return data.getFormattedMonth();
                                } else if (energyType == "year") {
                                  return data.getFormattedYear();
                                } else {
                                  return "";
                                }
                              },
                              yValueMapper: (EnergyData data, _) =>
                                  data.acEnergyConsumed,
                              name: 'AC Power',
                              color: ConstantColors.borderButtonColor,
                            ),
                            ColumnSeries<EnergyData, String>(
                              dataSource: energyDataList,
                              xValueMapper: (EnergyData data, _) {
                                if (energyType == "intraday") {
                                  return data.getFormattedTime();
                                } else if (energyType == "day" ||
                                    energyType == "week") {
                                  return data.getFormattedDate();
                                } else if (energyType == "month") {
                                  return data.getFormattedMonth();
                                } else if (energyType == "year") {
                                  return data.getFormattedYear();
                                } else {
                                  return "";
                                }
                              },
                              yValueMapper: (EnergyData data, _) =>
                                  data.dcEnergyConsumed,
                              name: 'DC Power',
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            ),
            ValueListenableBuilder(
              valueListenable: savingNotiifer,
              builder: (context, value, child) {
                return Visibility(
                    visible: savingNotiifer.value,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        height: 350,
                        child: SfCartesianChart(
                          primaryXAxis: const CategoryAxis(),
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            header: 'Energy Saving',
                            canShowMarker: true,
                            decimalPlaces: 2,
                            format: 'point.y',
                            tooltipPosition: TooltipPosition.auto,
                          ),
                          series: <CartesianSeries>[
                            LineSeries<EnergyData, String>(
                              dataSource: energyDataList,
                              xValueMapper: (EnergyData data, _) {
                                if (energyType == "intraday") {
                                  return data.getFormattedTime();
                                } else if (energyType == "day" ||
                                    energyType == "week") {
                                  return data.getFormattedDate();
                                } else if (energyType == "month") {
                                  return data.getFormattedMonth();
                                } else if (energyType == "year") {
                                  return data.getFormattedYear();
                                } else {
                                  return "";
                                }
                              },
                              yValueMapper: (EnergyData data, _) =>
                                  data.energySaving,
                              markerSettings:
                                  const MarkerSettings(isVisible: true),
                              name: 'Saving',
                              color: ConstantColors.borderButtonColor,
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            ),
            ValueListenableBuilder(
              valueListenable: treeNotiifer,
              builder: (context, value, child) {
                return Visibility(
                    visible: treeNotiifer.value,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        height: 350,
                        child: SfCartesianChart(
                          primaryXAxis: const CategoryAxis(),
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            shared: true,
                            tooltipPosition: TooltipPosition.auto,
                          ),
                          series: <CartesianSeries>[
                            ColumnSeries<EnergyData, String>(
                              dataSource: energyDataList,
                              xValueMapper: (EnergyData data, _) {
                                if (energyType == "intraday") {
                                  return data.getFormattedTime();
                                } else if (energyType == "day" ||
                                    energyType == "week") {
                                  return data.getFormattedDate();
                                } else if (energyType == "month") {
                                  return data.getFormattedMonth();
                                } else if (energyType == "year") {
                                  return data.getFormattedYear();
                                } else {
                                  return "";
                                }
                              },
                              yValueMapper: (EnergyData data, _) =>
                                  data.energySaving,
                              name: 'Saving',
                              color: ConstantColors.borderButtonColor,
                            ),
                            ColumnSeries<EnergyData, String>(
                              dataSource: energyDataList,
                              xValueMapper: (EnergyData data, _) {
                                if (energyType == "intraday") {
                                  return data.getFormattedTime();
                                } else if (energyType == "day" ||
                                    energyType == "week") {
                                  return data.getFormattedDate();
                                } else if (energyType == "month") {
                                  return data.getFormattedMonth();
                                } else if (energyType == "year") {
                                  return data.getFormattedYear();
                                } else {
                                  return "";
                                }
                              },
                              yValueMapper: (EnergyData data, _) =>
                                  data.totalCo2Emission,
                              name: 'Co2',
                              color: ConstantColors.appColor,
                            ),
                            ColumnSeries<EnergyData, String>(
                              dataSource: energyDataList,
                              xValueMapper: (EnergyData data, _) {
                                if (energyType == "intraday") {
                                  return data.getFormattedTime();
                                } else if (energyType == "day" ||
                                    energyType == "week") {
                                  return data.getFormattedDate();
                                } else if (energyType == "month") {
                                  return data.getFormattedMonth();
                                } else if (energyType == "year") {
                                  return data.getFormattedYear();
                                } else {
                                  return "";
                                }
                              },
                              yValueMapper: (EnergyData data, _) =>
                                  data.treesPlanted,
                              name: 'Tree Planted',
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    )
                    // : const CircularProgressIndicator(),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
