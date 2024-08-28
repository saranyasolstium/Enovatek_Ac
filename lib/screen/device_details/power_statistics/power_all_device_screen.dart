import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/screen/all_device/devicelocation.dart';
import 'package:enavatek_mobile/screen/device_details/device_details_screen.dart';
import 'package:enavatek_mobile/screen/device_details/power_statistics.dart';
import 'package:enavatek_mobile/screen/device_details/power_statistics/filter_screen.dart';
import 'package:enavatek_mobile/screen/menu/building/building.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:getwidget/types/gf_toggle_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class PowerStatisticsAllScreen extends StatefulWidget {
  final bool isFilter;
  final List<String> businessUnits;
  final List<String> locationUnits;
  final List<int> roomUnits;
  const PowerStatisticsAllScreen({
    Key? key,
    required this.isFilter,
    required this.businessUnits,
    required this.locationUnits,
    required this.roomUnits,
  }) : super(key: key);

  @override
  PowerStatisticsAllScreenState createState() =>
      PowerStatisticsAllScreenState();
}

class PowerStatisticsAllScreenState extends State<PowerStatisticsAllScreen> {
  List<Building> buildings = [];
  List<Device> devices = [];
  final List<String> deviceList = [];

  @override
  void initState() {
    super.initState();
    if (widget.isFilter) {
      applyFilters();
    } else {
      getAllDevice();
    }
  }

  Future<void> getAllDevice() async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? userId = await SharedPreferencesHelper.instance.getUserID();

    Response response =
        await RemoteServices.getAllDeviceByUserId(authToken!, userId!);

    if (response.statusCode == 200) {
      String responseBody = response.body;
      Map<String, dynamic> jsonData = json.decode(responseBody);

      if (jsonData.containsKey("buildings")) {
        List<dynamic> buildingList = jsonData["buildings"];
        buildings =
            buildingList.map((data) => Building.fromJson(data)).toList();
        setState(() {
          devices = getAllDevices(buildings);
          deviceList.clear();
          deviceList.addAll(
            devices
                .where((device) => device.power.toLowerCase() == 'on')
                .map((device) => device.deviceId),
          );
        });
        deviceList.forEach((deviceId) {
          print('Device ID: $deviceId');
        });
      } else {
        print('Response body does not contain buildings');
      }
    } else {
      print('Response body: ${response.body}');
    }
  }

  Future<void> applyFilters() async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? userId = await SharedPreferencesHelper.instance.getUserID();

    Map<String, dynamic> requestBody = {
      "room_ids": widget.roomUnits,
      "business_units": widget.businessUnits,
      "locations": widget.locationUnits,
    };

    print(requestBody);
    Response response = await RemoteServices.filteredDevices(
      authToken!,
      userId!,
      requestBody,
    );

    if (response.statusCode == 200) {
      String responseBody = response.body;
      Map<String, dynamic> jsonData = json.decode(responseBody);

      if (jsonData.containsKey("buildings")) {
        List<dynamic> buildingList = jsonData["buildings"];
        buildings =
            buildingList.map((data) => Building.fromJson(data)).toList();
        setState(() {
          devices = getAllDevices(buildings);
          deviceList.clear();
          deviceList.addAll(
            devices
                .where((device) => device.power.toLowerCase() == 'on')
                .map((device) => device.deviceId),
          );
        });
        deviceList.forEach((deviceId) {
          print('Device ID: $deviceId');
        });
      } else {
        print('Response body does not contain buildings');
      }
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
      List<Building> buildings, String deviceId) {
    for (final building in buildings) {
      for (final floor in building.floors) {
        for (final room in floor.rooms) {
          for (final device in room.devices) {
            if (device.deviceId == deviceId) {
              return DeviceLocation(building.name, floor.name, room.name);
            }
          }
        }
      }
    }
    return DeviceLocation(null, null, null);
  }

  Future<bool> _onWillPop() async {
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => PowerStatisticsScreen(
    //       deviceId: "",
    //       deviceList: deviceList,
    //       tabIndex: 1,
    //     ),
    //   ),
    //   (Route<dynamic> route) => false,
    // );
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth >= 600;

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: ConstantColors.backgroundColor,
          bottomNavigationBar: Footer(),
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
                              // Navigator.pop(context);
                              // Navigator.pushAndRemoveUntil(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => PowerStatisticsScreen(
                              //       deviceId: "",
                              //       deviceList: deviceList,
                              //       tabIndex: 1,
                              //     ),
                              //   ),
                              //   (Route<dynamic> route) => false,
                              // );
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
                            'Devices',
                            style: GoogleFonts.roboto(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.black),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FilterScreen()),
                        );
                      },
                      child: const Icon(
                        Icons.filter_alt_rounded,
                        color: ConstantColors.mainlyTextColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                devices.isEmpty
                    ? Container(
                        height: 500,
                        child: Center(
                          child: Text(
                            'No Device Found',
                            style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.appColor),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: devices.length,
                        itemBuilder: (context, index) {
                          final device = devices[index];
                          print(device.power);
                          final deviceLocation = findFloorAndRoomNameByDeviceId(
                              buildings, device.deviceId);

                          return GestureDetector(
                              onTap: () {},
                              child: Card(
                                elevation: 10.0,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: ConstantColors.whiteColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 100,
                                    child: Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 15,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${device.displayName}\n\n',
                                                    style: GoogleFonts.roboto(
                                                      color: ConstantColors
                                                          .mainlyTextColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          screenWidth * 0.04,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${deviceLocation.buildingName!} - ${deviceLocation.floorName!} - ${deviceLocation.roomName}',
                                                    style: GoogleFonts.roboto(
                                                      color: ConstantColors
                                                          .mainlyTextColor,
                                                      fontSize:
                                                          screenWidth * 0.035,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            GFToggle(
                                              onChanged: (val) async {
                                                print(val);

                                                String? authToken =
                                                    await SharedPreferencesHelper
                                                        .instance
                                                        .getAuthToken();
                                                int? loginId =
                                                    await SharedPreferencesHelper
                                                        .instance
                                                        .getLoginID();
                                                Response response =
                                                    await RemoteServices
                                                        .actionCommand(
                                                            authToken!,
                                                            val! ? "On" : "Off",
                                                            device.deviceId,
                                                            1,
                                                            loginId!);
                                                var data =
                                                    jsonDecode(response.body);
                                                print(data);
                                                if (response.statusCode ==
                                                    200) {
                                                  print(data["message"]);
                                                  getAllDevice();
                                                }
                                              },
                                              value: device.power == 'On'
                                                  ? true
                                                  : false,
                                              enabledThumbColor:
                                                  ConstantColors.whiteColor,
                                              enabledTrackColor:
                                                  ConstantColors.lightBlueColor,
                                              type: GFToggleType.ios,
                                            )
                                          ],
                                        ),
                                      ),
                                    ])),
                              ));
                        },
                      )
              ],
            ),
          ),
        ));
  }
}
