// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/screen/home/build_row.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class EditBuildingScreen extends StatefulWidget {
  final String buildingName;
  final String buildingID;
  const EditBuildingScreen(
      {Key? key, required this.buildingName, required this.buildingID})
      : super(key: key);

  @override
  EditBuildingScreenState createState() => EditBuildingScreenState();
}

class EditBuildingScreenState extends State<EditBuildingScreen> {
  List<Map<String, dynamic>> floorList = [];
  List<Map<String, dynamic>> filteredFloors = [];
  List<Map<String, dynamic>> roomList = [];

  @override
  void initState() {
    super.initState();
    getFloorName();
    getRoomName();
  }

  Future<void> getFloorName() async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    Response response = await RemoteServices.getFloorInfo(authToken!);

    if (response.statusCode == 200) {
      List<dynamic> dynamicFloorList = jsonDecode(response.body);
      floorList = dynamicFloorList.cast<Map<String, dynamic>>();
      setState(() {
        filteredFloors = floorList
            .where(
                (floor) => floor['building_id'].toString() == widget.buildingID)
            .toList();
      });
    } else {
      print(
          'Failed to get floor information. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> getRoomName() async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();

    Response response = await RemoteServices.getRoomInfo(authToken!);

    if (response.statusCode == 200) {
      List<dynamic> dynamicRoomList = jsonDecode(response.body);

      setState(() {
        roomList = dynamicRoomList.cast<Map<String, dynamic>>();
      });
    } else {
      print(
          'Failed to get room information. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
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
          screenHeight * 0.05,
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
                          Navigator.pop(context);
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
                MaterialButton(
                  onPressed: () {},
                  color: ConstantColors.whiteColor,
                  textColor: Colors.white,
                  minWidth: isTablet ? 0.04 * screenWidth : 0.035 * screenWidth,
                  height: isTablet ? 0.04 * screenHeight : 0.035 * screenHeight,
                  shape: const CircleBorder(
                    side: BorderSide(
                      color: ConstantColors.borderButtonColor,
                      width: 2,
                    ),
                  ),
                  child: Image.asset(
                    ImgPath.pngPlus,
                    width: isTablet ? 0.03 * screenWidth : 0.03 * screenWidth,
                    height:
                        isTablet ? 0.03 * screenHeight : 0.03 * screenHeight,
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

                String? authToken =
                    await SharedPreferencesHelper.instance.getAuthToken();

                Response response = await RemoteServices.addBuildingName(
                    authToken!, buildingName);
                print(response.statusCode);
                if (response.statusCode == 201) {
                  SnackbarHelper.showSnackBar(
                      context, "building name update successfully");
                  //Navigator.pushReplacementNamed(context, homedRoute);
                } else {
                  SnackbarHelper.showSnackBar(context,
                      "Update building name failed! Please try again!");
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
                          top: 0.03 * screenHeight,
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
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              // Navigator.pushReplacementNamed(
                              //     context, addBuildingRoute);
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
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    filteredFloors.isEmpty
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
                              itemCount: filteredFloors.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final floor = filteredFloors[index];

                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          floor['floor_name'],
                                          style: GoogleFonts.roboto(
                                            color:
                                                ConstantColors.mainlyTextColor,
                                            fontSize: screenWidth * 0.04,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            MaterialButton(
                                              onPressed: () {
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //       builder: (context) =>
                                                //           EditBuildingScreen(
                                                //             buildingName:
                                                //                 building.name,
                                                //             buildingID: building.id,
                                                //           )),
                                                // );
                                              },
                                              color: ConstantColors.whiteColor,
                                              textColor: Colors.white,
                                              minWidth: isTablet
                                                  ? 0.04 * screenWidth
                                                  : 0.03 * screenWidth,
                                              height: isTablet
                                                  ? 0.04 * screenHeight
                                                  : 0.03 * screenHeight,
                                              shape: const CircleBorder(
                                                side: BorderSide(
                                                  color: ConstantColors
                                                      .borderButtonColor,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Image.asset(
                                                ImgPath.pngEdit,
                                                width: isTablet
                                                    ? 0.03 * screenWidth
                                                    : 0.025 * screenWidth,
                                                height: isTablet
                                                    ? 0.03 * screenHeight
                                                    : 0.02 * screenHeight,
                                                color: ConstantColors
                                                    .lightBlueColor,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            MaterialButton(
                                              onPressed: () {},
                                              color: ConstantColors.orangeColor,
                                              minWidth: isTablet
                                                  ? 0.04 * screenWidth
                                                  : 0.03 * screenWidth,
                                              height: isTablet
                                                  ? 0.04 * screenHeight
                                                  : 0.03 * screenHeight,
                                              shape: const CircleBorder(
                                                side: BorderSide(
                                                  color: ConstantColors
                                                      .orangeColor,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Image.asset(
                                                ImgPath.pngDelete,
                                                width: isTablet
                                                    ? 0.03 * screenWidth
                                                    : 0.025 * screenWidth,
                                                height: isTablet
                                                    ? 0.03 * screenHeight
                                                    : 0.025 * screenHeight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
                          top: 0.03 * screenHeight,
                          right: 0.05 * screenWidth),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Room',
                            style: GoogleFonts.roboto(
                              fontSize: screenWidth * 0.04,
                              color: ConstantColors.mainlyTextColor,
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              // Navigator.pushReplacementNamed(
                              //     context, addBuildingRoute);
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
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    filteredFloors.isEmpty
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
                        : Padding(
                            padding: EdgeInsets.only(
                                left: 0.05 * screenWidth,
                                right: 0.03 * screenWidth),
                            child: ListView.builder(
                              itemCount: roomList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final room = roomList[index];

                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          room['room_number'],
                                          style: GoogleFonts.roboto(
                                            color:
                                                ConstantColors.mainlyTextColor,
                                            fontSize: screenWidth * 0.04,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            MaterialButton(
                                              onPressed: () {
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //       builder: (context) =>
                                                //           EditBuildingScreen(
                                                //             buildingName:
                                                //                 building.name,
                                                //             buildingID: building.id,
                                                //           )),
                                                // );
                                              },
                                              color: ConstantColors.whiteColor,
                                              textColor: Colors.white,
                                              minWidth: isTablet
                                                  ? 0.04 * screenWidth
                                                  : 0.03 * screenWidth,
                                              height: isTablet
                                                  ? 0.04 * screenHeight
                                                  : 0.03 * screenHeight,
                                              shape: const CircleBorder(
                                                side: BorderSide(
                                                  color: ConstantColors
                                                      .borderButtonColor,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Image.asset(
                                                ImgPath.pngEdit,
                                                width: isTablet
                                                    ? 0.03 * screenWidth
                                                    : 0.025 * screenWidth,
                                                height: isTablet
                                                    ? 0.03 * screenHeight
                                                    : 0.02 * screenHeight,
                                                color: ConstantColors
                                                    .lightBlueColor,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            MaterialButton(
                                              onPressed: () {},
                                              color: ConstantColors.orangeColor,
                                              minWidth: isTablet
                                                  ? 0.04 * screenWidth
                                                  : 0.03 * screenWidth,
                                              height: isTablet
                                                  ? 0.04 * screenHeight
                                                  : 0.03 * screenHeight,
                                              shape: const CircleBorder(
                                                side: BorderSide(
                                                  color: ConstantColors
                                                      .orangeColor,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Image.asset(
                                                ImgPath.pngDelete,
                                                width: isTablet
                                                    ? 0.03 * screenWidth
                                                    : 0.025 * screenWidth,
                                                height: isTablet
                                                    ? 0.03 * screenHeight
                                                    : 0.025 * screenHeight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors
                                          .grey, // You can customize the color and height of the divider
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
          ],
        ),
      ),
    );
  }
}
