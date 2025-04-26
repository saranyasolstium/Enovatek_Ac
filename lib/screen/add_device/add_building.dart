// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/add_device/device_assign/device_assigning.dart';
import 'package:enavatek_mobile/screen/menu/building/building.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class DeviceAddBuildingScreen extends StatefulWidget {
  final String deviceSerialNo;
  final String bussiness;
  final String location;

  const DeviceAddBuildingScreen(
      {Key? key,
      required this.deviceSerialNo,
      required this.bussiness,
      required this.location})
      : super(key: key);
  @override
  DeviceAddBuildingScreenState createState() => DeviceAddBuildingScreenState();
}

class DeviceAddBuildingScreenState extends State<DeviceAddBuildingScreen> {
  @override
  void initState() {
    super.initState();
    getAllDevice();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAllDevice();
  }

  List<Building> buildings = [];

  Future<void> getAllDevice() async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? userId = await SharedPreferencesHelper.instance.getUserID();
    Response response =
        await RemoteServices.getAllDeviceByUserId(authToken!, userId!);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey("buildings")) {
        List<dynamic> buildingsJson = responseBody["buildings"];
        setState(() {
          buildings = buildingsJson
              .map((data) => Building.fromJson(data))
              .where((building) => building.buildingId != 0)
              .toList();
        });
      } else {
        print("Response doesn't contain 'buildings' key.");
      }
    } else {
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      bottomNavigationBar: const Footer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          isTablet ? screenHeight * 0.02 : screenWidth * 0.05,
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
                          height: isTablet ? 40 : 22,
                          width: isTablet ? 40 : 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Buildings',
                        style: GoogleFonts.roboto(
                            fontSize: isTablet
                                ? screenWidth * 0.03
                                : screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: ConstantColors.black),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, addBuildingRoute);
                  },
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
            ListView.builder(
              itemCount: buildings.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final building = buildings[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeviceAssigningScreen(
                                buildingID: building.buildingId,
                                buildingName: building.name,
                                deviceSerialNo: widget.deviceSerialNo,
                                business: widget.bussiness,
                                location: widget.location,
                              )),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom:
                          isTablet ? 0.03 * screenHeight : 0.03 * screenHeight,
                    ),
                    decoration: BoxDecoration(
                      color: ConstantColors.whiteColor,
                      borderRadius: BorderRadius.circular(0.1 * screenHeight),
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(
                          left: isTablet ? 40 : 20,
                          right: isTablet ? 40 : 20,
                          top: isTablet ? 20 : 0,
                          bottom: isTablet ? 20 : 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              building.name,
                              style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet
                                    ? screenWidth * 0.022
                                    : screenWidth * 0.04,
                              ),
                            ),
                            Row(
                              children: [
                                MaterialButton(
                                  onPressed: () async {
                                    String? authToken =
                                        await SharedPreferencesHelper.instance
                                            .getAuthToken();
                                    int? userId = await SharedPreferencesHelper
                                        .instance
                                        .getUserID();
                                    Response response =
                                        await RemoteServices.deleteBuilding(
                                            authToken!,
                                            building.name,
                                            building.buildingId,
                                            userId!);
                                    var data = jsonDecode(response.body);

                                    if (response.statusCode == 200) {
                                      if (data.containsKey("message")) {
                                        String message = data["message"];
                                        SnackbarHelper.showSnackBar(
                                            context, message);
                                      }
                                      getAllDevice();
                                    } else {
                                      if (data.containsKey("message")) {
                                        String errorMessage = data["message"];
                                        SnackbarHelper.showSnackBar(
                                            context, errorMessage);
                                      }
                                    }
                                  },
                                  color: ConstantColors.orangeColor,
                                  textColor: Colors.white,
                                  minWidth: isTablet
                                      ? 0.04 * screenWidth
                                      : 0.03 * screenWidth,
                                  height: isTablet
                                      ? 0.04 * screenHeight
                                      : 0.03 * screenHeight,
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      color: ConstantColors.orangeColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: Image.asset(
                                    ImgPath.pngDelete,
                                    width: isTablet
                                        ? 0.025 * screenWidth
                                        : 0.025 * screenWidth,
                                    height: isTablet
                                        ? 0.025 * screenHeight
                                        : 0.025 * screenHeight,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: ConstantColors.mainlyTextColor,
                                  size: isTablet ? 30 : 20,
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
