// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/screen/menu/building/edit_building.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/custom_textfiled.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class UpdateFloor extends StatefulWidget {
  final String floorName;
  final String buildingName;
  final int buildingID;
  final int floorID;

  const UpdateFloor({
    Key? key,
    required this.floorName,
    required this.buildingID,
    required this.floorID,
    required this.buildingName,
  }) : super(key: key);

  @override
  UpdateFloorState createState() => UpdateFloorState();
}

class UpdateFloorState extends State<UpdateFloor> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth >= 600;

    TextEditingController floorNameController = TextEditingController();
    floorNameController.text = widget.floorName;
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => EditBuildingScreen(
                      buildingName: widget.buildingName,
                      buildingID: widget.buildingID,
                    )),
          );
          return false;
        },
        child: Scaffold(
          backgroundColor: ConstantColors.backgroundColor,
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              isTablet ? screenHeight * 0.02 : screenWidth * 0.05,
              screenHeight * 0.06,
              screenWidth * 0.05,
              screenHeight * 0.02,
            ),
            child: Column(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditBuildingScreen(
                                  buildingName: widget.buildingName,
                                  buildingID: widget.buildingID,
                                )),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          ImgPath.pngArrowBack,
                          height: isTablet ? 40 : 22,
                          width: isTablet ? 40 : 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Floor',
                          style: GoogleFonts.roboto(
                              fontSize: isTablet
                                  ? screenWidth * 0.03
                                  : screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                              color: ConstantColors.black),
                        ),
                      ],
                    )),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                CustomTextField(
                  controller: floorNameController,
                  label: "Floor name",
                  suffixIcon: Icons.edit,
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                RoundedButton(
                  onPressed: () async {
                    String floorName = floorNameController.text;

                    if (floorName.isEmpty) {
                      SnackbarHelper.showSnackBar(
                          context, "Please enter a Floor name");
                      return;
                    }
                    String? authToken =
                        await SharedPreferencesHelper.instance.getAuthToken();
                    int? userId =
                        await SharedPreferencesHelper.instance.getUserID();
                    Response response = await RemoteServices.createFloor(
                        authToken!,
                        floorName,
                        widget.buildingID,
                        widget.floorID,
                        userId!);
                    var data = jsonDecode(response.body);

                    if (response.statusCode == 200) {
                      if (data.containsKey("message")) {
                        String message = data["message"];
                        SnackbarHelper.showSnackBar(context, message);
                      }
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditBuildingScreen(
                                  buildingName: widget.buildingName,
                                  buildingID: widget.buildingID,
                                )),
                      );
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
              ],
            ),
          ),
        ));
  }
}
