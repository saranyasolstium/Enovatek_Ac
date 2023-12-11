import 'package:flutter/material.dart';

class ChartData {
  ChartData(this.mobile, this.sale, [this.color]);

  final String mobile;
  final double sale;
  final Color? color;
}

class ChartDataInfo {
  ChartDataInfo(this.year, this.value, [this.color]);

  final String year;
  final double value;
  final Color? color;
}

final List<ChartData> chartData = [
  ChartData('Apple', 80.5, Color.fromRGBO(114, 112, 148, 1)),
  ChartData('iPhone', 38, Color.fromRGBO(147, 0, 119, 1)),
  ChartData('Android', 34, Color.fromRGBO(228, 0, 124, 1)),
  ChartData('Vivo', 52, Color.fromARGB(255, 59, 19, 41)),
  ChartData('MI', 52, Color.fromARGB(255, 223, 215, 67)),
  ChartData('Redmi', 12, Color.fromARGB(255, 7, 170, 118)),
  ChartData('Others', 32, Color.fromARGB(255, 96, 3, 54)),
];

final List<ChartDataInfo> indexChart = [
  ChartDataInfo('2013', 25.5, Color.fromRGBO(9, 0, 136, 1)),
  ChartDataInfo('2014', 38, Color.fromRGBO(147, 0, 119, 1)),
  ChartDataInfo('2015', 34, Color.fromRGBO(228, 0, 124, 1)),
  ChartDataInfo('2016', 52, Color.fromARGB(255, 59, 19, 41)),
  ChartDataInfo('2017', 52, Color.fromARGB(255, 223, 215, 67)),
  ChartDataInfo('2018', 12, Color.fromARGB(255, 7, 170, 118)),
  ChartDataInfo('2019', 32, Color.fromARGB(255, 96, 3, 54)),
  ChartDataInfo('2020', 12, Color.fromARGB(255, 7, 170, 118)),
  ChartDataInfo('2021', 32, Color.fromARGB(255, 96, 3, 54)),
];
