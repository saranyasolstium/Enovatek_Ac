import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/screen/add_device/device_assign/add_device.dart';
import 'package:enavatek_mobile/screen/menu/building/floor/add_floor.dart';
import 'package:enavatek_mobile/screen/add_device/device_assign/edit_floor.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class DeviceAssigningScreen extends StatefulWidget {
  final String buildingId;
  const DeviceAssigningScreen({Key? key, required this.buildingId})
      : super(key: key);

  @override
  DeviceAssigningScreenState createState() => DeviceAssigningScreenState();
}

class DeviceAssigningScreenState extends State<DeviceAssigningScreen> {
  List<Map<String, dynamic>> floorList = [];
  List<Map<String, dynamic>> filteredFloors = [];

  List<Map<String, dynamic>> roomList = [];
  List<Map<String, dynamic>> deviceList = [];

  @override
  void initState() {
    super.initState();
   
    getDeviceInfo();
  }

 
  Future<void> getDeviceInfo() async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();

    Response response = await RemoteServices.getDeviceInfo(authToken!);

    if (response.statusCode == 200) {
      List<dynamic> dynamicDeviceList = jsonDecode(response.body);

      setState(() {
        deviceList = dynamicDeviceList.cast<Map<String, dynamic>>();
      });
    } else {
      print(
          'Failed to get room information. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
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
              'Lorem ipsum building',
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
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 5),
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
                                  builder: (context) => AddFloorName(
                                    buildingName: "",
                                        buildingID: 0,
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
                    const Divider(thickness: 1),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredFloors.length,
                      itemBuilder: (BuildContext context, int index) {
                        final floor = filteredFloors[index];

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                //Navigator.pushNamed(context, editFloorNameRoute);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditFloorName(
                                          floorName: floor['floor_name'],
                                          floorid: floor['id'])),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    floor['floor_name'],
                                    style: GoogleFonts.roboto(
                                      color: ConstantColors.mainlyTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: ConstantColors.mainlyTextColor,
                                    size: 28,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Add Room',
                                  style: GoogleFonts.roboto(
                                      color: ConstantColors.mainlyTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                const Spacer(),
                                MaterialButton(
                                  onPressed: () {
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => AddRoomName(
                                    //             floorList: floorList,
                                    //           )),
                                    // );
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
                            const SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: roomList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final room = roomList[index];

                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        //Navigator.pushNamed(context, editFloorNameRoute);
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) => EditFloorName(floorName: floor['room_number'],
                                        //       floorid: floor['id'])),
                                        // );
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            room['room_number'],
                                            style: GoogleFonts.roboto(
                                              color: ConstantColors
                                                  .mainlyTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color:
                                                ConstantColors.mainlyTextColor,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(thickness: 1),
                                  ],
                                );
                              },
                            ),

                             const SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      },
                    ),

                    // Row(
                    //   children: [
                    //     Text(
                    //       'Add Room',
                    //       style: GoogleFonts.roboto(
                    //           color: ConstantColors.mainlyTextColor,
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 14),
                    //     ),
                    //     const Spacer(),
                    //     MaterialButton(
                    //       onPressed: () {
                    //         Navigator.pushReplacement(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => AddRoomName(
                    //                     floorList: floorList,
                    //                   )),
                    //         );
                    //       },
                    //       color: ConstantColors.whiteColor,
                    //       textColor: Colors.white,
                    //       minWidth: 20,
                    //       height: 20,
                    //       shape: const CircleBorder(
                    //         side: BorderSide(
                    //           color: ConstantColors.borderButtonColor,
                    //           width: 2,
                    //         ),
                    //       ),
                    //       child: Image.asset(
                    //         ImgPath.pngPlus,
                    //         height: 10,
                    //         width: 10,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   itemCount: roomList.length,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     final room = roomList[index];

                    //     return Column(
                    //       children: [
                    //         GestureDetector(
                    //           onTap: () {
                    //             //Navigator.pushNamed(context, editFloorNameRoute);
                    //             // Navigator.push(
                    //             //   context,
                    //             //   MaterialPageRoute(
                    //             //       builder: (context) => EditFloorName(floorName: floor['room_number'],
                    //             //       floorid: floor['id'])),
                    //             // );
                    //           },
                    //           child: Row(
                    //             children: [
                    //               Text(
                    //                 room['room_number'],
                    //                 style: GoogleFonts.roboto(
                    //                   color: ConstantColors.mainlyTextColor,
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: 14,
                    //                 ),
                    //               ),
                    //               const Spacer(),
                    //               const Icon(
                    //                 Icons.arrow_forward_ios,
                    //                 color: ConstantColors.mainlyTextColor,
                    //                 size: 18,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         const Divider(thickness: 1),
                    //       ],
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 5, bottom: 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Add Device',
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
                                  builder: (context) => AddDeviceName(
                                        roomList: roomList,
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: deviceList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final device = deviceList[index];

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Text(
                                    device['device_sku'],
                                    style: GoogleFonts.roboto(
                                      color: ConstantColors.mainlyTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: ConstantColors.mainlyTextColor,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(thickness: 1),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
