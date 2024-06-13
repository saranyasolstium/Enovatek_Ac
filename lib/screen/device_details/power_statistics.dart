import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/circular_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';

class PowerStatisticsScreen extends StatefulWidget {
  final String deviceId;
  const PowerStatisticsScreen({
    Key? key,
    required this.deviceId,
  }) : super(key: key);

  @override
  PowerStatisticsScreenState createState() => PowerStatisticsScreenState();
}

class PowerStatisticsScreenState extends State<PowerStatisticsScreen>
    with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  TabController? _tabController;
  String? totalPower = "", acPower = "", dcPower = "";
  double? acValue = 0,
      dcValue = 0,
      acVoltage = 0,
      dcVoltgae = 0,
      acCurrent = 0,
      dcCurrent = 0,
      acEngery = 0,
      dcEngery = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    powerusages();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  // List<DeviceRealTimeData> acDcData = [];
  // Future<void> fetchDeviceRealTimeData() async {
  //   String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
  //   int? userId = await SharedPreferencesHelper.instance.getUserID();

  //   final response = await RemoteServices.fetchDeviceRealTimeData(authToken!);
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> responseData = json.decode(response.body);
  //     final DeviceRealTimeData deviceData =
  //         DeviceRealTimeData.fromJson(responseData);
  //     acDcData.add(deviceData);

  //     print('Device ID: ${deviceData.deviceId}');
  //     print('AC Voltage: ${deviceData.meterAC.voltage.value}');
  //   } else {
  //     throw Exception('Failed to load device real-time data');
  //   }
  // }
  Future<void> powerusages() async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();

    final response = await RemoteServices.powerusages(
        authToken!, widget.deviceId, "day", "12-06-2024", "all");
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        //totalPower = responseData['total_power'];
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
        String acEngeryStr =
            responseData['ac_energy'].replaceAll(RegExp(r'[^0-9.]'), '');
        String dcEngeryStr =
            responseData['dc_energy'].replaceAll(RegExp(r'[^0-9.]'), '');

        acValue = double.parse(acPowerValueStr);
        dcValue = double.parse(dcPowerValueStr);
        acVoltage = double.parse(acVoltageStr);
        dcVoltgae = double.parse(dcVoltageStr);
        acCurrent = double.parse(acCurrentStr);
        dcCurrent = double.parse(dcCurrentStr);
        acEngery = double.parse(acEngeryStr);
        dcEngery = double.parse(dcEngeryStr);

// Calculate total power
        double total = acValue! + dcValue!;

        totalPower = '$total W';
      });

      print('Total Power: $totalPower');
      print('AC Power: $acPower');
      print('DC Power: $dcPower');
    } else {
      throw Exception('Failed to load device real-time data');
    }
  }

  // Widget buildChart() {
  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
  //     child: SfCartesianChart(
  //       primaryXAxis: const CategoryAxis(
  //         labelRotation: 0,
  //         labelIntersectAction: AxisLabelIntersectAction.multipleRows,
  //       ),
  //       title: const ChartTitle(
  //         text: 'Historical Data',
  //         backgroundColor: Colors.white,
  //         borderColor: Colors.black,
  //         alignment: ChartAlignment.center,
  //         textStyle: TextStyle(
  //           color: Colors.black,
  //           fontFamily: 'Roboto',
  //           fontStyle: FontStyle.normal,
  //           fontSize: 20,
  //         ),
  //       ),
  //       series: <CartesianSeries>[
  //         // Change the series type to ColumnSeries
  //         ColumnSeries<ChartDataInfo, String>(
  //           dataSource: indexChart,
  //           pointColorMapper: (ChartDataInfo data, _) => data.color,
  //           xValueMapper: (ChartDataInfo data, _) => data.year,
  //           yValueMapper: (ChartDataInfo data, _) => data.value,
  //           enableTooltip: true,
  //           dataLabelSettings: const DataLabelSettings(
  //             isVisible: true,
  //             angle: 0,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDatePicker(BuildContext context, String mode) {
    List<Widget> dateWidgets = [];
    switch (mode) {
      case 'day':
        return SizedBox(
          height: 100,
          child: DatePicker(
            _selectedDate,
            selectionColor: ConstantColors.iconColr,
            selectedTextColor: Colors.white,
            initialSelectedDate: _selectedDate,
            onDateChange: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
        );
      case 'month':
        int currentMonthIndex = _selectedDate.month - 1;
        double initialScrollOffset = currentMonthIndex * 100.0;

        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 12,
            itemBuilder: (context, index) {
              DateTime monthDate = DateTime(_selectedDate.year, index + 1);
              return _buildDateItem(context, monthDate,
                  DateFormat.MMMM().format(monthDate), "month");
            },
            controller:
                ScrollController(initialScrollOffset: initialScrollOffset),
          ),
        );

      case 'year':
        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              int year = _selectedDate.year - 1 + index;
              return _buildDateItem(
                  context, DateTime(year, 1, 1), year.toString(), "year");
            },
          ),
        );
    }

    return Column(
      children: dateWidgets,
    );
  }

  Widget _buildDateItem(
      BuildContext context, DateTime date, String displayText, String type) {
    bool isSelected = false;
    if (type == 'month') {
      print('Month: ${date.month}');
      print(DateTime.now().month);
      isSelected = date.month == DateTime.now().month;
      print(isSelected);
    } else if (type == 'year') {
      isSelected = date.year == _selectedDate.year;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: Container(
        width: 100,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? ConstantColors.iconColr : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          displayText,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.darkBackgroundColor,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          ImgPath.pngArrowBack,
                          height: 25,
                          width: 25,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Power Statistics',
                        style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ConstantColors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
        child: Column(
          children: [
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
                    width: 80,
                  ),
                  Image.asset(
                    ImgPath.pngVector,
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Image.asset(
                    ImgPath.pngArrowBack,
                    color: ConstantColors.iconColr,
                    height: 15,
                  ),
                  Image.asset(
                    ImgPath.pngArrowBack,
                    color: ConstantColors.iconColr,
                    height: 15,
                  ),
                  Image.asset(
                    ImgPath.pngArrowBack,
                    color: ConstantColors.iconColr,
                    height: 15,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Image.asset(
                    ImgPath.pngTower,
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Total Power',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ConstantColors.black,
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
                          color: ConstantColors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        acPower!,
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ConstantColors.black,
                        ),
                      ),
                    ],
                  ),
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
                          color: ConstantColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Day'),
                      Tab(text: 'Month'),
                      Tab(text: 'Year'),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildDatePicker(context, 'day'),
                        _buildDatePicker(context, 'month'),
                        _buildDatePicker(context, 'year'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: CircularBar(
                    label: 'AC Power',
                    value: acValue!,
                    unit: "kw.h",
                    color: Colors.orange,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: CircularBar(
                    label: 'DC Power',
                    value: dcValue!,
                    unit: "kw.h",
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: CircularBar(
                    label: 'AC Voltage',
                    value: acVoltage!,
                    unit: "V",
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(width: 20), // Adjust the spacing between the bars
                Expanded(
                  child: CircularBar(
                    label: 'DC Voltage',
                    value: dcVoltgae!,
                    unit: "V",
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CircularBar(
                    label: 'AC Current',
                    value: acCurrent!,
                    unit: "A",
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 20), // Adjust the spacing between the bars
                Expanded(
                  child: CircularBar(
                    label: 'DC Current',
                    value: dcCurrent!,
                    unit: "A",
                    color: Colors.green,
                  ),
                ),
              ],
            ),
const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CircularBar(
                    label: 'AC Engery',
                    value: acEngery!,
                    unit: "kWh",
                    color: Colors.redAccent,
                  ),
                ),
                SizedBox(width: 20), // Adjust the spacing between the bars
                Expanded(
                  child: CircularBar(
                    label: 'DC Engery',
                    value: dcEngery!,
                    unit: "kWh",
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),

            // Container(
            //   color: Colors.white,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: <Widget>[
            //           IconButton(
            //             icon: const Icon(Icons.arrow_left),
            //             onPressed: _previousMonth,
            //           ),
            //           Text(
            //             DateFormat.MMMM().format(_selectedDate),
            //             style: const TextStyle(
            //               fontSize: 18,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.black,
            //             ),
            //           ),
            //           IconButton(
            //             icon: const Icon(Icons.arrow_right),
            //             onPressed: _nextMonth,
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 10),
            //       SizedBox(
            //         height: 100,
            //         child: DatePicker(
            //           _selectedDate,
            //           initialSelectedDate: DateTime.now(),
            //           selectionColor: ConstantColors.iconColr,
            //           selectedTextColor: Colors.white,
            //           onDateChange: (date) {
            //             setState(() {
            //               _selectedDate = date;
            //             });
            //           },
            //         ),
            //       ),
            //       const SizedBox(height: 30),
            //     ],
            //   ),
            // ),
            // Container(
            //   color: Colors.white,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       const SizedBox(height: 10),
            //       buildChart(),
            //       const SizedBox(height: 30),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
