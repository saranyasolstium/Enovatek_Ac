import 'package:enavatek_mobile/screen/device_details/chart.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PowerStatisticsScreen extends StatefulWidget {
  const PowerStatisticsScreen({
    Key? key,
  }) : super(key: key);

  @override
  PowerStatisticsScreenState createState() => PowerStatisticsScreenState();
}

class PowerStatisticsScreenState extends State<PowerStatisticsScreen> {
  DateTime _selectedDate = DateTime.now();

  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
    });
  }

 Widget buildChart() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelRotation: 0,
          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        ),
        title: ChartTitle(
          text: 'Historical Data',
          backgroundColor: Colors.white,
          borderColor: Colors.black,
          alignment: ChartAlignment.center,
          textStyle: const TextStyle(
            color: Colors.black,
            fontFamily: 'Roboto',
            fontStyle: FontStyle.normal,
            fontSize: 20,
          ),
        ),
        series: <CartesianSeries>[
          // Change the series type to ColumnSeries
          ColumnSeries<ChartDataInfo, String>(
            dataSource: indexChart,
            pointColorMapper: (ChartDataInfo data, _) => data.color,
            xValueMapper: (ChartDataInfo data, _) => data.year,
            yValueMapper: (ChartDataInfo data, _) => data.value,
            enableTooltip: true,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              angle: 0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ConstantColors.darkBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: AppBar(
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
            const SizedBox(height: 20),
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
                        '1.24 kw.h',
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
                        '1.24 kw.h',
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
                        '0 kw.h',
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.arrow_left),
                        onPressed: _previousMonth,
                      ),
                      Text(
                        DateFormat.MMMM().format(_selectedDate),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_right),
                        onPressed: _nextMonth,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: DatePicker(
                      _selectedDate,
                      initialSelectedDate: DateTime.now(),
                      selectionColor: ConstantColors.iconColr,
                      selectedTextColor: Colors.white,
                      onDateChange: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 10),
                  buildChart(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
