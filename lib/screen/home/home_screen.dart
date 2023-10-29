import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/add_device/device_assign/device_assigning.dart';
import 'package:enavatek_mobile/screen/home/build_row.dart';
import 'package:enavatek_mobile/screen/menu/building/building.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String? userName;
  String? buildingName;
  String? buildingID;
  List<Building> buildings = [];

  @override
  void initState() {
    super.initState();
    getUserDataFromSharedPreferences();
    getAllDevice();
  }

  Future<void> getUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName');
    });
  }

  Future<void> getAllDevice() async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? userId = await SharedPreferencesHelper.instance.getUserID();
    Response response =
        await RemoteServices.getAllDeviceByUserId(authToken!, userId!);
    if (response.statusCode == 200) {
      String responseBody = response.body;
      setState(() {
        buildings = (json.decode(responseBody) as List)
            .map((data) => Building.fromJson(data))
            .toList();
      });
    } else {
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
          isTablet ? 0.05 * screenHeight : 0.05 * screenHeight,
          isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
          isTablet ? 0.02 * screenHeight : 0.05 * screenHeight,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  ImgPath.pngName,
                  width: isTablet ? 0.5 * screenWidth : 0.4 * screenWidth,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, notificationRoute);
                        },
                        child: Image.asset(
                          ImgPath.pngNotifcation,
                          width: isTablet
                              ? 0.06 * screenWidth
                              : 0.06 * screenWidth,
                          height: isTablet
                              ? 0.05 * screenHeight
                              : 0.06 * screenHeight,
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, menuRoute);
                        },
                        child: Image.asset(
                          ImgPath.pngMenu,
                          width: isTablet
                              ? 0.07 * screenWidth
                              : 0.07 * screenWidth,
                          height: isTablet
                              ? 0.05 * screenHeight
                              : 0.07 * screenHeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: isTablet ? 0.05 * screenWidth : 0.07 * screenWidth,
            ),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hi,\n ',
                      style: GoogleFonts.roboto(
                        color: ConstantColors.mainlyTextColor,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    TextSpan(
                      text: userName ?? 'Lorem Name',
                      style: GoogleFonts.roboto(
                        color: ConstantColors.mainlyTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(isTablet ? 30 : 15),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 0.05 * screenWidth,
                        right: 0.05 * screenWidth,
                        top: 0.03 * screenHeight,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add building',
                            style: GoogleFonts.roboto(
                              fontSize: screenWidth * 0.04,
                              color: ConstantColors.mainlyTextColor,
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, buildingRoute);
                            },
                            child: Image.asset(
                              ImgPath.pngAdd,
                              width: isTablet
                                  ? 0.05 * screenWidth
                                  : 0.05 * screenWidth,
                              height: isTablet
                                  ? 0.05 * screenHeight
                                  : 0.03 * screenHeight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height:
                          isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              itemCount: buildings.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final building = buildings[index];

                return GestureDetector(
                  onTap: () async {
                    print('Tapped on building: ${building.name}');
                    
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: ConstantColors.whiteColor,
                        borderRadius: BorderRadius.circular(isTablet ? 30 : 15),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 0.05 * screenWidth,
                              right: 0.05 * screenWidth,
                              top: 0.03 * screenHeight,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  building.name,
                                  style: GoogleFonts.roboto(
                                    fontSize: screenWidth * 0.04,
                                    color: ConstantColors.mainlyTextColor,
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

                          SizedBox(
                            height: isTablet
                                ? 0.05 * screenWidth
                                : 0.05 * screenWidth,
                          ),

                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: ConstantColors.mainlyTextColor,
                          ),
                          const SizedBox(
                            height: 100,
                          )
                          // Padding(
                          //   padding: EdgeInsets.fromLTRB(
                          //     isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
                          //     isTablet ? 0.05 * screenHeight : 0.03 * screenHeight,
                          //     isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
                          //     0,
                          //   ),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       RichText(
                          //         text: TextSpan(
                          //           children: [
                          //             TextSpan(
                          //               text: 'Device (10),\n ',
                          //               style: GoogleFonts.roboto(
                          //                 color: ConstantColors.mainlyTextColor,
                          //                 fontWeight: FontWeight.bold,
                          //                 fontSize: screenWidth * 0.035,
                          //               ),
                          //             ),
                          //             TextSpan(
                          //               text: 'Energy consumption: 1256 wh',
                          //               style: GoogleFonts.roboto(
                          //                 color: ConstantColors.mainlyTextColor,
                          //                 fontSize: screenWidth * 0.035,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //       const SizedBox(width: 20),
                          //       Icon(Icons.arrow_forward_ios,
                          //           color: ConstantColors.mainlyTextColor,
                          //           size: isTablet
                          //               ? 0.05 * screenWidth
                          //               : 0.05 * screenWidth),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.fromLTRB(
                          //     isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
                          //     isTablet ? 0.05 * screenHeight : 0.03 * screenHeight,
                          //     isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
                          //     isTablet ? 0.05 * screenWidth : 0.02 * screenWidth,
                          //   ),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       RichText(
                          //         text: TextSpan(
                          //           children: [
                          //             WidgetSpan(
                          //               child: Center(
                          //                 child: Image.asset(
                          //                   ImgPath.pngThermometer,
                          //                   width: isTablet
                          //                       ? 0.05 * screenWidth
                          //                       : 0.03 * screenWidth,
                          //                   height: isTablet
                          //                       ? 0.05 * screenHeight
                          //                       : 0.02 * screenHeight,
                          //                 ),
                          //               ),
                          //             ),
                          //             TextSpan(
                          //               text: 'Temp\n',
                          //               style: GoogleFonts.roboto(
                          //                 color: ConstantColors.mainlyTextColor,
                          //                 fontSize: screenWidth * 0.035,
                          //               ),
                          //             ),
                          //             TextSpan(
                          //               text: '    24° C',
                          //               style: GoogleFonts.roboto(
                          //                 color: ConstantColors.mainlyTextColor,
                          //                 fontSize: screenWidth * 0.035,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //       RichText(
                          //         text: TextSpan(
                          //           children: [
                          //             WidgetSpan(
                          //               child: Image.asset(
                          //                 ImgPath.pngAutoNew,
                          //                 width: isTablet
                          //                     ? 0.05 * screenWidth
                          //                     : 0.03 * screenWidth,
                          //                 height: isTablet
                          //                     ? 0.05 * screenHeight
                          //                     : 0.02 * screenHeight,
                          //               ),
                          //             ),
                          //             TextSpan(
                          //               text: ' Mobile\n',
                          //               style: GoogleFonts.roboto(
                          //                 color: ConstantColors.mainlyTextColor,
                          //                 fontSize: screenWidth * 0.035,
                          //               ),
                          //             ),
                          //             TextSpan(
                          //               text: '    Cool',
                          //               style: GoogleFonts.roboto(
                          //                 color: ConstantColors.mainlyTextColor,
                          //                 fontSize: screenWidth * 0.035,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //       MaterialButton(
                          //         onPressed: () {},
                          //         color: ConstantColors.whiteColor,
                          //         textColor: Colors.white,
                          //         minWidth: isTablet
                          //             ? 0.05 * screenWidth
                          //             : 0.05 * screenWidth,
                          //         height: isTablet
                          //             ? 0.05 * screenHeight
                          //             : 0.04 * screenHeight,
                          //         shape: const CircleBorder(
                          //           side: BorderSide(
                          //             color: ConstantColors.borderButtonColor,
                          //             width: 2,
                          //           ),
                          //         ),
                          //         child: Image.asset(
                          //           ImgPath.pngPlus,
                          //           width: isTablet
                          //               ? 0.05 * screenWidth
                          //               : 0.03 * screenWidth,
                          //           height: isTablet
                          //               ? 0.05 * screenHeight
                          //               : 0.03 * screenHeight,
                          //         ),
                          //       ),
                          //       MaterialButton(
                          //         onPressed: () {},
                          //         color: ConstantColors.whiteColor,
                          //         textColor: Colors.white,
                          //         minWidth: isTablet
                          //             ? 0.05 * screenWidth
                          //             : 0.04 * screenWidth,
                          //         height: isTablet
                          //             ? 0.05 * screenHeight
                          //             : 0.04 * screenHeight,
                          //         shape: const CircleBorder(
                          //           side: BorderSide(
                          //             color: ConstantColors.borderButtonColor,
                          //             width: 2,
                          //           ),
                          //         ),
                          //         child: Image.asset(
                          //           ImgPath.pngRemove,
                          //           width: isTablet
                          //               ? 0.05 * screenWidth
                          //               : 0.03 * screenWidth,
                          //           height: isTablet
                          //               ? 0.05 * screenHeight
                          //               : 0.03 * screenHeight,
                          //         ),
                          //       ),
                          //       MaterialButton(
                          //         onPressed: () async {
                          //           try {
                          //             await mqttService.connectWithRetry(5);
                          //             print('Connected to MQTT broker');
                          //             mqttService.publish(
                          //                 retrievedDeviceId!, 'POWER', 'ON');

                          //             mqttService.subscribe(retrievedDeviceId!,
                          //                 (message) {
                          //               print('Received MQTT message: $message');
                          //             });
                          //           } catch (e) {
                          //             print('Error connecting to MQTT broker: $e');
                          //           }
                          //         },
                          //         color: ConstantColors.greenColor,
                          //         textColor: Colors.white,
                          //         minWidth: isTablet
                          //             ? 0.05 * screenWidth
                          //             : 0.05 * screenWidth,
                          //         height: isTablet
                          //             ? 0.05 * screenHeight
                          //             : 0.04 * screenHeight,
                          //         shape: const CircleBorder(
                          //           side: BorderSide(
                          //             color: ConstantColors.greenColor,
                          //             width: 2,
                          //           ),
                          //         ),
                          //         child: Icon(
                          //           Icons.power_settings_new,
                          //           size: isTablet
                          //               ? 0.05 * screenWidth
                          //               : 0.05 * screenWidth,
                          //           color: ConstantColors.whiteColor,
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: isTablet ? 50 : 30,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: RoundedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, addDeviceRoute);
                  },
                  text: "Add Device",
                  backgroundColor: ConstantColors.borderButtonColor,
                  textColor: ConstantColors.whiteColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
