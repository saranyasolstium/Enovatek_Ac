import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/all_device/devicelocation.dart';
import 'package:enavatek_mobile/screen/device_details/device_details_screen.dart';
import 'package:enavatek_mobile/screen/menu/building/building.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class AllDeviceScreen extends StatefulWidget {
  const AllDeviceScreen({Key? key}) : super(key: key);

  @override
  AllDeviceScreenState createState() => AllDeviceScreenState();
}

class AllDeviceScreenState extends State<AllDeviceScreen> {
  List<Building> buildings = [];
  List<Device> devices = [];

  @override
  void initState() {
    super.initState();
    getAllDevice();
  }

  Future<void> getAllDevice() async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? userId = await SharedPreferencesHelper.instance.getUserID();
    Response response =
        await RemoteServices.getAllDeviceByUserId(authToken!, userId!);
    if (response.statusCode == 200) {
      String responseBody = response.body;

      buildings = (json.decode(responseBody) as List)
          .map((data) => Building.fromJson(data))
          .toList();
      //List<Device> alldevices = getAllDevices(buildings);

      setState(() {
        devices = getAllDevices(buildings);
      });
      print(devices.length);
    } else {
      print('Response body: ${response.body}');
    }
  }

  List<Device> getAllDevices(List<Building> buildings) {
    List<Device> allDevices = [];

    for (var building in buildings) {
      for (var floor in building.floors) {
        for (var room in floor.rooms) {
          allDevices.addAll(room.devices);
        }
      }
    }

    return allDevices;
  }

  DeviceLocation findFloorAndRoomNameByDeviceId(
      List<Building> buildings, int deviceId) {
    for (final building in buildings) {
      for (final floor in building.floors) {
        for (final room in floor.rooms) {
          for (final device in room.devices) {
            if (device.deviceId == deviceId) {
              return DeviceLocation(floor.name, room.name);
            }
          }
        }
      }
    }
    return DeviceLocation(null, null); // Device not found
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
                        'All Devices',
                        style: GoogleFonts.roboto(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: ConstantColors.black),
                      ),
                    ],
                  ),
                ),
                // const Icon(
                //   Icons.filter_alt_rounded,
                //   color: ConstantColors.mainlyTextColor,
                //   size: 30,
                // ),
                // const SizedBox(width: 20),
                const Icon(
                  Icons.search,
                  color: ConstantColors.mainlyTextColor,
                  size: 30,
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                print(device.power);
                final deviceLocation =
                    findFloorAndRoomNameByDeviceId(buildings, device.deviceId);

                return GestureDetector(
                    onTap: () {
                      //Navigator.pushNamed(context, deviceDetailRoute);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeviceDetailScreen(
                              deviceName: device.displayName,
                              fanSpeed: device.fanSpeed,
                              mode: device.mode,
                              power: device.power,
                              deviceId: device.deviceId,
                            )),
                      );
                    },
                    child: Card(
                      elevation: 10.0,
                      child: Container(
                          decoration: BoxDecoration(
                              color: ConstantColors.whiteColor,
                              borderRadius: BorderRadius.circular(50)),
                          height: 150,
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${device.displayName}\n\n',
                                          style: GoogleFonts.roboto(
                                            color:
                                                ConstantColors.mainlyTextColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth * 0.04,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '${deviceLocation.floorName!} - ${deviceLocation.roomName}',
                                          style: GoogleFonts.roboto(
                                            color:
                                                ConstantColors.mainlyTextColor,
                                            fontSize: screenWidth * 0.035,
                                          ),
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
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 0, top: 15),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          const WidgetSpan(
                                            child: Icon(
                                              CupertinoIcons.thermometer,
                                              color: ConstantColors
                                                  .mainlyTextColor,
                                              size: 18,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Temp\n',
                                            style: GoogleFonts.roboto(
                                                fontSize: screenWidth * 0.035,
                                                color: ConstantColors
                                                    .mainlyTextColor),
                                          ),
                                          const WidgetSpan(
                                            child: SizedBox(
                                                width:
                                                    10), // Adjust the width as needed
                                          ),
                                          TextSpan(
                                            text: "24 c",
                                            style: GoogleFonts.roboto(
                                              color: ConstantColors
                                                  .mainlyTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: screenWidth * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          const WidgetSpan(
                                            child: Icon(
                                              CupertinoIcons.clock,
                                              color: ConstantColors
                                                  .mainlyTextColor,
                                              size: 15,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Mode\n',
                                            style: GoogleFonts.roboto(
                                              fontSize: screenWidth * 0.035,
                                              color: ConstantColors
                                                  .mainlyTextColor,
                                            ),
                                          ),
                                          TextSpan(
                                            text: device.mode,
                                            style: GoogleFonts.roboto(
                                              color: ConstantColors
                                                  .mainlyTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: screenWidth * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    MaterialButton(
                                      onPressed: () {},
                                      color: ConstantColors.whiteColor,
                                      textColor: Colors.white,
                                      minWidth: 30,
                                      height: 30,
                                      shape: const CircleBorder(
                                        side: BorderSide(
                                          color:
                                              ConstantColors.borderButtonColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: Image.asset(
                                        ImgPath.pngPlus,
                                        height: 15,
                                        width: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    MaterialButton(
                                      onPressed: () {},
                                      color: ConstantColors.whiteColor,
                                      textColor: Colors.white,
                                      minWidth: 30,
                                      height: 30,
                                      shape: const CircleBorder(
                                        side: BorderSide(
                                          color:
                                              ConstantColors.borderButtonColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: Image.asset(
                                        ImgPath.pngRemove,
                                        height: 15,
                                        width: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    MaterialButton(
                                      onPressed: () async {
                                        print(device.power);
                                        String value;
                                        if (device.power == 'ON') {
                                          value = "OFF";
                                        } else {
                                          value = "ON";
                                        }
                                        String? authToken =
                                            await SharedPreferencesHelper
                                                .instance
                                                .getAuthToken();
                                        int? loginId =
                                            await SharedPreferencesHelper
                                                .instance
                                                .getLoginID();
                                        Response response =
                                            await RemoteServices.actionCommand(
                                                authToken!,
                                                value,
                                                device.deviceId,
                                                1,
                                                loginId!);
                                        var data = jsonDecode(response.body);

                                        if (response.statusCode == 200) {
                                          print(data["message"]);

                                          getAllDevice();
                                        }
                                      },
                                      color: device.power.toLowerCase() == 'off'
                                          ? ConstantColors.orangeColor
                                          : ConstantColors.greenColor,
                                      textColor: Colors.white,
                                      minWidth: 30,
                                      height: 30,
                                      shape: CircleBorder(
                                        side: BorderSide(
                                          color: device.power.toLowerCase() ==
                                                  'off'
                                              ? ConstantColors.orangeColor
                                              : ConstantColors.greenColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                          Icons.power_settings_new,
                                          size: 20,
                                          color: ConstantColors.whiteColor),
                                    )
                                 
                                  ]),
                            ),
                          ])),
                    ));
              },
            )
          ],
        ),
      ),
    );
  }
}
