import 'dart:async';

import 'package:country_flags/country_flags.dart';
import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/model/country_data.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/device_details/power_statistics.dart';
import 'package:enavatek_mobile/screen/menu/live_data.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/dynamic_font.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/dropdown.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  late List<String> months;
  late String selectedMonth;

  final List<Map<String, dynamic>> deviceData = [
    {
      "code": "1548",
      "consumption": "2 kwh",
      "savings": "S\$50",
      "billed": "S\$200"
    },
    {
      "code": "1549",
      "consumption": "2.1 kwh",
      "savings": "S\$45",
      "billed": "S\$220"
    },
    {
      "code": "1550",
      "consumption": "2.3 kwh",
      "savings": "S\$42",
      "billed": "S\$230"
    },
    {
      "code": "1551",
      "consumption": "3 kwh",
      "savings": "S\$47",
      "billed": "S\$310"
    },
    {
      "code": "1552",
      "consumption": "3.1 kwh",
      "savings": "S\$52",
      "billed": "S\$320"
    },
  ];

  @override
  void initState() {
    super.initState();
    int currentMonthIndex = DateTime.now().month;
    int currentYear = DateTime.now().year;

    months = [for (int i = 0; i < 12; i++) "${_getMonthName(i)} $currentYear"];

    selectedMonth = months[currentMonthIndex - 1];
    months.add("Previous bill");
  }

  String _getMonthName(int index) {
    const monthNames = [
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
    return monthNames[index];
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
                        print('sranya321 ${country.currencyType}');
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
                        SizedBox(
                          width: 120.dynamic,
                          child: CustomDropdownButton(
                            value: selectedMonth,
                            items: months.map((String month) {
                              return DropdownMenuItem<String>(
                                value: month,
                                child: Text(month),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedMonth = value!;
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
                                fontSize: 14.dynamic,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.appColor,
                              ),
                            ),
                            SizedBox(
                              height: 5.dynamic,
                            ),
                            Text(
                              '11kw.h',
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
                              'S\$ 3000',
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
            Text(
              'Device code (1 Sep 2024 - 19 Sep 2024)',
              style: GoogleFonts.roboto(
                fontSize: 18.dynamic,
                fontWeight: FontWeight.bold,
                color: ConstantColors.appColor,
              ),
            ),
            SizedBox(
              height: 20.dynamic,
            ),
            Card(
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
                rows: deviceData.map((data) {
                  return DataRow(
                    cells: [
                      DataCell(_buildTableCell(data["code"])),
                      DataCell(_buildTableCell(data["consumption"].toString())),
                      DataCell(_buildTableCell(data["savings"].toString())),
                      DataCell(_buildTableCell(data["billed"].toString())),
                    ],
                  );
                }).toList(),
              ),
            )
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
                onPressed: () {
                  //Navigator.pushNamed(context, loginRoute);
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
