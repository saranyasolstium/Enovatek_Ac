import 'dart:async';
import 'dart:convert';

import 'package:country_flags/country_flags.dart';
import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/model/billing.dart';
import 'package:enavatek_mobile/model/country_data.dart';
import 'package:enavatek_mobile/screen/billing/payment_service.dart';
import 'package:enavatek_mobile/screen/billing/pdf_viewer.dart';
import 'package:enavatek_mobile/screen/device_details/power_statistics.dart';
import 'package:enavatek_mobile/screen/menu/building/building.dart';
import 'package:enavatek_mobile/screen/menu/live_data.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/dynamic_font.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/dropdown.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'package:intl/intl.dart';

class BillingScreen extends StatefulWidget {
  final String monthYear;
  const BillingScreen({
    Key? key,
    required this.monthYear,
  }) : super(key: key);

  @override
  BillingScreenState createState() => BillingScreenState();
}

class BillingScreenState extends State<BillingScreen>
    with TickerProviderStateMixin {
  ValueNotifier<String> selectedCountryNotifier = ValueNotifier<String>('sg');
  List<CountryData> countryList = [];
  TextEditingController dateController = TextEditingController();

  late List<String> months;
  late String selectedMonth = "";
  late String selectedMonthYear = "";
  String consumption = "0";
  String totalBillAmount = "-";
  bool isLoading = false;

  List<BillingData> billingDataList = [];
  List<SummaryBill> summaryBillList = [];
  late String currentMonthYear = "OCT-24";

  List<Building> buildings = [];
  List<Device> devices = [];
  final List<String> deviceList = [];
  SummaryDetail? summaryDetail;

  List<String> last12Months = [];
  DateTime currentDate = DateTime.now();

  List<String> monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  void initState() {
    super.initState();
    // selectedMonthYear = getCurrentMonthYear();
    // currentMonthYear = getCurrentMonthYear();
    selectedMonthYear = widget.monthYear;
    currentMonthYear = widget.monthYear;
    dateController.text = widget.monthYear; //extra add

    for (int i = 0; i < 12; i++) {
      DateTime month = DateTime(currentDate.year, currentDate.month - i);
      String formattedMonth =
          "${monthNames[month.month - 1]}-${month.year % 100}";
      last12Months.add(formattedMonth);
      print(last12Months);
    }
    last12Months.add("Previous");

    last12Months = last12Months.reversed.toList();

    print(last12Months);
    getAllDevice();
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
        fetchData(currentMonthYear);
        // paymentStatus();
      } else {
        print('Response body does not contain buildings');
      }
    } else {
      print('Response body: ${response.body}');
    }
  }

  String getCurrentMonthYear() {
    DateTime now = DateTime.now();
    dateController.text = DateFormat('MMM yy').format(now).toString();
    return DateFormat('MMM-yy').format(now);
  }

  String formatPeriod(String period) {
    List<String> dates = period.split(' - ');

    if (dates.length == 2) {
      DateTime startDate = DateTime.parse(dates[0]);
      DateTime endDate = DateTime.parse(dates[1]);
      String formattedStartDate = DateFormat('dd MMM yyyy').format(startDate);
      String formattedEndDate = DateFormat('dd MMM yyyy').format(endDate);

      return '$formattedStartDate - $formattedEndDate';
    } else {
      throw Exception('Invalid period format');
    }
  }

  String calculateTotalConsumption(List<BillingData> billingDataList) {
    double totalConsumption = 0.0;

    for (var data in billingDataList) {
      totalConsumption += data.totalConsumption;
    }

    setState(() {
      consumption = totalConsumption.toStringAsFixed(2);
      print('Saranya $consumption');
    });

    return consumption;
  }

  String calculateTotalBillAmount(List<BillingData> billingDataList) {
    double totalBill = 0.0;

    for (var data in billingDataList) {
      totalBill += double.tryParse(data.billAmount) ?? 0.0;
    }

    setState(() {
      totalBillAmount = totalBill.toStringAsFixed(2);
      print(totalBillAmount);
    });

    return totalBillAmount;
  }

  Future<void> fetchData(String periodType) async {
    try {
      setState(() {
        isLoading = true; // Start loading
      });

      billingDataList = [];
      summaryBillList = [];
      int? userId = await SharedPreferencesHelper.instance.getUserID();
      final result = await RemoteServices.consumptionBillStatus(
          deviceList, userId!, 6, periodType);

      setState(() {
        billingDataList = result['billingData'];
        summaryBillList = result['summaryBill'];
        summaryDetail = result['summaryDetail'];
        selectedMonthYear = periodType;

        selectedMonth = formatPeriod(billingDataList.first.period);
        if (billingDataList.isNotEmpty) {
          consumption = calculateTotalConsumption(billingDataList);
          totalBillAmount = calculateTotalBillAmount(billingDataList);
        } else {
          consumption = "0";
          totalBillAmount = "0";
        }
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  // Future<void> fetchData(String periodType) async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });

  //     billingDataList = [];
  //     summaryBillList = [];
  //     int? userId = await SharedPreferencesHelper.instance.getUserID();
  //     final result = await RemoteServices.consumptionBillStatus(
  //         deviceList, userId!, 6, periodType);
  //     setState(() {
  //       billingDataList = result['billingData'];
  //       summaryBillList = result['summaryBill'];
  //       summaryDetail = result['summaryDetail'];

  //       selectedMonth = formatPeriod(billingDataList.first.period);
  //       if (billingDataList.isNotEmpty) {
  //         consumption = calculateTotalConsumption(billingDataList);
  //         totalBillAmount = calculateTotalBillAmount(billingDataList);
  //       } else {
  //         consumption = "0";
  //         totalBillAmount = "0";
  //       }
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

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
      print(e);
    }
  }

  Future<void> countrySelection() async {
    final double screenWidth = MediaQuery.of(context).size.width;

    String radioValue = selectedCountryNotifier.value.toUpperCase();

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
                              fontSize: screenWidth * 0.045,
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
                                fontSize: screenWidth * 0.035,
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
                      RoundedButton(
                          text: "Apply",
                          backgroundColor: ConstantColors.borderButtonColor,
                          textColor: ConstantColors.whiteColor,
                          onPressed: () {
                            setState(() {
                              print(radioValue);
                              selectedCountryNotifier.value = radioValue;
                              Navigator.pop(context);
                            });
                          }),
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

  Future<void> selectMonthYear(BuildContext context) async {
    final selected = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2030),
    );

    if (selected != null) {
      setState(() {
        dateController.text = DateFormat('MMM yyyy').format(selected);
        fetchData(DateFormat('MMM-yy').format(selected).toString());
        selectedMonthYear = DateFormat('MMM-yy').format(selected).toString();
      });
      print('Selected date: ${dateController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: ConstantColors.liveBgColor,
        appBar: AppBar(
          backgroundColor: ConstantColors.liveBgColor,
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
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            ImgPath.pngArrowBack,
                            height: 22,
                            width: 22,
                            color: ConstantColors.appColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Billing',
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
                valueListenable: selectedCountryNotifier,
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PowerStatisticsScreen(
                      deviceId: "",
                      deviceList: [],
                      tabIndex: 1,
                    ),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: Icon(
                Icons.home,
                color: ConstantColors.iconColr,
                size: 30.dynamic,
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
              SizedBox(
                height: 10.dynamic,
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.dynamic, vertical: 10.dynamic),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 120.dynamic,
                            child: CustomDropdownButton(
                              value: currentMonthYear,
                              items: last12Months.map((month) {
                                return DropdownMenuItem(
                                  value: month,
                                  child: Text(month),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  if (value == "Previous") {
                                    // Show the popup
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Contact Support"),
                                          content: Text(
                                            "To view previous records, please email the support team at sales@enovatek.com.",
                                            style: GoogleFonts.roboto(
                                              fontSize: screenWidth * 0.035,
                                              color: ConstantColors.appColor,
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text("OK"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    fetchData(value!);
                                  }
                                });
                              },
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.dynamic,
                              ),
                              Text(
                                'Consumption',
                                style: GoogleFonts.roboto(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.bold,
                                  color: ConstantColors.appColor,
                                ),
                              ),
                              SizedBox(
                                height: 5.dynamic,
                              ),
                              Text(
                                billingDataList.isNotEmpty
                                    ? '$consumption kw.h'
                                    : '0 kw.h',
                                style: GoogleFonts.roboto(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                  color: ConstantColors.appColor,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.dynamic,
                              ),
                              Text(
                                'Billed Amount',
                                style: GoogleFonts.roboto(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.bold,
                                  color: ConstantColors.appColor,
                                ),
                              ),
                              SizedBox(
                                height: 5.dynamic,
                              ),
                              Text(
                                billingDataList.isNotEmpty
                                    ? 'S\$ $totalBillAmount'
                                    : 'S\$ 0',
                                style: GoogleFonts.roboto(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                  color: ConstantColors.appColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.dynamic,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.dynamic),
                child: Divider(
                  height: 2.dynamic,
                  color: ConstantColors.dividerColor,
                ),
              ),
              SizedBox(
                height: 20.dynamic,
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: ConstantColors.appColor,
                      ),
                    )
                  : Visibility(
                      visible: billingDataList.isNotEmpty,
                      child: Text(
                        'Device code ($selectedMonth)',
                        style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                          color: ConstantColors.appColor,
                        ),
                      ),
                    ),
              SizedBox(
                height: 20.dynamic,
              ),
              billingDataList.isNotEmpty
                  ? Card(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 30,
                          headingRowColor: MaterialStateProperty.all(
                              ConstantColors.darkBackgroundColor),
                          columns: [
                            DataColumn(
                                label: _buildTableHeader("Device", context)),
                            DataColumn(
                                label:
                                    _buildTableHeader("Consumption", context)),
                            DataColumn(
                                label: _buildTableHeader("Savings", context)),
                            DataColumn(
                                label: _buildTableHeader("Amount", context)),
                            DataColumn(
                                label: _buildTableHeader("Due Date", context)),
                            DataColumn(
                                label: _buildTableHeader("Due By", context)),
                            DataColumn(
                                label: _buildTableHeader("Paid Date", context)),
                          ],
                          rows: billingDataList.map((billing) {
                            return DataRow(
                              cells: [
                                DataCell(
                                    _buildTableCell(billing.deviceId, context)),
                                DataCell(_buildTableCell(
                                    '${billing.totalConsumption.toString()} kwh',
                                    context)),
                                DataCell(_buildTableCell(
                                    'S\$ ${billing.energySaving.toString()}',
                                    context)),
                                DataCell(_buildTableCell(
                                    'S\$ ${billing.billAmount.toString()}',
                                    context)),
                                DataCell(_buildTableCell(
                                    billing.getFormattedBillDate(), context)),
                                DataCell(_buildTableCell(
                                    billing.getFormattedDueDate(), context)),
                                DataCell(_buildTableCell(
                                    billing.getFormattedDate(), context)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        '',
                        // 'No Data Available',
                        style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.bold,
                          color: ConstantColors.appColor,
                        ),
                      ),
                    ),
              SizedBox(
                height: 20.dynamic,
              ),
              summaryBillList.isNotEmpty
                  ? Card(
                      color: Colors.white,
                      child: DataTable(
                        columnSpacing: 15,
                        headingRowColor: MaterialStateProperty.all(
                            ConstantColors.darkBackgroundColor),
                        columns: [
                          DataColumn(
                            label: _buildTableHeader("", context),
                          ),
                          DataColumn(
                              label:
                                  _buildTableHeader("Energy Saving", context)),
                          DataColumn(
                              label: _buildTableHeader("Saving", context)),
                          DataColumn(
                              label:
                                  _buildTableHeader("Tree Planted", context)),
                        ],
                        rows: summaryBillList.map((summary) {
                          return DataRow(
                            cells: [
                              DataCell(_buildLeftTableCell(
                                  summary.getFormattedPeriod(), context)),
                              DataCell(_buildTableCell(
                                  '${summary.energySaving} kwh', context)),
                              DataCell(_buildTableCell(
                                  'S\$ ${summary.saving}', context)),
                              DataCell(_buildTableCell(
                                  summary.treesPlanted.toString(), context))
                            ],
                          );
                        }).toList(),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        bottomNavigationBar: Visibility(
          visible: billingDataList.isNotEmpty && summaryBillList.isNotEmpty,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.dynamic),
              topRight: Radius.circular(30.dynamic),
            ),
            child: BottomAppBar(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (summaryDetail?.billStatus != "pending")
                    RoundedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFViewerScreen(
                              paymentId: summaryDetail?.paymentId,
                            ),
                          ),
                        );
                      },
                      text: "Download Invoice",
                      backgroundColor: ConstantColors.whiteColor,
                      textColor: ConstantColors.borderButtonColor,
                    ),
                  RoundedButton(
                    onPressed: () async {
                      if (summaryDetail?.billStatus == "pending") {
                        double amountToPay = double.parse(totalBillAmount);
                        print(selectedMonthYear);
                        if (amountToPay <= 0.3) {
                          SnackbarHelper.showSnackBar(
                            context,
                            "The amount must be between 0.3 and 999999999.99.",
                          );
                        } else {
                          await PaymentService().createPaymentRequest(
                            context,
                            amountToPay,
                            deviceList,
                            selectedMonthYear,
                          );
                        }
                      } else {
                        SnackbarHelper.showSnackBar(
                          context,
                          "You have already made the payment.",
                        );
                      }
                    },
                    text: summaryDetail?.billStatus == "pending"
                        ? "Pay now"
                        : "Paid",
                    backgroundColor: ConstantColors.borderButtonColor,
                    textColor: ConstantColors.whiteColor,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

Widget _buildTableHeader(String text, BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;

  return Text(
    text,
    style: GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
      fontSize: screenWidth * 0.035,
      color: ConstantColors.appColor,
    ),
  );
}

Widget _buildLeftTableCell(String text, BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;

  return Container(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      textAlign: TextAlign.left,
      style: GoogleFonts.roboto(
        fontSize: screenWidth * 0.035,
        color: ConstantColors.appColor,
      ),
    ),
  );
}

Widget _buildTableCell(String text, BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;

  return Container(
    alignment: Alignment.center,
    child: Text(
      text,
      textAlign: TextAlign.left,
      style: GoogleFonts.roboto(
        fontSize: screenWidth * 0.035,
        color: ConstantColors.appColor,
      ),
    ),
  );
}
