import 'dart:async';
import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

enum FanMode { Auto, Low, Mid, High }

class FanSpeedScreen extends StatefulWidget {
  final String deviceName;
  final String power;
  final String mode;
  final String deviceId;

  const FanSpeedScreen(
      {Key? key,
      required this.deviceName,
      required this.power,
      required this.mode,
      required this.deviceId})
      : super(key: key);

  @override
  FanSpeedScreenState createState() => FanSpeedScreenState();
}

class FanSpeedScreenState extends State<FanSpeedScreen> {
  double progressValue = 24;
  double secondaryProgressValue = 0;
  String powerColor = "off";

  FanMode selectedFanMode = FanMode.Auto;

  void selectMode(FanMode mode) {
    setState(() {
      selectedFanMode = mode;
    });
  }

  @override
  void initState() {
    super.initState();
    powerColor = widget.power;
    if (widget.mode == "Low") {
      selectedFanMode = FanMode.Low;
    } else if (widget.mode == "Mid") {
      selectedFanMode = FanMode.Mid;
    } else if (widget.mode == "High") {
      selectedFanMode = FanMode.High;
    } else {
      selectedFanMode = FanMode.Auto;
    }
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
                    color: ConstantColors.darkBlueColor,
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

  Future<void> executeFanModeCommand(String modeName) async {
    print(modeName);

    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? loginId = await SharedPreferencesHelper.instance.getLoginID();

    Response response = await RemoteServices.actionCommand(
      authToken!,
      modeName,
      widget.deviceId,
      3,
      loginId!,
    );

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(data["message"]);
      await SharedPreferencesHelper.instance.setFanMode(modeName);
    }
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
          height: 250,
          padding: EdgeInsets.zero,
          child: Container(
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
                              selectMode(FanMode.Auto);
                              executeFanModeCommand('Auto');
                            },
                            color: selectedFanMode == FanMode.Auto
                                ? ConstantColors.borderButtonColor
                                : ConstantColors.modeDefault,
                            textColor: Colors.white,
                            minWidth: 40,
                            height: 40,
                            shape: CircleBorder(
                              side: BorderSide(
                                color: selectedFanMode == FanMode.Auto
                                    ? ConstantColors.borderButtonColor
                                    : ConstantColors.modeDefault,
                                width: 2,
                              ),
                            ),
                            child: Image.asset(
                              ImgPath.pngFanAuto,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Auto',
                            style: GoogleFonts.roboto(
                                fontSize: screenWidth * 0.03,
                                color: ConstantColors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () async {
                              selectMode(FanMode.Low);
                              executeFanModeCommand('Low');
                            },
                            color: selectedFanMode == FanMode.Low
                                ? ConstantColors.borderButtonColor
                                : ConstantColors.modeDefault,
                            textColor: Colors.white,
                            minWidth: 40,
                            height: 40,
                            shape: CircleBorder(
                              side: BorderSide(
                                color: selectedFanMode == FanMode.Low
                                    ? ConstantColors.borderButtonColor
                                    : ConstantColors.modeDefault,
                                width: 2,
                              ),
                            ),
                            child: Image.asset(
                              ImgPath.pngFanLow,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Low',
                            style: GoogleFonts.roboto(
                                fontSize: screenWidth * 0.03,
                                color: ConstantColors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () async {
                              selectMode(FanMode.Mid);
                              executeFanModeCommand('Mid');
                            },
                            color: selectedFanMode == FanMode.Mid
                                ? ConstantColors.borderButtonColor
                                : ConstantColors.modeDefault,
                            textColor: Colors.white,
                            minWidth: 40,
                            height: 40,
                            shape: CircleBorder(
                              side: BorderSide(
                                color: selectedFanMode == FanMode.Mid
                                    ? ConstantColors.borderButtonColor
                                    : ConstantColors.modeDefault,
                                width: 2,
                              ),
                            ),
                            child: Image.asset(
                              ImgPath.pngFanMild,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Mid',
                            style: GoogleFonts.roboto(
                                fontSize: screenWidth * 0.03,
                                color: ConstantColors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () async {
                              selectMode(FanMode.High);
                              executeFanModeCommand('High');
                            },
                            color: selectedFanMode == FanMode.High
                                ? ConstantColors.borderButtonColor
                                : ConstantColors.modeDefault,
                            textColor: Colors.white,
                            minWidth: 40,
                            height: 40,
                            shape: CircleBorder(
                              side: BorderSide(
                                color: selectedFanMode == FanMode.High
                                    ? ConstantColors.borderButtonColor
                                    : ConstantColors.modeDefault,
                                width: 2,
                              ),
                            ),
                            child: Image.asset(
                              ImgPath.pngFanHigh,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'High',
                            style: GoogleFonts.roboto(
                                fontSize: screenWidth * 0.03,
                                color: ConstantColors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Visibility(
                      visible: false,
                      child: Column(
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () async {},
                            color: ConstantColors.modeDefault,
                            textColor: Colors.white,
                            minWidth: 40,
                            height: 40,
                            shape: const CircleBorder(
                              side: BorderSide(
                                color: ConstantColors.modeDefault,
                                width: 2,
                              ),
                            ),
                            child: Image.asset(
                              ImgPath.pngModeDry,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Wind',
                            style: GoogleFonts.roboto(
                                fontSize: screenWidth * 0.03,
                                color: ConstantColors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
                    Expanded(
                        child: Visibility(
                      visible: false,
                      child: Column(
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () async {},
                            color: ConstantColors.modeDefault,
                            textColor: Colors.white,
                            minWidth: 40,
                            height: 40,
                            shape: const CircleBorder(
                              side: BorderSide(
                                color: ConstantColors.modeDefault,
                                width: 2,
                              ),
                            ),
                            child: Image.asset(
                              ImgPath.pngModeDry,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Wind',
                            style: GoogleFonts.roboto(
                                fontSize: screenWidth * 0.03,
                                color: ConstantColors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
