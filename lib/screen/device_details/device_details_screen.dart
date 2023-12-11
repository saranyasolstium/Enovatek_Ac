import 'dart:async';
import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/device_details/FanSpeedScreen.dart';
import 'package:enavatek_mobile/screen/device_details/mode_screen.dart';
import 'package:enavatek_mobile/screen/device_details/power_statistics.dart';
import 'package:enavatek_mobile/screen/device_details/timer/timer_screen.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/advanced_feature.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DeviceDetailScreen extends StatefulWidget {
  final String deviceName;
  final String power;
  final String fanSpeed;
  final String mode;
  final int deviceId;

  const DeviceDetailScreen(
      {Key? key,
      required this.deviceName,
      required this.power,
      required this.fanSpeed,
      required this.mode,
      required this.deviceId})
      : super(key: key);

  @override
  DeviceDetailScreenState createState() => DeviceDetailScreenState();
}

class DeviceDetailScreenState extends State<DeviceDetailScreen> {
  double progressValue = 24;
  double secondaryProgressValue = 0;
  int fanSpeedLevel = 1; // Initial fan speed level
  String powerColor = "off";
  String modeNameToFind = "";
  @override
  void initState() {
    super.initState();
    fanSpeedLevel = int.tryParse(widget.fanSpeed) ?? 0;
    powerColor = widget.power;
  }

  Future<void> increaseProgressValue() async {
    setState(() {
      if (progressValue < 30) {
        progressValue += 1;
      }
    });
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? loginId = await SharedPreferencesHelper.instance.getLoginID();
    String temperature = '${progressValue.toStringAsFixed(0)}°C';

    Response response = await RemoteServices.actionCommand(
        authToken!, temperature, widget.deviceId, 4, loginId!);
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(data["message"]);
    }
  }

  Future<void> decreaseProgressValue() async {
    setState(() {
      progressValue -= 1;
      if (progressValue < 16) {
        progressValue = 16;
      }
    });
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? loginId = await SharedPreferencesHelper.instance.getLoginID();
    String temperature = '${progressValue.toStringAsFixed(0)}°C';

    Response response = await RemoteServices.actionCommand(
        authToken!, temperature, widget.deviceId, 4, loginId!);
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(data["message"]);
    }
  }

  /// Returns semi-circular style circular progress bar.
  Widget getSemiCircleProgressStyle() {
    double gaugeValue = progressValue;

    return Container(
      height: 250,
      decoration: const BoxDecoration(
        color: ConstantColors.darkBackgroundColor,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                showLabels: false,
                showTicks: false,
                startAngle: 150,
                endAngle: 30,
                minimum: 0,
                maximum: 30,
                canScaleToFit: true,
                radiusFactor: 0.8,
                axisLineStyle: const AxisLineStyle(
                  thickness: 0.1,
                  color: Colors.grey,
                  thicknessUnit: GaugeSizeUnit.factor,
                  cornerStyle: CornerStyle.startCurve,
                ),
                pointers: <GaugePointer>[
                  RangePointer(
                    value: gaugeValue,
                    width: 0.1,
                    sizeUnit: GaugeSizeUnit.factor,
                    enableAnimation: true,
                    animationDuration: 100,
                    animationType: AnimationType.linear,
                    cornerStyle: CornerStyle.startCurve,
                  ),
                ],
              ),
            ],
          ),
          Positioned(
              top: 150,
              child: Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      decreaseProgressValue();
                    },
                    color: ConstantColors.whiteColor,
                    textColor: Colors.white,
                    minWidth: 30,
                    height: 30,
                    shape: const CircleBorder(
                      side: BorderSide(
                        color: ConstantColors.borderButtonColor,
                        width: 2,
                      ),
                    ),
                    child: Image.asset(
                      ImgPath.pngRemove,
                      height: 15,
                      width: 15,
                      color: ConstantColors.lightBlueColor,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "${progressValue.toString().split('.')[0]}°C",
                    style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ConstantColors.black),
                  ),
                  const SizedBox(width: 20),
                  MaterialButton(
                    onPressed: () {
                      increaseProgressValue();
                    },
                    color: ConstantColors.whiteColor,
                    textColor: Colors.white,
                    minWidth: 30,
                    height: 30,
                    shape: const CircleBorder(
                      side: BorderSide(
                        color: ConstantColors.borderButtonColor,
                        width: 2,
                      ),
                    ),
                    child: Image.asset(
                      ImgPath.pngPlus,
                      height: 15,
                      width: 15,
                      color: ConstantColors.lightBlueColor,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  int selectedMode = 0; // Initially no mode selected

  final List<ModeData> modes = [
    ModeData('Auto', ImgPath.pngAutoNew),
    ModeData('Cool', ImgPath.pngCool),
    ModeData('Dry', ImgPath.pngCoolDry),
    ModeData('Fan', ImgPath.pngFan),
    ModeData('Heat', ImgPath.pngSunny),
  ];

  String getSelectedModeName(int selectedMode) {
    if (selectedMode >= 0 && selectedMode < modes.length) {
      return modes[selectedMode].modeName;
    } else {
      return '';
    }
  }

  Widget buildModeToggle(int mode, String modeName, String imagePath) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              height: 12,
              width: 12,
            ),
            const SizedBox(width: 10),
            Text(
              modeName,
              style: GoogleFonts.roboto(
                color: ConstantColors.mainlyTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
        Radio<int>(
          value: mode,
          groupValue: selectedMode,
          onChanged: (value) async {
            setState(() {
              selectedMode = value!;
            });
            String modeName = getSelectedModeName(selectedMode);
            print(modeName);
            String? authToken =
                await SharedPreferencesHelper.instance.getAuthToken();
            int? loginId = await SharedPreferencesHelper.instance.getLoginID();
            Response response = await RemoteServices.actionCommand(
                authToken!, modeName, widget.deviceId, 2, loginId!);
            var data = jsonDecode(response.body);
            if (response.statusCode == 200) {
              print(data["message"]);
            }
          },
        ),
      ],
    );
  }

// Function to increase the fan speed level
  Future<void> increaseFanSpeed() async {
    if (fanSpeedLevel < 5) {
      setState(() {
        fanSpeedLevel++;
      });
      String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
      int? loginId = await SharedPreferencesHelper.instance.getLoginID();
      Response response = await RemoteServices.actionCommand(
          authToken!, fanSpeedLevel.toString(), widget.deviceId, 3, loginId!);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data["message"]);
      }
    }
  }

  // Function to decrease the fan speed level
  Future<void> decreaseFanSpeed() async {
    if (fanSpeedLevel > 1) {
      setState(() {
        fanSpeedLevel--;
      });
      String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
      int? loginId = await SharedPreferencesHelper.instance.getLoginID();
      Response response = await RemoteServices.actionCommand(
          authToken!, fanSpeedLevel.toString(), widget.deviceId, 3, loginId!);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data["message"]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    void showAdvancedDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ShowAdvancedDialog();
        },
      );
    }

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
                                Navigator.pushReplacementNamed(
                                    context, allDeviceRoute);
                              },
                              child: Image.asset(
                                ImgPath.pngArrowBack,
                                height: 25,
                                width: 25,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.deviceName,
                              style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: ConstantColors.black),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {},
                        color: ConstantColors.whiteColor,
                        textColor: Colors.white,
                        minWidth: 30,
                        height: 30,
                        shape: const CircleBorder(
                          side: BorderSide(
                            color: ConstantColors.borderButtonColor,
                            width: 2,
                          ),
                        ),
                        child: Image.asset(
                          ImgPath.pngEdit,
                          height: 10,
                          width: 10,
                          color: ConstantColors.lightBlueColor,
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
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Column(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImgPath.pngSolarPlane,
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(
                      width: 60,
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
              getSemiCircleProgressStyle(),
              Center(
                child: Text(
                  'Cumulative power 2 kw.h',
                  style: GoogleFonts.roboto(
                      color: ConstantColors.iconColr,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: ConstantColors.darkBackgroundColor,
          child: Container(
            height: 250,
            decoration: const BoxDecoration(
              color: ConstantColors.whiteColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () async {
                              print(widget.power);
                              String value;
                              if (powerColor == 'ON') {
                                value = "OFF";
                              } else {
                                value = "ON";
                              }
                              String? authToken = await SharedPreferencesHelper
                                  .instance
                                  .getAuthToken();
                              int? loginId = await SharedPreferencesHelper
                                  .instance
                                  .getLoginID();
                              Response response =
                                  await RemoteServices.actionCommand(authToken!,
                                      value, widget.deviceId, 1, loginId!);
                              var data = jsonDecode(response.body);

                              if (response.statusCode == 200) {
                                print(data["message"]);

                                setState(() {
                                  powerColor = value;
                                });
                              }
                            },
                            color: powerColor.toLowerCase() == 'off'
                                ? ConstantColors.orangeColor
                                : ConstantColors.greenColor,
                            textColor: Colors.white,
                            minWidth: 40,
                            height: 40,
                            shape: CircleBorder(
                              side: BorderSide(
                                color: powerColor.toLowerCase() == 'off'
                                    ? ConstantColors.orangeColor
                                    : ConstantColors.greenColor,
                                width: 2,
                              ),
                            ),
                            child: const Icon(Icons.power_settings_new,
                                size: 25, color: ConstantColors.whiteColor),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Switch',
                            style: GoogleFonts.roboto(
                                fontSize: screenWidth * 0.03,
                                color: ConstantColors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ModeScreen(
                                      deviceName: widget.deviceName,
                                      mode: widget.mode,
                                      power: widget.power,
                                      deviceId: widget.deviceId,
                                    )),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              ImgPath.pngMode,
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Mode',
                              style: GoogleFonts.roboto(
                                  fontSize: screenWidth * 0.03,
                                  color: ConstantColors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FanSpeedScreen(
                                      deviceName: widget.deviceName,
                                      mode: widget.mode,
                                      power: widget.power,
                                      deviceId: widget.deviceId,
                                    )),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              ImgPath.pngfanSpeed,
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Fan Speed',
                              style: GoogleFonts.roboto(
                                  fontSize: screenWidth * 0.03,
                                  color: ConstantColors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TimerScreen()),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              ImgPath.pngTimer,
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Timer',
                              style: GoogleFonts.roboto(
                                  fontSize: screenWidth * 0.03,
                                  color: ConstantColors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PowerStatisticsScreen(
                                      
                                    )),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              ImgPath.pngPowerStatistics,
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Power Statistics',
                              style: GoogleFonts.roboto(
                                  fontSize: screenWidth * 0.03,
                                  color: ConstantColors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showAdvancedDialog(context);
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              ImgPath.pngAdvancedMenu,
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Advanced Feature',
                              style: GoogleFonts.roboto(
                                  fontSize: screenWidth * 0.03,
                                  color: ConstantColors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class ModeData {
  final String modeName;
  final String imagePath;

  ModeData(this.modeName, this.imagePath);
}
