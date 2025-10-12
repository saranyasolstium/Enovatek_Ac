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

class AddRoom extends StatefulWidget {
  final String buildingName;
  final int? buildingID;
  final int? floorID;

  const AddRoom(
      {Key? key,
      required this.buildingID,
      required this.floorID,
      required this.buildingName})
      : super(key: key);

  @override
  AddRoomState createState() => AddRoomState();
}

class AddRoomState extends State<AddRoom> {
  TextEditingController roomNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => EditBuildingScreen(
                      buildingName: widget.buildingName,
                      buildingID: widget.buildingID!,
                    )),
          );
          return false;
        },
        child: Scaffold(
          backgroundColor: ConstantColors.backgroundColor,
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditBuildingScreen(
                                buildingName: widget.buildingName,
                                buildingID: widget.buildingID!,
                              )),
                    );
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        ImgPath.pngArrowBack,
                        height: isTablet ? 40 : 22,
                        width: isTablet ? 40 : 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Add Room',
                        style: GoogleFonts.roboto(
                            fontSize: isTablet
                                ? screenWidth * 0.03
                                : screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: ConstantColors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomTextField(
                  controller: roomNameController,
                  label: "Add room name",
                  suffixIcon: null,
                ),
                const SizedBox(
                  height: 50,
                ),
                RoundedButton(
                  onPressed: () async {
                    String roomName = roomNameController.text;

                    if (roomName.isEmpty) {
                      SnackbarHelper.showSnackBar(
                          context, "Please enter a room name");
                      return;
                    }
                    String? authToken =
                        await SharedPreferencesHelper.instance.getAuthToken();
                    int? userId =
                        await SharedPreferencesHelper.instance.getUserID();
                    int? userTypeId =
                        await SharedPreferencesHelper.instance.getUserTypeID();
                    Response response = await RemoteServices.createRoom(
                        authToken!,
                        roomName,
                        widget.buildingID!,
                        widget.floorID!,
                        0,
                        userId!);
                    var data = jsonDecode(response.body);

                    if (response.statusCode == 200) {
                      if (data.containsKey("message")) {
                        String message = data["message"];
                        SnackbarHelper.showSnackBar(context, message);
                        await RemoteServices.createUserActivity(
                          userId: userId,
                          userTypeId: userTypeId!,
                          remarks:
                              'Success,MobileApp: Room created. name="$roomName',
                          module: 'Room',
                          action: 'Create',
                          bearerToken: authToken,
                        );
                      }
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditBuildingScreen(
                                  buildingName: widget.buildingName,
                                  buildingID: widget.buildingID!,
                                )),
                      );
                    } else {
                      if (data.containsKey("message")) {
                        String errorMessage = data["message"];
                        SnackbarHelper.showSnackBar(context, errorMessage);
                        await RemoteServices.createUserActivity(
                          userId: userId,
                          userTypeId: userTypeId!,
                          remarks:
                              'Failed,MobileApp: Room created. name="$roomName',
                          module: 'Room',
                          action: 'Create',
                          bearerToken: authToken,
                        );
                      }
                    }
                  },
                  text: "Add",
                  backgroundColor: ConstantColors.borderButtonColor,
                  textColor: ConstantColors.whiteColor,
                ),
              ],
            ),
          ),
        ));
  }
}
