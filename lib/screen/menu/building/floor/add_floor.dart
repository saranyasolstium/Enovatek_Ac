// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/screen/menu/building/edit_building.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class AddFloorName extends StatefulWidget {
  final int? buildingID;
  final String buildingName;

  const AddFloorName(
      {Key? key, required this.buildingID, required this.buildingName})
      : super(key: key);

  @override
  AddFloorNameState createState() => AddFloorNameState();
}

class AddFloorNameState extends State<AddFloorName> {
  TextEditingController floorNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                Row(
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
                      child: Image.asset(
                        ImgPath.pngArrowBack,
                        height: 25,
                        width: 25,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Add Floor',
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
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    controller: floorNameController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      labelText: "Add floor name",
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
                const SizedBox(
                  height: 50,
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
                        authToken!, floorName, widget.buildingID!, 0, userId!);
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
                                  buildingID: widget.buildingID!,
                                )),
                      );
                    } else {
                      if (data.containsKey("message")) {
                        String errorMessage = data["message"];
                        SnackbarHelper.showSnackBar(context, errorMessage);
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
