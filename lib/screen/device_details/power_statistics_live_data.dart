import 'dart:async';
import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/screen/device_details/power_statistics.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/dynamic_font.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/circular_bar.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PowerStatisticsLiveScreen extends StatefulWidget {
  final String deviceId;
  final String deviceName;
  const PowerStatisticsLiveScreen({
    Key? key,
    required this.deviceName,
    required this.deviceId,
  }) : super(key: key);

  @override
  PowerStatisticsLiveScreenState createState() =>
      PowerStatisticsLiveScreenState();
}

class PowerStatisticsLiveScreenState extends State<PowerStatisticsLiveScreen>
    with SingleTickerProviderStateMixin {
  String? totalPower = "", acPower = "", dcPower = "", refreshTime = "N/A";
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
  int? userId = 1;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final formattedDate = "${now.day}-${now.month}-${now.year}";
    powerusages("day", formattedDate);
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final userTypeId = await SharedPreferencesHelper.instance.getUserTypeID();
    if (!mounted) return;
    setState(() => userId = userTypeId);
  }

// Helper: take last_sync from data[0] if present, else fall back to top-level.
  String? _extractLastSync(Map<String, dynamic> json) {
    final d = json['data'];

    if (d is List && d.isNotEmpty && d.first is Map<String, dynamic>) {
      final m = d.first as Map<String, dynamic>;
      final v = (m['last_sync'] ?? m['max_rtc'] ?? m['created_on']);
      if (v is String && v.trim().isNotEmpty) return v; // keep original format
    }

    for (final k in ['last_sync', 'max_rtc', 'created_on']) {
      final v = json[k];
      if (v is String && v.trim().isNotEmpty) return v; // keep original format
    }
    return null;
  }

  String prettifyIso(String? iso) {
    if (iso == null || iso.trim().isEmpty) return 'N/A';
    var s = iso.trim();
    // Replace the date/time separator and drop trailing Z (and any .sss millis)
    s = s.replaceFirst('T', ' ');
    s = s.replaceFirst(RegExp(r'(\.\d+)?Z$'), '');
    return s;
  }

  Future<void> powerusages(String periodType, String periodValue) async {
    final authToken = await SharedPreferencesHelper.instance.getAuthToken();
    final uid = await SharedPreferencesHelper.instance.getUserID();
    final device = <String>[widget.deviceId];

    final response = await RemoteServices.powerusages(
      authToken!,
      device,
      periodType,
      periodValue,
      "all",
      uid!,
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final lastSyncRaw = _extractLastSync(responseData); // <-- here
      // print for debugging
      // ignore: avoid_print
      print('last_sync picked: $lastSyncRaw');

      setState(() {
        refreshTime = prettifyIso(lastSyncRaw); // e.g. "2025-10-06 22:55:33"

        totalPower = responseData['total_power'];
        acPower = responseData['ac_power'];
        dcPower = responseData['dc_power'];

        final acPowerValueStr =
            (acPower ?? '0').toString().replaceAll(RegExp(r'[^0-9.]'), '');
        final dcPowerValueStr =
            (dcPower ?? '0').toString().replaceAll(RegExp(r'[^0-9.]'), '');

        final acVoltageStr = (responseData['ac_voltage'] ?? '0')
            .toString()
            .replaceAll(RegExp(r'[^0-9.]'), '');
        final dcVoltageStr = (responseData['dc_voltage'] ?? '0')
            .toString()
            .replaceAll(RegExp(r'[^0-9.]'), '');

        final acCurrentStr = (responseData['ac_current'] ?? '0')
            .toString()
            .replaceAll(RegExp(r'[^0-9.]'), '');
        final dcCurrentStr = (responseData['dc_current'] ?? '0')
            .toString()
            .replaceAll(RegExp(r'[^0-9.]'), '');

        final acEnergyStr = (responseData['ac_energy'] ?? '0')
            .toString()
            .replaceAll(RegExp(r'[^0-9.]'), '');
        final dcEnergyStr = (responseData['dc_energy'] ?? '0')
            .toString()
            .replaceAll(RegExp(r'[^0-9.]'), '');

        acValue = double.tryParse(acPowerValueStr) ?? 0;
        dcValue = double.tryParse(dcPowerValueStr) ?? 0;
        acVoltage = double.tryParse(acVoltageStr) ?? 0;
        dcVoltgae = double.tryParse(dcVoltageStr) ?? 0;
        acCurrent = double.tryParse(acCurrentStr) ?? 0;
        dcCurrent = double.tryParse(dcCurrentStr) ?? 0;
        acEnergy = double.tryParse(acEnergyStr) ?? 0;
        dcEnergy = double.tryParse(dcEnergyStr) ?? 0;
      });

      // refresh every minute
      await Future.delayed(const Duration(minutes: 1));
      final now = DateTime.now();
      final formattedDate = "${now.day}-${now.month}-${now.year}";
      if (mounted) powerusages("day", formattedDate);
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['message'] == 'No record(s) found') {
        setState(() {
          refreshTime = "N/A";
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: ConstantColors.darkBackgroundColor,
      bottomNavigationBar: const Footer(),
      appBar: AppBar(
        backgroundColor: ConstantColors.darkBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    ImgPath.pngArrowBack,
                    height: isTablet ? 40 : 22,
                    width: isTablet ? 40 : 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Live Data',
                    style: GoogleFonts.roboto(
                      fontSize:
                          isTablet ? screenWidth * 0.03 : screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: ConstantColors.black,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        actions: [
          SizedBox(width: 20.dynamic),
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
              size: isTablet ? 40 : 30,
            ),
          ),
          SizedBox(width: 20.dynamic),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
        child: Column(
          children: [
            Text(
              'Device : ${widget.deviceName}',
              style: GoogleFonts.roboto(
                fontSize: isTablet ? screenWidth * 0.03 : screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: ConstantColors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Last Sync Time : $refreshTime',
              style: GoogleFonts.roboto(
                fontSize: isTablet ? screenWidth * 0.03 : screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: ConstantColors.black,
              ),
            ),
            const SizedBox(height: 15),
            if (userId == 1 || userId == 2 || userId == 3)
              Row(
                children: [
                  Expanded(
                    child: CircularBar(
                      label: 'AC Energy',
                      value: acEnergy ?? 0,
                      maxValue: 10,
                      unit: "kWh",
                      color: ConstantColors.iconColr,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CircularBar(
                      label: 'DC Energy',
                      value: dcEnergy ?? 0,
                      maxValue: 10,
                      unit: "kWh",
                      color: ConstantColors.iconColr,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            if (userId == 1 || userId == 2 || userId == 3)
              Row(
                children: [
                  Expanded(
                    child: CircularBar(
                      label: 'AC Power',
                      value: acValue ?? 0,
                      maxValue: 500,
                      unit: "W",
                      color: ConstantColors.iconColr,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CircularBar(
                      label: 'DC Power',
                      value: dcValue ?? 0,
                      maxValue: 500,
                      unit: "W",
                      color: ConstantColors.iconColr,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            if (userId == 1)
              Row(
                children: [
                  Expanded(
                    child: CircularBar(
                      label: 'AC Voltage',
                      value: acVoltage ?? 0,
                      unit: "V",
                      maxValue: 500,
                      color: ConstantColors.iconColr,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CircularBar(
                      label: 'DC Voltage',
                      value: dcVoltgae ?? 0,
                      maxValue: 500,
                      unit: "V",
                      color: ConstantColors.iconColr,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            if (userId == 1) //admin
              Row(
                children: [
                  Expanded(
                    child: CircularBar(
                      label: 'AC Current',
                      value: acCurrent ?? 0,
                      maxValue: 10,
                      unit: "A",
                      color: ConstantColors.iconColr,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CircularBar(
                      label: 'DC Current',
                      value: dcCurrent ?? 0,
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
