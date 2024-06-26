// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/menu/building/building.dart';
import 'package:enavatek_mobile/screen/menu/building/floor/add_floor.dart';
import 'package:enavatek_mobile/screen/menu/building/floor/update_floor.dart';
import 'package:enavatek_mobile/screen/menu/building/room/add_room.dart';
import 'package:enavatek_mobile/screen/menu/building/room/update_room.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/add_button.dart';
import 'package:enavatek_mobile/widget/delete_button.dart';
import 'package:enavatek_mobile/widget/edit_button.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class EditBuildingScreen extends StatefulWidget {
  final String buildingName;
  final int buildingID;

  const EditBuildingScreen({
    Key? key,
    required this.buildingName,
    required this.buildingID,
  }) : super(key: key);

  @override
  EditBuildingScreenState createState() => EditBuildingScreenState();
}

class EditBuildingScreenState extends State<EditBuildingScreen> {
  @override
  void initState() {
    super.initState();
    getAllDevice();
  }

  List<Building> buildings = [];

  List<Floor> floorsForBuilding = [];
  String? authToken;
  int? userId;
  Future<void> getAllDevice() async {
    authToken = await SharedPreferencesHelper.instance.getAuthToken();
    userId = await SharedPreferencesHelper.instance.getUserID();
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
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth >= 600;
    TextEditingController buildingNameController = TextEditingController();
    buildingNameController.text = widget.buildingName;

    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.05,
          screenHeight * 0.06,
          screenWidth * 0.05,
          screenHeight * 0.02,
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
                          Navigator.pushReplacementNamed(
                              context, buildingRoute);
                        },
                        child: Image.asset(
                          ImgPath.pngArrowBack,
                          height: screenWidth * 0.05,
                          width: screenWidth * 0.05,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Building',
                        style: GoogleFonts.roboto(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: ConstantColors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 0.03 * screenWidth, right: 0.03 * screenWidth),
              child: TextFormField(
                controller: buildingNameController,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: "building name",
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: ConstantColors.mainlyTextColor,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: ConstantColors.mainlyTextColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: ConstantColors.mainlyTextColor),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            RoundedButton(
              onPressed: () async {
                String buildingName = buildingNameController.text;

                if (buildingName.isEmpty) {
                  SnackbarHelper.showSnackBar(
                      context, "Please enter a building name");
                  return;
                }

                Response response = await RemoteServices.addBuildingName(
                    authToken!, buildingName, widget.buildingID, userId!);
                var data = jsonDecode(response.body);

                if (response.statusCode == 200) {
                  if (data.containsKey("message")) {
                    String message = data["message"];
                    SnackbarHelper.showSnackBar(context, message);
                  }
                  Navigator.pushReplacementNamed(context, buildingRoute);
                } else {
                  if (data.containsKey("message")) {
                    String errorMessage = data["message"];
                    SnackbarHelper.showSnackBar(context, errorMessage);
                  }
                }
              },
              text: "Update",
              backgroundColor: ConstantColors.borderButtonColor,
              textColor: ConstantColors.whiteColor,
            ),
            SizedBox(
              height: screenHeight * 0.05,
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
                          top: 0.01 * screenHeight,
                          right: 0.05 * screenWidth),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Floor',
                            style: GoogleFonts.roboto(
                              fontSize: screenWidth * 0.04,
                              color: ConstantColors.mainlyTextColor,
                            ),
                          ),
                          MaterialAddButton(onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddFloorName(
                                      buildingName: widget.buildingName,
                                      buildingID: widget.buildingID)),
                            );
                          }),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    floorsForBuilding.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'No floor added',
                              style: GoogleFonts.roboto(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.grey),
                              textAlign: TextAlign.left,
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                                left: 0.05 * screenWidth,
                                right: 0.03 * screenWidth),
                            child: ListView.builder(
                              itemCount: floorsForBuilding.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final floor = floorsForBuilding[index];

                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          floor.name,
                                          style: GoogleFonts.roboto(
                                            color:
                                                ConstantColors.mainlyTextColor,
                                            fontSize: screenWidth * 0.04,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            MaterialEditButton(onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdateFloor(
                                                            buildingName: widget
                                                                .buildingName,
                                                            floorName:
                                                                floor.name,
                                                            buildingID: widget
                                                                .buildingID,
                                                            floorID:
                                                                floor.floorId)),
                                              );
                                            }),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            MaterialAddButton(onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddRoom(
                                                          buildingID:
                                                              widget.buildingID,
                                                          buildingName: widget
                                                              .buildingName,
                                                          floorID:
                                                              floor.floorId,
                                                        )),
                                              );
                                            }),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            MaterialDeleteButton(
                                                onPressed: () async {
                                              Response response =
                                                  await RemoteServices
                                                      .deleteFloor(
                                                          authToken!,
                                                          floor.name,
                                                          widget.buildingID,
                                                          floor.floorId,
                                                          userId!);
                                              var data =
                                                  jsonDecode(response.body);
                                              if (response.statusCode == 200) {
                                                if (data
                                                    .containsKey("message")) {
                                                  String message =
                                                      data["message"];
                                                  SnackbarHelper.showSnackBar(
                                                      context, message);
                                                }
                                                getAllDevice();
                                              } else {
                                                if (data
                                                    .containsKey("message")) {
                                                  String errorMessage =
                                                      data["message"];
                                                  SnackbarHelper.showSnackBar(
                                                      context, errorMessage);
                                                }
                                              }
                                            }),
                                          ],
                                        ),
                                      ],
                                    ),
                                    floor.rooms.isEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Text(
                                              'No room added',
                                              style: GoogleFonts.roboto(
                                                  fontSize: screenWidth * 0.04,
                                                  color: Colors.grey),
                                              textAlign: TextAlign.left,
                                            ),
                                          )
                                        : ListView.builder(
                                            itemCount: floor.rooms.length,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              final room = floor.rooms[index];

                                              return Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        room.name,
                                                        style:
                                                            GoogleFonts.roboto(
                                                          color: ConstantColors
                                                              .mainlyTextColor,
                                                          fontSize:
                                                              screenWidth *
                                                                  0.04,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          MaterialEditButton(
                                                              onPressed: () {
                                                            Navigator
                                                                .pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => UpdateRoom(
                                                                      roomName: room
                                                                          .name,
                                                                      buildingID:
                                                                          widget
                                                                              .buildingID,
                                                                      floorID: room
                                                                          .floorId,
                                                                      buildingName:
                                                                          widget
                                                                              .buildingName,
                                                                      roonID: room
                                                                          .roomId)),
                                                            );
                                                          }),
                                                          MaterialDeleteButton(
                                                              onPressed:
                                                                  () async {
                                                            Response response =
                                                                await RemoteServices.deleteRoom(
                                                                    authToken!,
                                                                    room.name,
                                                                    widget
                                                                        .buildingID,
                                                                    floor
                                                                        .floorId,
                                                                    room.roomId,
                                                                    userId!);
                                                            var data =
                                                                jsonDecode(
                                                                    response
                                                                        .body);

                                                            if (response
                                                                    .statusCode ==
                                                                200) {
                                                              if (data.containsKey(
                                                                  "message")) {
                                                                String message =
                                                                    data[
                                                                        "message"];
                                                                SnackbarHelper
                                                                    .showSnackBar(
                                                                        context,
                                                                        message);
                                                              }
                                                              getAllDevice();
                                                            } else {
                                                              if (data.containsKey(
                                                                  "message")) {
                                                                String
                                                                    errorMessage =
                                                                    data[
                                                                        "message"];
                                                                SnackbarHelper
                                                                    .showSnackBar(
                                                                        context,
                                                                        errorMessage);
                                                              }
                                                            }
                                                          }),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 1.0,
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
