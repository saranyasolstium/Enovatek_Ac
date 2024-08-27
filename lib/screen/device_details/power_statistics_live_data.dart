import 'dart:async';
import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/model/energy.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/circular_bar.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:intl/intl.dart';

class PowerStatisticsLiveScreen extends StatefulWidget {
  final String deviceId;
  const PowerStatisticsLiveScreen({
    Key? key,
    required this.deviceId,
  }) : super(key: key);

  @override
  PowerStatisticsLiveScreenState createState() =>
      PowerStatisticsLiveScreenState();
}

class PowerStatisticsLiveScreenState extends State<PowerStatisticsLiveScreen>
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
  String periodType = "day";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    DateTime currentDate = DateTime.now();
    String formattedDate =
        "${currentDate.day}-${currentDate.month}-${currentDate.year}";
    powerusages("day", formattedDate);
  }

  Future<void> powerusages(String periodType, String periodValue) async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? userId = await SharedPreferencesHelper.instance.getUserID();
    List<String> device = [];
    device.add(widget.deviceId);
    final response = await RemoteServices.powerusages(
        authToken!, device, periodType, periodValue, "all", userId!);
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

      await Future.delayed(const Duration(minutes: 1));

      DateTime currentDate = DateTime.now();
      String formattedDate =
          "${currentDate.day}-${currentDate.month}-${currentDate.year}";
      powerusages("day", formattedDate);
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

  @override
  Widget build(BuildContext context) {
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
                          height: 22,
                          width: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Live Data',
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
            Row(
              children: [
                Expanded(
                  child: CircularBar(
                    label: 'AC Energy',
                    value: acEnergy!,
                    maxValue: 10,
                    unit: "kWh",
                    color: ConstantColors.iconColr,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CircularBar(
                    label: 'DC Energy',
                    value: dcEnergy!,
                    maxValue: 10,
                    unit: "kWh",
                    color: ConstantColors.iconColr,
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
                    maxValue: 500,
                    unit: "W",
                    color: ConstantColors.iconColr,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CircularBar(
                    label: 'DC Power',
                    value: dcValue!,
                    maxValue: 500,
                    unit: "W",
                    color: ConstantColors.iconColr,
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
                    maxValue: 500,
                    color: ConstantColors.iconColr,
                  ),
                ),
                const SizedBox(
                    width: 20), // Adjust the spacing between the bars
                Expanded(
                  child: CircularBar(
                    label: 'DC Voltage',
                    value: dcVoltgae!,
                    maxValue: 500,
                    unit: "V",
                    color: ConstantColors.iconColr,
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
                    maxValue: 10,
                    unit: "A",
                    color: ConstantColors.iconColr,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CircularBar(
                    label: 'DC Current',
                    value: dcCurrent!,
                    maxValue: 10,
                    unit: "A",
                    color: ConstantColors.iconColr,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
