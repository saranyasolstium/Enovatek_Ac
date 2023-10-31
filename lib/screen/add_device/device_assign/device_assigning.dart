import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/screen/add_device/device_assign/floor/device_floor.dart';
import 'package:enavatek_mobile/screen/add_device/device_assign/room/device_room.dart';
import 'package:enavatek_mobile/screen/add_device/device_name_screen.dart';
import 'package:enavatek_mobile/screen/menu/building/building.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class DeviceAssigningScreen extends StatefulWidget {
  final String deviceSerialNo;
  final String wifinName;
  final String password;

  const DeviceAssigningScreen(
      {Key? key,
      required this.deviceSerialNo,
      required this.wifinName,
      required this.password})
      : super(key: key);

  @override
  DeviceAssigningScreenState createState() => DeviceAssigningScreenState();
}

class DeviceAssigningScreenState extends State<DeviceAssigningScreen> {
  List<Building> buildings = [];
  List<Floor> floorsForBuilding = [];
  String? buildName;
  int? buildingID;

  @override
  void initState() {
    super.initState();
    getAllDevice();
  }

  Future<void> getAllDevice() async {
    String? newBuildingName =
        await SharedPreferencesHelper.instance.getBuildingName();
    buildingID = await SharedPreferencesHelper.instance.getBuildingID();
    setState(() {
      buildName = newBuildingName;
    });
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? userId = await SharedPreferencesHelper.instance.getUserID();
    Response response =
        await RemoteServices.getAllDeviceByUserId(authToken!, userId!);
    if (response.statusCode == 200) {
      String responseBody = response.body;

      buildings = (json.decode(responseBody) as List)
          .map((data) => Building.fromJson(data))
          .toList();
      setState(() {
        floorsForBuilding = getFloorsByBuildingId(buildingID!);
      });
    } else {
      print('Response body: ${response.body}');
    }
  }

  List<Floor> getFloorsByBuildingId(int targetBuildingId) {
    for (var building in buildings) {
      if (building.buildingId == targetBuildingId) {
        return building.floors;
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
        child: Column(
          children: [
            Row(
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
                  'Device assigning',
                  style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ConstantColors.black),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              buildName ?? 'Lorem ipsum building',
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ConstantColors.black),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Add Floor',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.mainlyTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        const Spacer(),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeviceAddFloor(
                                        buildingId: buildingID!,
                                        deviceSerialNo: widget.deviceSerialNo,
                                        password: widget.password,
                                        wifinName: widget.wifinName,
                                      )),
                            );
                          },
                          color: ConstantColors.whiteColor,
                          textColor: Colors.white,
                          minWidth: 20,
                          height: 20,
                          shape: const CircleBorder(
                            side: BorderSide(
                              color: ConstantColors.borderButtonColor,
                              width: 2,
                            ),
                          ),
                          child: Image.asset(
                            ImgPath.pngPlus,
                            height: 10,
                            width: 10,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: floorsForBuilding.length,
                      itemBuilder: (BuildContext context, int index) {
                        final floor = floorsForBuilding[index];

                        return Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  floor.name,
                                  style: GoogleFonts.roboto(
                                    color: ConstantColors.mainlyTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DeviceAddRoom(
                                                deviceSerialNo:
                                                    widget.deviceSerialNo,
                                                password: widget.password,
                                                wifinName: widget.wifinName,
                                                buildingID: buildingID,
                                                floorID: floor.floorId,
                                              )),
                                    );
                                  },
                                  color: ConstantColors.whiteColor,
                                  textColor: Colors.white,
                                  minWidth: 20,
                                  height: 20,
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      color: ConstantColors.borderButtonColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: Image.asset(
                                    ImgPath.pngPlus,
                                    height: 10,
                                    width: 10,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: ConstantColors.mainlyTextColor,
                                  size: 28,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            floor.rooms.isEmpty
                                ? const Text(
                                    'No room assigned',
                                    style: TextStyle(color: Colors.grey),
                                  )
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics:const NeverScrollableScrollPhysics(),
                                    itemCount: floor.rooms.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final room = floor.rooms[index];

                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                room.name,
                                                style: GoogleFonts.roboto(
                                                  color: ConstantColors
                                                      .mainlyTextColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DeviceNameScreen(
                                                              deviceSerialNo: widget
                                                                  .deviceSerialNo,
                                                              wifinName: widget
                                                                  .wifinName,
                                                              password: widget
                                                                  .password,
                                                              roomId:
                                                                  room.roomId,
                                                            )),
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: ConstantColors
                                                      .mainlyTextColor,
                                                  size: 18,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
