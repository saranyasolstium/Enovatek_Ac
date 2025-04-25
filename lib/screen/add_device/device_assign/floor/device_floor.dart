// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/screen/add_device/device_assign/device_assigning.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class DeviceAddFloor extends StatefulWidget {
  final String deviceSerialNo;
  final String business;
  final String location;
  final int buildingId;

  const DeviceAddFloor({
    Key? key,
    required this.deviceSerialNo,
    required this.business,
    required this.location,
    required this.buildingId,
  }) : super(key: key);

  @override
  DeviceAddFloorState createState() => DeviceAddFloorState();
}

class DeviceAddFloorState extends State<DeviceAddFloor> {
  TextEditingController floorNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DeviceAssigningScreen(
                      deviceSerialNo: widget.deviceSerialNo,
                      location: widget.location,
                      business: widget.business,
                      buildingID: widget.buildingId,
                      buildingName: "",
                    )),
          );

          return false;
        },
        child: Scaffold(
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeviceAssigningScreen(
                                    deviceSerialNo: widget.deviceSerialNo,
                                    location: widget.location,
                                    business: widget.business,
                                    buildingID: widget.buildingId,
                                    buildingName: "",
                                  )),
                        );
                      },
                      child: Image.asset(
                        ImgPath.pngArrowBack,
                        height: isTablet ? 40 : 22,
                        width: isTablet ? 40 : 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Add Floor',
                      style: GoogleFonts.roboto(
                          fontSize: isTablet ? 26 : 18,
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
                    style: GoogleFonts.roboto(
                      color: ConstantColors.mainlyTextColor,
                      fontSize:
                          isTablet ? screenWidth * 0.025 : screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
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
                        authToken!, floorName, widget.buildingId, 0, userId!);
                    var data = jsonDecode(response.body);

                    if (response.statusCode == 200) {
                      if (data.containsKey("message")) {
                        String message = data["message"];
                        SnackbarHelper.showSnackBar(context, message);
                      }
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeviceAssigningScreen(
                                  deviceSerialNo: widget.deviceSerialNo,
                                  location: widget.location,
                                  business: widget.business,
                                  buildingID: widget.buildingId,
                                  buildingName: "",
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
