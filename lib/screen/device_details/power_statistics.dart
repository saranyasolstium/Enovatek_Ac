import 'dart:async';
import 'dart:convert';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/model/energy.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/circular_bar.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:horizontal_date_picker_flutter/horizontal_date_picker_flutter.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PowerStatisticsScreen extends StatefulWidget {
  final String deviceId;
  const PowerStatisticsScreen({
    Key? key,
    required this.deviceId,
  }) : super(key: key);

  @override
  PowerStatisticsScreenState createState() => PowerStatisticsScreenState();
}

List<ChartData> prepareChartData(List<EnergyData> data, String energyType) {
  return data
      .map((e) => ChartData(
            date: e.date,
            value: energyType == 'ac' ? e.acEnergy : e.dcEnergy,
          ))
      .toList();
}

class ChartData {
  final DateTime date;
  final double value;

  ChartData({required this.date, required this.value});
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
      acEnergy = 0,
      dcEnergy = 0;
  Timer? timer;
  List<EnergyData> energyDataList = [];
  bool _loading = false;
  String periodType = "day";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    DateTime currentDate = DateTime.now();
    String formattedDate =
        "${currentDate.day}-${currentDate.month}-${currentDate.year}";
    powerusages("day", formattedDate);
    updatePowerUsages("day", formattedDate);
    fetchData(widget.deviceId, periodType, formattedDate);
  }

  Future<void> fetchData(
      String deviceid, String periodType, String value) async {
    try {
      final data = await RemoteServices.fetchEnergyData(
        deviceId: deviceid,
        periodType: periodType,
        periodValue: value,
      );
      setState(() {
        energyDataList = data;
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  void updatePowerUsages(String periodType, String value) {
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      powerusages(periodType, value);
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    stopTimer();
    super.dispose();
  }

  void stopTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
      print("Timer stopped");
    }
  }

  Future<void> powerusages(String periodType, String periodValue) async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();

    final response = await RemoteServices.powerusages(
        authToken!, widget.deviceId, periodType, periodValue, "all");
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

  Widget _buildDatePicker(BuildContext context, String mode) {
    switch (mode) {
      case 'day':
        return Center(
            child: EasyDateTimeLine(
          initialDate: DateTime.now(),
          onDateChange: (selectedDate) {
            String formattedDate =
                DateFormat('dd-MM-yyyy').format(selectedDate);
            stopTimer();
            powerusages("day", formattedDate);
            updatePowerUsages("day", formattedDate);
            periodType = "day";
            fetchData(widget.deviceId, periodType, formattedDate);
          },
          activeColor: const Color(0xff116A7B),
          dayProps: const EasyDayProps(
            landScapeMode: true,
            activeDayStyle: DayStyle(
              borderRadius: 48.0,
            ),
            dayStructure: DayStructure.monthDayNumDayStr,
          ),
          headerProps: const EasyHeaderProps(showHeader: false),
        ));

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

    return const SizedBox.shrink();
  }

  Widget _buildDateItem(
      BuildContext context, DateTime date, String displayText, String type) {
    bool isSelected = false;
    if (type == 'month') {
      isSelected = date.month == _selectedDate.month;
    } else if (type == 'year') {
      isSelected = date.year == _selectedDate.year;
    }

    return GestureDetector(
        onTap: () {
          setState(() {
            _selectedDate = date;
            if (type == 'month') {
              String monthName = DateFormat('MMMM').format(_selectedDate);
              print(monthName);
              stopTimer();
              powerusages("month", monthName);
              updatePowerUsages("month", monthName);
              periodType = "month";
              fetchData(widget.deviceId, periodType, monthName);
            } else {
              String year = DateFormat('yyyy').format(_selectedDate);
              print(year);
              stopTimer();
              powerusages("year", year);
              updatePowerUsages("year", year);
              periodType = "year";
              fetchData(widget.deviceId, periodType, year);
            }
          });
        },
        child: Center(
          child: Container(
            width: 120,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xff116A7B) : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              displayText,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final acPowerData = prepareChartData(energyDataList, 'ac');
    final dcPowerData = prepareChartData(energyDataList, 'dc');
    return Scaffold(
      backgroundColor: ConstantColors.darkBackgroundColor,
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
                    onTap: (index) {
                      // Handle tab selection
                      switch (index) {
                        case 0:
                          _selectedDate = DateTime.now();
                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(_selectedDate);
                          stopTimer();
                          powerusages("day", formattedDate);
                          updatePowerUsages("day", formattedDate);
                          periodType = "day";
                          fetchData(widget.deviceId, periodType, formattedDate);

                          break;
                        case 1:
                          _selectedDate = DateTime.now();
                          String monthName =
                              DateFormat('MMMM').format(_selectedDate);
                          print(monthName);
                          stopTimer();
                          powerusages("month", monthName);
                          updatePowerUsages("month", monthName);
                          periodType = "month";
                          fetchData(widget.deviceId, periodType, monthName);

                          break;
                        case 2:
                          _selectedDate = DateTime.now();
                          String year =
                              DateFormat('yyyy').format(_selectedDate);
                          stopTimer();
                          powerusages("year", year);
                          updatePowerUsages("year", year);
                          periodType = "year";
                          fetchData(widget.deviceId, periodType, year);

                          break;
                      }
                    },
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
            const SizedBox(height: 30),

            Text(
              "Real Time Power Consumption",
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ConstantColors.iconColr,
              ),
            ),
            const SizedBox(height: 20),
            periodType == "year"
                ? SfCartesianChart(
                    primaryXAxis: DateTimeAxis(
                      dateFormat: DateFormat.MMM(),
                      interval: 1,
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      majorGridLines: const MajorGridLines(width: 0),
                      minimum: DateTime(DateTime.now().year, 1, 1),
                      maximum: DateTime(DateTime.now().year + 1, 1, 1),
                    ),
                    primaryYAxis: const NumericAxis(
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      labelFormat: '{value} kWh',
                    ),
                    series: <CartesianSeries>[
                      LineSeries<ChartData, DateTime>(
                        dataSource: acPowerData,
                        xValueMapper: (ChartData data, _) => data.date,
                        yValueMapper: (ChartData data, _) => data.value,
                        name: 'AC Energy',
                        color: Colors.blue,
                      ),
                      LineSeries<ChartData, DateTime>(
                        dataSource: dcPowerData,
                        xValueMapper: (ChartData data, _) => data.date,
                        yValueMapper: (ChartData data, _) => data.value,
                        name: 'DC Energy',
                        color: Colors.red,
                      ),
                    ],
                  )
                : periodType == "month"
                    ? SizedBox(
                        height: 300,
                        child: SfCartesianChart(
                          primaryXAxis: DateTimeAxis(
                            dateFormat: DateFormat.d(),
                            interval: 1,
                            edgeLabelPlacement: EdgeLabelPlacement.shift,
                          ),
                          primaryYAxis: const NumericAxis(
                            edgeLabelPlacement: EdgeLabelPlacement.shift,
                            labelFormat: '{value} kWh',
                          ),
                          series: <CartesianSeries>[
                            LineSeries<ChartData, DateTime>(
                              dataSource: acPowerData,
                              xValueMapper: (ChartData data, _) => data.date,
                              yValueMapper: (ChartData data, _) => data.value,
                              name: 'AC Energy',
                              color: Colors.blue,
                            ),
                            LineSeries<ChartData, DateTime>(
                              dataSource: dcPowerData,
                              xValueMapper: (ChartData data, _) => data.date,
                              yValueMapper: (ChartData data, _) => data.value,
                              name: 'DC Energy',
                              color: Colors.red,
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 300,
                        child: SfCartesianChart(
                          primaryXAxis: DateTimeAxis(
                            dateFormat: DateFormat('H'),
                            interval: 1,
                            intervalType: DateTimeIntervalType.hours,
                            edgeLabelPlacement: EdgeLabelPlacement.shift,
                            majorGridLines: const MajorGridLines(width: 0),
                            minimum: DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day),
                            maximum: DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                23,
                                59),
                          ),
                          primaryYAxis: const NumericAxis(
                            edgeLabelPlacement: EdgeLabelPlacement.shift,
                            labelFormat: '{value} kWh',
                          ),
                          series: <CartesianSeries>[
                            LineSeries<ChartData, DateTime>(
                              dataSource: acPowerData,
                              xValueMapper: (ChartData data, _) => data.date,
                              yValueMapper: (ChartData data, _) => data.value,
                              name: 'AC Energy',
                              color: Colors.blue,
                            ),
                            LineSeries<ChartData, DateTime>(
                              dataSource: dcPowerData,
                              xValueMapper: (ChartData data, _) => data.date,
                              yValueMapper: (ChartData data, _) => data.value,
                              name: 'DC Energy',
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
            Row(
              children: [
                Expanded(
                  child: CircularBar(
                    label: 'AC Energy',
                    value: acEnergy!,
                    unit: "kWh",
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CircularBar(
                    label: 'DC Energy',
                    value: dcEnergy!,
                    unit: "kWh",
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: CircularBar(
                    label: 'AC Power',
                    value: acValue!,
                    unit: "W",
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CircularBar(
                    label: 'DC Power',
                    value: dcValue!,
                    unit: "W",
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
                const SizedBox(
                    width: 20), // Adjust the spacing between the bars
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
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CircularBar(
                    label: 'DC Current',
                    value: dcCurrent!,
                    unit: "A",
                    color: Colors.teal,
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
