import 'dart:async';
import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
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
  String powerColor="off";
  String modeNameToFind ="";
  @override
  void initState() {
    super.initState();
    fanSpeedLevel = int.tryParse(widget.fanSpeed) ?? 0;
    powerColor=widget.power;
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
      width: 500,
      decoration: const BoxDecoration(
        color: ConstantColors.lightBlueColor,
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
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: AppBar(
            backgroundColor: ConstantColors.backgroundColor,
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
                              Navigator.pushReplacementNamed(context, allDeviceRoute);
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
                        int? loginId =
                            await SharedPreferencesHelper.instance.getLoginID();
                        Response response = await RemoteServices.actionCommand(
                            authToken!, value, widget.deviceId, 1, loginId!);
                        var data = jsonDecode(response.body);

                        if (response.statusCode == 200) {
                          print(data["message"]);

                          setState(() {
                            powerColor=value;
                          });
                        }
                      },
                      color: powerColor.toLowerCase() == 'off'
                          ? ConstantColors.orangeColor
                          : ConstantColors.greenColor,
                      textColor: Colors.white,
                      minWidth: 30,
                      height: 30,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: powerColor.toLowerCase() == 'off'
                              ? ConstantColors.orangeColor
                              : ConstantColors.greenColor,
                          width: 2,
                        ),
                      ),
                      child: const Icon(Icons.power_settings_new,
                          size: 20, color: ConstantColors.whiteColor),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
        child: Column(
          children: [
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Total Energy saving: ',
                      style: GoogleFonts.roboto(
                          color: ConstantColors.mainlyTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    TextSpan(
                      text: '80% ',
                      style: GoogleFonts.roboto(
                          color: ConstantColors.greenColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    const WidgetSpan(
                      child: SizedBox(
                        width: 10,
                      ),
                    ),
                    const WidgetSpan(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: ConstantColors.mainlyTextColor,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: const BoxDecoration(
                color: ConstantColors.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Instant Cool\n\n ',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          TextSpan(
                            text: 'Automatically turn off in 5 min',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    GFToggle(
                      onChanged: (val) {},
                      value: true,
                      enabledThumbColor: ConstantColors.whiteColor,
                      enabledTrackColor: ConstantColors.lightBlueColor,
                      type: GFToggleType.ios,
                    )
                  ],
                ),
              ),
            ),
            getSemiCircleProgressStyle(),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: ConstantColors.whiteColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Fan Speed\n\n ',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          TextSpan(
                            text: 'Level $fanSpeedLevel',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 80),
                    MaterialButton(
                      onPressed: () {
                        decreaseFanSpeed();
                      },
                      color: ConstantColors.whiteColor,
                      textColor: Colors.white,
                      minWidth: 40,
                      height: 40,
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
                    MaterialButton(
                      onPressed: () {
                        increaseFanSpeed();
                      },
                      color: ConstantColors.whiteColor,
                      textColor: Colors.white,
                      minWidth: 40,
                      height: 40,
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
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: ConstantColors.whiteColor,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Mode',
                      style: GoogleFonts.roboto(
                          color: ConstantColors.mainlyTextColor, fontSize: 15),
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: modes.length,
                    itemBuilder: (context, index) {
                      final modeData = modes[index];
                      return buildModeToggle(
                          index, modeData.modeName, modeData.imagePath);
                    },
                  ),

                  // buildModeToggle(0, 'Auto', ImgPath.pngAutoNew),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           Image.asset(
                  //             ImgPath.pngAutoNew,
                  //             height: 12,
                  //             width: 12,
                  //           ),
                  //           const SizedBox(width: 10),
                  //           Text(
                  //             'Auto',
                  //             style: GoogleFonts.roboto(
                  //                 color: ConstantColors.mainlyTextColor,
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 15),
                  //           ),
                  //         ]),
                  //     GFToggle(
                  //       onChanged: (val) {
                  //         setState(() {
                  //           isAutoSelected = val ?? false;
                  //           isCoolSelected = false;
                  //           isDrySelected = false;
                  //           isFanSelected = false;
                  //           isHeatSelected = false;
                  //         });
                  //       },
                  //       value: isAutoSelected,
                  //       enabledThumbColor: ConstantColors.whiteColor,
                  //       enabledTrackColor: ConstantColors.lightBlueColor,
                  //       type: GFToggleType.ios,
                  //     )
                  //   ],
                  // ),

                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // buildModeToggle(1, 'Cool', ImgPath.pngCool),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           Image.asset(
                  //             ImgPath.pngCool,
                  //             height: 12,
                  //             width: 12,
                  //           ),
                  //           const SizedBox(width: 10),
                  //           Text(
                  //             'Cool',
                  //             style: GoogleFonts.roboto(
                  //                 color: ConstantColors.mainlyTextColor,
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 15),
                  //           ),
                  //         ]),
                  //     GFToggle(
                  //       onChanged: (val) {
                  //         setState(() {
                  //           isAutoSelected = false;
                  //           isCoolSelected = val ?? false;
                  //           isDrySelected = false;
                  //           isFanSelected = false;
                  //           isHeatSelected = false;
                  //         });
                  //       },
                  //       value: isCoolSelected,
                  //       enabledThumbColor: ConstantColors.whiteColor,
                  //       enabledTrackColor: ConstantColors.lightBlueColor,
                  //       type: GFToggleType.ios,
                  //     )
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // buildModeToggle(2, 'Dry', ImgPath.pngCoolDry),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           Image.asset(
                  //             ImgPath.pngCoolDry,
                  //             height: 12,
                  //             width: 12,
                  //           ),
                  //           const SizedBox(width: 10),
                  //           Text(
                  //             'Dry',
                  //             style: GoogleFonts.roboto(
                  //                 color: ConstantColors.mainlyTextColor,
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 15),
                  //           ),
                  //         ]),
                  //     GFToggle(
                  //       onChanged: (val) {
                  //         setState(() {
                  //           isAutoSelected = false;
                  //           isCoolSelected = false;
                  //           isDrySelected = val ?? false;
                  //           isFanSelected = false;
                  //           isHeatSelected = false;
                  //         });
                  //       },
                  //       value: isDrySelected,
                  //       enabledThumbColor: ConstantColors.whiteColor,
                  //       enabledTrackColor: ConstantColors.lightBlueColor,
                  //       type: GFToggleType.ios,
                  //     )
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // buildModeToggle(3, 'Fan', ImgPath.pngFan),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           Image.asset(
                  //             ImgPath.pngFan,
                  //             height: 12,
                  //             width: 12,
                  //           ),
                  //           const SizedBox(width: 10),
                  //           Text(
                  //             'Fan',
                  //             style: GoogleFonts.roboto(
                  //                 color: ConstantColors.mainlyTextColor,
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 15),
                  //           ),
                  //         ]),
                  //     GFToggle(
                  //       onChanged: (val) {
                  //         setState(() {
                  //           isAutoSelected = false;
                  //           isCoolSelected = false;
                  //           isDrySelected = false;
                  //           isFanSelected = val ?? false;
                  //           isHeatSelected = false;
                  //         });
                  //       },
                  //       value: isFanSelected,
                  //       enabledThumbColor: ConstantColors.whiteColor,
                  //       enabledTrackColor: ConstantColors.lightBlueColor,
                  //       type: GFToggleType.ios,
                  //     )
                  //   ],
                  // ),

                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // buildModeToggle(4, 'Heat', ImgPath.pngSunny),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           Image.asset(
                  //             ImgPath.pngSunny,
                  //             height: 12,
                  //             width: 12,
                  //           ),
                  //           const SizedBox(width: 10),
                  //           Text(
                  //             'Heat',
                  //             style: GoogleFonts.roboto(
                  //                 color: ConstantColors.mainlyTextColor,
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 15),
                  //           ),
                  //         ]),
                  //     GFToggle(
                  //       onChanged: (val) {
                  //         setState(() {
                  //           isAutoSelected = false;
                  //           isCoolSelected = false;
                  //           isDrySelected = false;
                  //           isFanSelected = false;
                  //           isHeatSelected = val ?? false;
                  //         });
                  //       },
                  //       value: isHeatSelected,
                  //       enabledThumbColor: ConstantColors.whiteColor,
                  //       enabledTrackColor: ConstantColors.lightBlueColor,
                  //       type: GFToggleType.ios,
                  //     )
                  //   ],
                  // ),

                  // const SizedBox(
                  //   height: 10,
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context, manualAddDevice);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: ConstantColors.whiteColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Adjust Swing ',
                        style: GoogleFonts.roboto(
                            color: ConstantColors.mainlyTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: ConstantColors.mainlyTextColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, scheduleRoute);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: ConstantColors.whiteColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Schedule ',
                        style: GoogleFonts.roboto(
                            color: ConstantColors.mainlyTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: ConstantColors.mainlyTextColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: ConstantColors.whiteColor,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Additional Information',
                      style: GoogleFonts.roboto(
                          color: ConstantColors.mainlyTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Image.asset(
                                    ImgPath.pngThermometer,
                                    height: 12,
                                    width: 12,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(
                                    width: 8,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Room Temp\n',
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: ConstantColors.mainlyTextColor),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(
                                      width: 10), // Adjust the width as needed
                                ),
                                TextSpan(
                                  text: '28° C',
                                  style: GoogleFonts.roboto(
                                      color: ConstantColors.mainlyTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Image.asset(
                                    ImgPath.pngHumidity,
                                    height: 12,
                                    width: 12,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(
                                    width: 8,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Humidity\n',
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: ConstantColors.mainlyTextColor,
                                  ),
                                ),
                                TextSpan(
                                  text: '20%',
                                  style: GoogleFonts.roboto(
                                      color: ConstantColors.mainlyTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Image.asset(
                                    ImgPath.pngGrain,
                                    height: 12,
                                    width: 12,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(
                                    width: 8,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Air Quality\n',
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: ConstantColors.mainlyTextColor,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Good',
                                  style: GoogleFonts.roboto(
                                      color: ConstantColors.mainlyTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Image.asset(
                                    ImgPath.pngBuildIcon,
                                    height: 12,
                                    width: 12,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(
                                    width: 8,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Maintaince\n',
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: ConstantColors.mainlyTextColor),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(
                                      width: 10), // Adjust the width as needed
                                ),
                                TextSpan(
                                  text: 'Not required',
                                  style: GoogleFonts.roboto(
                                      color: ConstantColors.greenColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Image.asset(
                                    ImgPath.pngThermometer,
                                    height: 12,
                                    width: 12,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(
                                    width: 8,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Filter cleaning\n',
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: ConstantColors.mainlyTextColor,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Required',
                                  style: GoogleFonts.roboto(
                                      color: ConstantColors.orangeColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Image.asset(
                                    ImgPath.pngValumeUp,
                                    height: 12,
                                    width: 12,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(
                                    width: 8,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Noise Level\n',
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: ConstantColors.mainlyTextColor,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Normal',
                                  style: GoogleFonts.roboto(
                                      color: ConstantColors.yellowColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                //Navigator.pushNamed(context, manualAddDevice);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: ConstantColors.whiteColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Having any trouble?\n\n ',
                              style: GoogleFonts.roboto(
                                  color: ConstantColors.mainlyTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            TextSpan(
                              text: 'Contact to our customer service',
                              style: GoogleFonts.roboto(
                                  color: ConstantColors.mainlyTextColor,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: ConstantColors.mainlyTextColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

class ModeData {
  final String modeName;
  final String imagePath;

  ModeData(this.modeName, this.imagePath);
}
