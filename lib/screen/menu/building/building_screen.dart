// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/menu/building/building.dart';
import 'package:enavatek_mobile/screen/menu/building/edit_building.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class BuildingScreen extends StatefulWidget {
  const BuildingScreen({Key? key}) : super(key: key);

  @override
  BuildingScreenState createState() => BuildingScreenState();
}

class BuildingScreenState extends State<BuildingScreen> {
  @override
  void initState() {
    super.initState();
    getAllDevice();
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
      var data = jsonDecode(response.body);

      if (data is Map && data.containsKey("message")) {
        String message = data["message"];
        print(message);
        setState(() {
          buildings = [];
        });
      } else if (data is List) {
        setState(() {
          buildings = data.map((data) => Building.fromJson(data)).toList();
        });
      }
    } else {
      print(response.statusCode);
      setState(() {
        buildings = [];
      });
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
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              homedRoute, (route) => false);
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
                            color:  Colors.black),
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

                return Container(
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
                        left: 20,
                        right: 20,
                        top: isTablet ? 30 : 0,
                        bottom: isTablet ? 30 : 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            building.name,
                            style: GoogleFonts.roboto(
                              color: ConstantColors.mainlyTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                          Row(
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditBuildingScreen(
                                              buildingName: building.name,
                                              buildingID: building.buildingId,
                                            )),
                                  );
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
                                    color: ConstantColors.borderButtonColor,
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
                                  color: ConstantColors.lightBlueColor,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
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
                      )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
