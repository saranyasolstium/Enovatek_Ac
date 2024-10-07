import 'dart:async';

import 'package:country_flags/country_flags.dart';
import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/model/billing.dart';
import 'package:enavatek_mobile/model/country_data.dart';
import 'package:enavatek_mobile/screen/billing/payment_service.dart';
import 'package:enavatek_mobile/screen/device_details/power_statistics.dart';
import 'package:enavatek_mobile/screen/menu/live_data.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/dynamic_font.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'package:intl/intl.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({
    Key? key,
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
  String consumption = "0";
  String totalBillAmount = "-";

  List<BillingData> billingDataList = [];
  List<SummaryBill> summaryBillList = [];
  late String currentMonthYear;

  @override
  void initState() {
    super.initState();
    currentMonthYear = getCurrentMonthYear();
    fetchData(currentMonthYear);
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
      billingDataList = [];
      summaryBillList = [];
      int? userId = await SharedPreferencesHelper.instance.getUserID();
      final result = await RemoteServices.consumptionBillStatus(
          [], userId!, 6, periodType);
      setState(() {
        billingDataList = result['billingData'];
        summaryBillList = result['summaryBill'];
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
      print(e);
    }
  }

  Future<void> countrySelection() async {
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
      });
      print('Selected date: ${dateController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          fontSize: 18.dynamic,
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
            child: const Icon(
              Icons.home,
              color: ConstantColors.iconColr,
              size: 30,
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
                        Container(
                          width: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey[400]!, width: 1.0),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: TextField(
                            controller: dateController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              hintText: "Select Date",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 12.0),
                            ),
                            onTap: () => selectMonthYear(context),
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
                                fontSize: 14.dynamic,
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
                                fontSize: 20.dynamic,
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
                                fontSize: 14.dynamic,
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
                                fontSize: 20.dynamic,
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
            Visibility(
              visible: billingDataList.isNotEmpty,
              child: Text(
                'Device code ($selectedMonth)',
                style: GoogleFonts.roboto(
                  fontSize: 18.dynamic,
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
                    child: DataTable(
                      columnSpacing: 10,
                      headingRowColor: MaterialStateProperty.all(
                          ConstantColors.darkBackgroundColor),
                      columns: [
                        DataColumn(label: _buildTableHeader("Device")),
                        DataColumn(label: _buildTableHeader("Consumption")),
                        DataColumn(label: _buildTableHeader("Savings")),
                        DataColumn(label: _buildTableHeader("Billed Amount")),
                      ],
                      rows: billingDataList.map((billing) {
                        return DataRow(
                          cells: [
                            DataCell(_buildTableCell(billing.deviceId)),
                            DataCell(_buildTableCell(
                                '${billing.totalConsumption.toString()} kwh')),
                            DataCell(_buildTableCell(
                                'S\$ ${billing.energySaving.toString()}')),
                            DataCell(_buildTableCell(
                                'S\$ ${billing.billAmount.toString()}')),
                          ],
                        );
                      }).toList(),
                    ),
                  )
                : Center(
                    child: Text(
                      'No Data Available',
                      style: GoogleFonts.roboto(
                        fontSize: 16.dynamic,
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
                      columnSpacing: 10,
                      headingRowColor: MaterialStateProperty.all(
                          ConstantColors.darkBackgroundColor),
                      columns: [
                        DataColumn(label: _buildTableHeader("")),
                        DataColumn(label: _buildTableHeader("Energy Saving")),
                        DataColumn(label: _buildTableHeader("Saving")),
                        DataColumn(label: _buildTableHeader("Tree Planted")),
                      ],
                      rows: summaryBillList.map((summary) {
                        return DataRow(
                          cells: [
                            DataCell(
                                _buildTableCell(summary.getFormattedPeriod())),
                            DataCell(
                                _buildTableCell('${summary.energySaving} kwh')),
                            DataCell(_buildTableCell('S\$ ${summary.saving}')),
                            DataCell(_buildTableCell(
                                summary.treesPlanted.toString()))
                          ],
                        );
                      }).toList(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.dynamic),
          topRight: Radius.circular(30.dynamic),
        ),
        child: BottomAppBar(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RoundedButton(
                onPressed: () {
                  // Navigator.pushNamed(context, loginRoute);
                },
                text: "Download Invoice",
                backgroundColor: ConstantColors.whiteColor,
                textColor: ConstantColors.borderButtonColor,
              ),
              RoundedButton(
                onPressed: () async {
                  double amountToPay = double.parse(totalBillAmount);
                  await PaymentService()
                      .createPaymentRequest(context, amountToPay);
                },
                text: "Pay now",
                backgroundColor: ConstantColors.borderButtonColor,
                textColor: ConstantColors.whiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTableHeader(String text) {
  return Text(
    text,
    style: GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
      fontSize: 15.dynamic,
      color: ConstantColors.appColor,
    ),
  );
}

Widget _buildTableCell(String text) {
  return Center(
      child: Text(
    text,
    style: GoogleFonts.roboto(
      fontSize: 14.dynamic,
      color: ConstantColors.appColor,
    ),
  ));
}
