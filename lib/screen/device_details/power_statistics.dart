import 'dart:async';
import 'dart:convert';

import 'package:country_flags/country_flags.dart';
import 'package:enavatek_mobile/app_state/app_state.dart';
import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/model/country_data.dart';
import 'package:enavatek_mobile/model/energy.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/menu/building/building.dart';
import 'package:enavatek_mobile/screen/menu/live_data.dart';
import 'package:enavatek_mobile/services/push_notification_service.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/dynamic_font.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/dropdown.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:country_picker/country_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:money2/money2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:share_extend/share_extend.dart';

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
    with TickerProviderStateMixin {
  String? totalPower = "", acPower = "", dcPower = "";

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
  ValueNotifier<int> countryId = ValueNotifier<int>(6);
  ValueNotifier<String> currencyCodeNotifier = ValueNotifier<String>("SGD");
  ValueNotifier<String> currencySymbolNotifier = ValueNotifier<String>("\$");

  ValueNotifier<double> acNotifier = ValueNotifier<double>(0);
  ValueNotifier<double> dcNotifier = ValueNotifier<double>(0);
  late TooltipBehavior _tooltipBehavior;

  List<EnergyData> intradayList = [];

  List<Building> buildings = [];
  List<Device> devices = [];
  final List<String> deviceList = [];
  late AnimationController _animationController;
  late Animation<int> _animation;
  final int _numberOfArrows = 5;

  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    getCountryCurrency(AppState().selectedCountryNotifier.value);
    getAllDevice();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
    );

    if (widget.tabIndex == 1) {
      energyNotiifer.value = true;
      savingNotiifer.value = false;
      treeNotiifer.value = false;
      selectedTabIndex.value = 0;
      energyType = "intraday";
    } else if (widget.tabIndex == 2) {
      energyNotiifer.value = false;
      savingNotiifer.value = true;
      treeNotiifer.value = false;
      selectedTabIndex.value = 1;
      energyType = "day";
    } else if (widget.tabIndex == 3) {
      energyNotiifer.value = false;
      savingNotiifer.value = false;
      treeNotiifer.value = true;
      selectedTabIndex.value = 2;
      energyType = "day";
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: false);

    _animation = IntTween(begin: 0, end: _numberOfArrows - 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _blinkController.dispose();

    super.dispose();
  }

  List<Device> getAllDevices(List<Building> buildings) {
    List<Device> allDevices = [];
    for (var building in buildings) {
      for (var floor in building.floors) {
        for (var room in floor.rooms) {
          allDevices.addAll(room.devices);
        }
      }
    }

    return allDevices;
  }

  Future<void> getAllDevice() async {
    await FirebaseApi().initNotifications();

    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? userId = await SharedPreferencesHelper.instance.getUserID();

    Response response =
        await RemoteServices.getAllDeviceByUserId(authToken!, userId!);

    if (response.statusCode == 200) {
      String responseBody = response.body;
      Map<String, dynamic> jsonData = json.decode(responseBody);

      if (jsonData.containsKey("buildings")) {
        List<dynamic> buildingList = jsonData["buildings"];
        buildings =
            buildingList.map((data) => Building.fromJson(data)).toList();
        setState(() {
          devices = getAllDevices(buildings);
          deviceList.clear();
          deviceList.addAll(
            devices
                .where((device) => device.power.toLowerCase() == 'on')
                .map((device) => device.deviceId),
          );
        });
        deviceList.forEach((deviceId) {
          print('Device ID: $deviceId');
        });
        fetchCountry(false);
        powerusages(periodType);
      } else {
        print('Response body does not contain buildings');
      }
    } else {
      print('Response body: ${response.body}');
    }
  }

  void updateTooltip() {
    setState(() {
      _tooltipBehavior = TooltipBehavior(enable: true);
    });
  }

  int getCountryIdByCurrencyType(String currencyType) {
    print('varshan $currencyType');
    for (var country in countryList) {
      if (country.currencyType.toLowerCase() == currencyType.toLowerCase()) {
        print(country.id);
        return country.id;
      }
    }
    // Return default value if no country matches
    print('Currency type $currencyType not found, returning default value 6');
    return 6;
  }

  Future<void> fetchData(String periodType) async {
    try {
      energyDataList = [];
      print(AppState().selectedCountryNotifier.value);
      getCountryCurrency(AppState().selectedCountryNotifier.value);

      int? userId = await SharedPreferencesHelper.instance.getUserID();
      int? countryId =
          getCountryIdByCurrencyType(AppState().selectedCountryNotifier.value);
      print(countryId);
      final data = await RemoteServices.fetchEnergyData(
          deviceId: deviceList,
          periodType: periodType.toLowerCase(),
          userId: userId!,
          countryId: countryId);
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

  Widget buildGraph(
      {required List<EnergyData> data, required BuildContext context}) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 350.dynamic,
      width: 1800.dynamic,
      child: SfCartesianChart(
        primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.Hm(),
          intervalType: DateTimeIntervalType.hours,
          interval: 1,
        ),
        primaryYAxis: NumericAxis(
          labelFormat: '{value}',
          title: AxisTitle(
            text: 'Energy Consumed (kWh)',
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.032,
            ),
          ),
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          shared: true,
          tooltipPosition: TooltipPosition.auto,
        ),
        series: <CartesianSeries>[
          ColumnSeries<EnergyData, DateTime>(
            dataSource: data,
            xValueMapper: (EnergyData data, _) {
              return data.getFormattedTimeAsDateTime();
            },
            yValueMapper: (EnergyData data, _) => data.acEnergyConsumed,
            name: 'AC Power',
            color: ConstantColors.borderButtonColor,
            enableTooltip: true,
          ),
          ColumnSeries<EnergyData, DateTime>(
            dataSource: data,
            xValueMapper: (EnergyData data, _) {
              return data.getFormattedTimeAsDateTime();
            },
            yValueMapper: (EnergyData data, _) => data.dcEnergyConsumed,
            name: 'DC Power',
            color: Colors.green,
            enableTooltip: true,
          ),
        ],
      ),
    );
  }

  Future<void> fetchCountry(bool status) async {
    try {
      String? authToken = await SharedPreferencesHelper.instance.getAuthToken();

      final data = await RemoteServices.fetchCountryList(token: authToken!);
      setState(() {
        countryList = data;
        fetchData(energyType);
        if (status) {
          countrySelection();
        }
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  String? getCurrencySymbol(String currencyCode) {
    try {
      final currency = Currencies().find(currencyCode);
      return currency?.symbol;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> getCountryCurrency(String countryCode) async {
    final response = await http
        .get(Uri.parse('https://restcountries.com/v3.1/alpha/$countryCode'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.isNotEmpty && data[0].containsKey('currencies')) {
        final currencies = data[0]['currencies'];

        currencies.forEach((code, details) {
          final name = details['name'];
          final symbol = details['symbol'];
          currencyCodeNotifier.value = code;
          setState(() {
            currencySymbolNotifier.value = getCurrencySymbol(code)!;
          });
          print('Currency Code: $code');
          print('Currency Name: $name');
          print('Currency Symbol1: ${currencySymbolNotifier.value}');
        });
      } else {
        print('Currency information not found');
      }
    } else {
      print('Failed to load country data');
    }
  }

  Future<void> powerusages(String periodType) async {
    DateTime currentDate = DateTime.now();
    String formattedDate =
        "${currentDate.day}-${currentDate.month}-${currentDate.year}";

    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? userId = await SharedPreferencesHelper.instance.getUserID();

    final response = await RemoteServices.powerusages(
        authToken!, deviceList, periodType, formattedDate, "all", userId!);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (!mounted) return;

      setState(() {
        totalPower = responseData['total_power'];
        acPower = responseData['ac_power'];
        dcPower = responseData['dc_power'];
        String acPowerValueStr = acPower!.replaceAll(RegExp(r'[^0-9.]'), '');
        String dcPowerValueStr = dcPower!.replaceAll(RegExp(r'[^0-9.]'), '');
        acNotifier.value = double.parse(acPowerValueStr);
        dcNotifier.value = double.parse(dcPowerValueStr);
      });
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('message') &&
          responseData['message'] == 'No record(s) found') {
        setState(() {
          totalPower = "0W";
          acPower = "0W";
          dcPower = "0W";
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

    double acMax = energyDataList.fold<double>(
        0.0,
        (max, data) =>
            data.acEnergyConsumed > max ? data.acEnergyConsumed : max);
    double dcMax = energyDataList.fold<double>(
        0.0,
        (max, data) =>
            data.dcEnergyConsumed > max ? data.dcEnergyConsumed : max);

    print(acMax);
    print(dcMax);

    double totalEnergy = acMax + dcMax;
    print(totalEnergy);

    if (totalEnergy == 0) {
      return 0.0;
    }

    double savingPercentage = (dcMax / totalEnergy) * 100;
    print(savingPercentage);

    return savingPercentage;
  }

  Future<void> countrySelection() async {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    String radioValue = AppState().selectedCountryNotifier.value.toUpperCase();
    String currency = "";
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
                              fontSize: 16.dynamic,
                              fontWeight: FontWeight.bold,
                              color: ConstantColors.appColor,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.dynamic),
                              child: const Icon(Icons.close),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.dynamic, bottom: 10.dynamic),
                        child: Divider(
                          thickness: 1.dynamic,
                          color: Colors.black12,
                        ),
                      ),
                      // Country Selection Radio Buttons
                      ...countryList.map((country) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CountryFlag.fromCountryCode(
                              country.currencyType.isNotEmpty
                                  ? country.currencyType
                                  : "sg",
                              shape: const Circle(),
                              height: 25.dynamic,
                              width: 25.dynamic,
                            ),
                            SizedBox(width: 20.dynamic),
                            Text(
                              country.name,
                              style: GoogleFonts.roboto(
                                fontSize: 14.dynamic,
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
                      SizedBox(height: 10.dynamic),
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
                        SizedBox(height: 10.dynamic),
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
                        SizedBox(height: 20.dynamic),
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
                              AppState().selectedCountryNotifier.value =
                                  radioValue;
                              energyNotiifer.value = true;
                              savingNotiifer.value = false;
                              treeNotiifer.value = false;
                              selectedTabIndex.value = 0;
                              fetchData('intraday');
                              energyType = "intraday";
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

  Future<void> requestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        var result = await Permission.storage.request();
        if (!result.isGranted) {
          throw Exception('Storage permission not granted');
        }
      }
    }
  }

  Future<void> exportCSV(
      String csvContent, String fileName, BuildContext context) async {
    await requestStoragePermission();

    Directory? directory;

    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      // Use app-specific external directory on Android
      directory = await getDownloadsDirectory();
    } else {
      throw UnsupportedError('Unsupported platform');
    }

    if (directory != null) {
      final path = '${directory.path}/$fileName';
      final file = File(path);

      try {
        await file.writeAsString(csvContent);

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('CSV downloaded successfully to $path')),
        // );

        print('File saved at $path');

        // Share the file after download
        ShareExtend.share(file.path, "file");
      } catch (e) {
        print('Error writing file: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download CSV: $e')),
        );
      }
    }
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

        exportCSV(csvContent, fileName, context);
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
                      SizedBox(width: 10.dynamic),
                      Text(
                        'Power Statistics',
                        style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.045,
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
              valueListenable: AppState().selectedCountryNotifier,
              builder: (context, value, child) {
                return CountryFlag.fromCountryCode(
                  value,
                  shape: const Circle(),
                  height: 30.dynamic,
                  width: 30.dynamic,
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
              height: 30.dynamic,
              width: 30.dynamic,
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
              height: 30.dynamic,
              width: 30.dynamic,
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
                  SizedBox(
                    height: 10.dynamic,
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
                              width: 50.dynamic,
                              height: 50.dynamic,
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        ValueListenableBuilder<double>(
                          valueListenable: dcNotifier,
                          builder: (context, dcValue, child) {
                            return dcValue < 50
                                ? Row(
                                    children: List.generate(
                                    _numberOfArrows,
                                    (index) => AnimatedBuilder(
                                      animation: _animation,
                                      builder: (context, child) {
                                        bool isLit = index == _animation.value;
                                        bool shouldAnimate =
                                            dcValue > 0 && dcValue <= 50;
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 1),
                                          child: AnimatedOpacity(
                                            opacity: (dcValue == 0 ||
                                                    dcValue > 50 ||
                                                    !shouldAnimate)
                                                ? 0.7
                                                : (isLit ? 1.0 : 0.6),
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: Image.asset(
                                              dcValue > (index * 10)
                                                  ? ImgPath.leftArrow1
                                                  : ImgPath.leftArrow2,
                                              color: dcValue > (index * 10)
                                                  ? ConstantColors.iconColr
                                                  : ConstantColors.arrowColor,
                                              height: 15,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ))
                                : Row(
                                    children: List.generate(
                                      _numberOfArrows,
                                      (index) => AnimatedBuilder(
                                        animation: _blinkController,
                                        builder: (context, child) {
                                          return AnimatedOpacity(
                                            opacity: _blinkController.value,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1),
                                              child: Image.asset(
                                                ImgPath.leftArrow1,
                                                height: 15,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                          },
                        ),
                        SizedBox(width: 30.dynamic),
                        Image.asset(
                          ImgPath.totalPower,
                          width: 50.dynamic,
                          height: 50.dynamic,
                        ),
                        SizedBox(width: 30.dynamic),
                        ValueListenableBuilder<double>(
                          valueListenable: acNotifier,
                          builder: (context, acValue, child) {
                            return Row(
                              children: List.generate(_numberOfArrows, (index) {
                                return acValue >= 50
                                    ? AnimatedBuilder(
                                        animation: _blinkController,
                                        builder: (context, child) {
                                          String imagePath;

                                          if (index == 0) {
                                            imagePath = acValue > 40
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                          } else if (index == 1) {
                                            imagePath = acValue > 30
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                          } else if (index == 2) {
                                            imagePath = acValue > 20
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                          } else if (index == 3) {
                                            imagePath = acValue > 10
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                          } else {
                                            imagePath = acValue > 0
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                          }

                                          return AnimatedOpacity(
                                            opacity: _blinkController.value,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1),
                                              child: Image.asset(
                                                imagePath,
                                                height: 15,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : AnimatedBuilder(
                                        animation: _animation,
                                        builder: (context, child) {
                                          bool isLit =
                                              (_numberOfArrows - 1) - index ==
                                                  _animation.value;

                                          bool shouldAnimate =
                                              acValue > 0 && acValue <= 50;
                                          Color color;

                                          String imagePath;
                                          if (index == 0) {
                                            imagePath = acValue > 40
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                            color = acValue > 40
                                                ? ConstantColors.iconColr
                                                : ConstantColors.arrowColor;
                                          } else if (index == 1) {
                                            imagePath = acValue > 30
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                            color = acValue > 30
                                                ? ConstantColors.iconColr
                                                : ConstantColors.arrowColor;
                                          } else if (index == 2) {
                                            imagePath = acValue > 20
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                            color = acValue > 20
                                                ? ConstantColors.iconColr
                                                : ConstantColors.arrowColor;
                                          } else if (index == 3) {
                                            imagePath = acValue > 10
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                            color = acValue > 10
                                                ? ConstantColors.iconColr
                                                : ConstantColors.arrowColor;
                                          } else {
                                            imagePath = acValue > 0
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                            color = acValue > 0
                                                ? ConstantColors.iconColr
                                                : ConstantColors.arrowColor;
                                          }

                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 1),
                                            child: AnimatedOpacity(
                                              opacity: (acValue == 0 ||
                                                      acValue > 50 ||
                                                      !shouldAnimate)
                                                  ? 0.7
                                                  : (isLit ? 1.0 : 0.6),
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              child: Image.asset(
                                                ImgPath.rightArrow5,
                                                height: 15,
                                                color: color,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                              }),
                            );
                          },
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              ImgPath.pngTower,
                              width: 50.dynamic,
                              height: 50.dynamic,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.dynamic),
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
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.black,
                              ),
                            ),
                            SizedBox(height: 10.dynamic),
                            Text(
                              dcPower!,
                              style: GoogleFonts.roboto(
                                fontSize: screenWidth * 0.045,
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
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.iconColr,
                              ),
                            ),
                            SizedBox(height: 10.dynamic),
                            Text(
                              totalPower!,
                              style: GoogleFonts.roboto(
                                fontSize: screenWidth * 0.045,
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
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.appColor,
                              ),
                            ),
                            SizedBox(height: 10.dynamic),
                            Text(
                              acPower!,
                              style: GoogleFonts.roboto(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.appColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.dynamic),
                ],
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: selectedTabIndex,
              builder: (context, value, child) {
                return Container(
                  color: ConstantColors.liveBgColor,
                  padding: EdgeInsets.symmetric(
                      horizontal: 40.dynamic, vertical: 10.dynamic),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(height: 10.dynamic),
                              Image.asset(
                                ImgPath.energyIcon,
                                width: 30.dynamic,
                                height: 30.dynamic,
                                color: value == 0
                                    ? ConstantColors.borderButtonColor
                                    : ConstantColors.appColor,
                              ),
                              SizedBox(height: 10.dynamic),
                              Text(
                                'Energy Saving',
                                style: GoogleFonts.roboto(
                                  fontSize: screenWidth * 0.032,
                                  fontWeight: FontWeight.bold,
                                  color: ConstantColors.black,
                                ),
                              ),
                              SizedBox(height: 10.dynamic),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            selectedTabIndex.value = 1;
                            energyNotiifer.value = false;
                            treeNotiifer.value = false;
                            savingNotiifer.value = true;
                            setState(() {
                              energyType = "day";
                            });
                            fetchData("day");
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10.dynamic),
                              Text(
                                currencySymbolNotifier.value == "\$"
                                    ? 'S${currencySymbolNotifier.value}'
                                    : currencySymbolNotifier.value,
                                style: GoogleFonts.roboto(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: value == 1
                                      ? ConstantColors.borderButtonColor
                                      : ConstantColors.appColor,
                                ),
                              ),
                              Text(
                                'Saving',
                                style: GoogleFonts.roboto(
                                  fontSize: screenWidth * 0.032,
                                  fontWeight: FontWeight.bold,
                                  color: ConstantColors.black,
                                ),
                              ),
                              SizedBox(height: 10.dynamic),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            selectedTabIndex.value = 2;
                            energyNotiifer.value = false;
                            treeNotiifer.value = true;
                            savingNotiifer.value = false;
                            fetchData("day");
                            setState(() {
                              energyType = "day";
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10.dynamic),
                              Image.asset(
                                ImgPath.treeIcon,
                                width: 30.dynamic,
                                height: 30.dynamic,
                                color: value == 2
                                    ? ConstantColors.borderButtonColor
                                    : ConstantColors.appColor,
                              ),
                              SizedBox(height: 10.dynamic),
                              Text(
                                'Tree Planted',
                                style: GoogleFonts.roboto(
                                  fontSize: screenWidth * 0.032,
                                  fontWeight: FontWeight.bold,
                                  color: ConstantColors.black,
                                ),
                              ),
                              SizedBox(height: 10.dynamic),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.dynamic, vertical: 10.dynamic),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10.dynamic,
                                    ),
                                    Text(
                                      'Total Energy Saving',
                                      style: GoogleFonts.roboto(
                                        fontSize: screenWidth * 0.032,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.dynamic,
                                    ),
                                    Text(
                                      '$totalEnergy %',
                                      style: GoogleFonts.roboto(
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          color:
                                              ConstantColors.borderButtonColor,
                                          width: 10.dynamic,
                                          height: 2.dynamic,
                                        ),
                                        SizedBox(
                                          width: 10.dynamic,
                                        ),
                                        Text(
                                          'AC',
                                          style: GoogleFonts.roboto(
                                            fontSize: screenWidth * 0.032,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.15,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          color: ConstantColors.greenColor,
                                          width: 10.dynamic,
                                          height: 2.dynamic,
                                        ),
                                        SizedBox(
                                          width: 10.dynamic,
                                        ),
                                        Text(
                                          'DC',
                                          style: GoogleFonts.roboto(
                                            fontSize: screenWidth * 0.032,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 120.dynamic,
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.dynamic, vertical: 10.dynamic),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10.dynamic,
                                    ),
                                    Text(
                                      'Total saving in ${currencyCodeNotifier.value}',
                                      style: GoogleFonts.roboto(
                                        fontSize: screenWidth * 0.032,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.dynamic,
                                    ),
                                    Text(
                                      totalSavings,
                                      style: GoogleFonts.roboto(
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 30.dynamic,
                                ),
                                SizedBox(
                                  width: 120.dynamic,
                                  child: CustomDropdownButton(
                                    value: "Day",
                                    items: const [
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
                                      if (value == "Day") {
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.dynamic, vertical: 10.dynamic),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Tree Planted',
                                      style: GoogleFonts.roboto(
                                        fontSize: screenWidth * 0.032,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.dynamic,
                                    ),
                                    Text(
                                      totalTree,
                                      style: GoogleFonts.roboto(
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10.dynamic,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          color: ConstantColors.greenColor,
                                          width: 10.dynamic,
                                          height: 2.dynamic,
                                        ),
                                        SizedBox(
                                          width: 5.dynamic,
                                        ),
                                        Text(
                                          'Tree Planted',
                                          style: GoogleFonts.roboto(
                                            fontSize: screenWidth * 0.032,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.dynamic,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          color:
                                              ConstantColors.borderButtonColor,
                                          width: 10.dynamic,
                                          height: 2.dynamic,
                                        ),
                                        SizedBox(
                                          width: 10.dynamic,
                                        ),
                                        Text(
                                          'S\$ Savings',
                                          style: GoogleFonts.roboto(
                                            fontSize: screenWidth * 0.032,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.dynamic,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          color: ConstantColors.appColor,
                                          width: 10.dynamic,
                                          height: 2.dynamic,
                                        ),
                                        SizedBox(
                                          width: 10.dynamic,
                                        ),
                                        Text(
                                          'CO2',
                                          style: GoogleFonts.roboto(
                                            fontSize: screenWidth * 0.032,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 15.dynamic,
                                ),
                                SizedBox(
                                  width: 120.dynamic,
                                  child: CustomDropdownButton(
                                    value: "Day",
                                    items: const [
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
                                      if (value == "Day") {
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
                      height: 25.dynamic,
                      width: 25.dynamic,
                      color: ConstantColors.iconColr,
                    )),
                const SizedBox(width: 20),
              ],
            ),
            SizedBox(
              height: 20.dynamic,
            ),
            ValueListenableBuilder(
              valueListenable: energyNotiifer,
              builder: (context, value, child) {
                return Visibility(
                    visible: energyNotiifer.value,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: energyType == "intraday"
                          ? Column(children: [
                              buildGraph(
                                  data: energyDataList, context: context),
                            ])
                          : Container(
                              height: 350.dynamic,
                              width: energyType == "day"
                                  ? 1800.dynamic
                                  : energyType == "month"
                                      ? 600.dynamic
                                      : 400.dynamic,
                              child: SfCartesianChart(
                                primaryXAxis: const CategoryAxis(
                                  interval: 1,
                                ),
                                primaryYAxis: NumericAxis(
                                  labelFormat: '{value}',
                                  title: AxisTitle(
                                    text: 'Energy Consumed (kWh)',
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.032,
                                    ),
                                  ),
                                ),
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
                        height: 350.dynamic,
                        width: energyType == "day"
                            ? 1800.dynamic
                            : energyType == "month"
                                ? 600.dynamic
                                : 400.dynamic,
                        child: SfCartesianChart(
                          primaryXAxis: const CategoryAxis(),
                          primaryYAxis: NumericAxis(
                            labelFormat: '{value}',
                            title: AxisTitle(
                              text: 'Saving in doller',
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.032,
                              ),
                            ),
                          ),
                          tooltipBehavior: _tooltipBehavior,
                          series: <CartesianSeries>[
                            LineSeries<EnergyData, String>(
                              dataSource: energyDataList,
                              enableTooltip: true,
                              xValueMapper: (EnergyData data, _) {
                                if (energyType == "day" ||
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
                              markerSettings: const MarkerSettings(
                                isVisible: true,
                                shape: DataMarkerType.pentagon,
                                borderWidth: 2,
                              ),
                              yValueMapper: (EnergyData data, _) =>
                                  data.energySaving,
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
                        height: 350.dynamic,
                        width: energyType == "day"
                            ? 2000.dynamic
                            : energyType == "month"
                                ? 800.dynamic
                                : 400.dynamic,
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
                                  data.dcCo2Reduction,
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
                    ));
              },
            ),
            SizedBox(
              height: 20.dynamic,
            ),
          ],
        ),
      ),
    );
  }
}
