import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/screen/add_device/device_assign/floor/device_floor.dart';
import 'package:enavatek_mobile/screen/add_device/device_assign/room/device_room.dart';
import 'package:enavatek_mobile/screen/add_device/device_name_screen.dart';
import 'package:enavatek_mobile/screen/menu/building/building.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class DeviceAssigningScreen extends StatefulWidget {
  final String deviceSerialNo;
  final String business;
  final String location;
  final int buildingID;
  final String buildingName;

  const DeviceAssigningScreen(
      {Key? key,
      required this.deviceSerialNo,
      required this.business,
      required this.location,
      required this.buildingID,
      required this.buildingName})
      : super(key: key);

  @override
  DeviceAssigningScreenState createState() => DeviceAssigningScreenState();
}

class DeviceAssigningScreenState extends State<DeviceAssigningScreen> {
  List<Building> buildings = [];
  List<Floor> floorsForBuilding = [];

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

      Map<String, dynamic> jsonData = json.decode(responseBody);
      List<dynamic> buildingsData = jsonData['buildings'];

      buildings = buildingsData.map((data) => Building.fromJson(data)).toList();
      setState(() {
        floorsForBuilding = getFloorsByBuildingId(widget.buildingID);
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      bottomNavigationBar: const Footer(),
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
                    height: isTablet ? 40 : 22,
                    width: isTablet ? 40 : 22,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Device assigning',
                  style: GoogleFonts.roboto(
                      fontSize:
                          isTablet ? screenWidth * 0.03 : screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: ConstantColors.black),
                ),
              ],
            ),
            SizedBox(
              height: isTablet ? 20 : 50,
            ),
            Text(
              widget.buildingName,
              style: GoogleFonts.roboto(
                  fontSize: isTablet ? screenWidth * 0.02 : 18,
                  fontWeight: FontWeight.bold,
                  color: ConstantColors.black),
            ),
            SizedBox(
              height: isTablet ? 20 : 50,
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
                              fontSize: isTablet ? 20 : 14),
                        ),
                        const Spacer(),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeviceAddFloor(
                                        buildingId: widget.buildingID!,
                                        deviceSerialNo: widget.deviceSerialNo,
                                        location: widget.location,
                                        business: widget.business,
                                      )),
                            );
                          },
                          color: ConstantColors.whiteColor,
                          textColor: Colors.white,
                          minWidth: isTablet ? 25 : 20,
                          height: isTablet ? 25 : 20,
                          shape: const CircleBorder(
                            side: BorderSide(
                              color: ConstantColors.borderButtonColor,
                              width: 2,
                            ),
                          ),
                          child: Image.asset(
                            ImgPath.pngPlus,
                            height: isTablet ? 15 : 10,
                            width: isTablet ? 15 : 10,
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
                                    fontSize: isTablet ? 20 : 14,
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
                                                location: widget.location,
                                                business: widget.business,
                                                buildingID: widget.buildingID,
                                                floorID: floor.floorId,
                                              )),
                                    );
                                  },
                                  color: ConstantColors.whiteColor,
                                  textColor: Colors.white,
                                  minWidth: isTablet ? 25 : 20,
                                  height: isTablet ? 25 : 20,
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                                  fontSize: isTablet ? 20 : 14,
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
                                                              business: widget
                                                                  .business,
                                                              location: widget
                                                                  .location,
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
