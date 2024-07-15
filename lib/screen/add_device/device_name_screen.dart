// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/decoration.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class DeviceNameScreen extends StatefulWidget {
  final String deviceSerialNo;
  final String wifinName;
  final String password;
  final int roomId;
  const DeviceNameScreen(
      {Key? key,
      required this.deviceSerialNo,
      required this.wifinName,
      required this.password,
      required this.roomId})
      : super(key: key);

  @override
  DeviceNameScreenState createState() => DeviceNameScreenState();
}

class DeviceNameScreenState extends State<DeviceNameScreen> {
  TextEditingController displayNameController = TextEditingController();
  // TextEditingController deviceIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
                  'Add Device',
                  style: GoogleFonts.roboto(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: ConstantColors.black),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                'Customise your device name',
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ConstantColors.mainlyTextColor),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              ImgPath.pngIntro4,
              height: 350,
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 0),
              child: TextField(
                controller: displayNameController,
                style: GoogleFonts.roboto(
                  color: ConstantColors.mainlyTextColor,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecorationStyle.textFieldDecoration(
                    placeholder: "Enter Name", context: context),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 20, right: 0),
            //   child: TextField(
            //     controller: deviceIDController,
            //     style: GoogleFonts.roboto(
            //       color: ConstantColors.mainlyTextColor,
            //       fontWeight: FontWeight.w500,
            //     ),
            //     decoration: InputDecorationStyle.textFieldDecoration(
            //         placeholder: "Device ID", context: context),
            //   ),
            // ),
            // const SizedBox(
            //   height: 30,
            // ),
            Center(
              child: SizedBox(
                width: 150,
                height: 50,
                child: RoundedButton(
                  onPressed: () async {
                    String displayname = displayNameController.text;
                    // String deviceId = deviceIDController.text;

                    if (displayname.isNotEmpty) {
                      String? authToken =
                          await SharedPreferencesHelper.instance.getAuthToken();
                      int? userId =
                          await SharedPreferencesHelper.instance.getUserID();
                      Response response = await RemoteServices.createDevice(
                          //deviceId,
                          authToken!,
                          displayname,
                          widget.deviceSerialNo,
                          widget.wifinName,
                          widget.password,
                          0,
                          widget.roomId,
                          userId!);
                      var data = jsonDecode(response.body);

                      if (response.statusCode == 200) {
                        if (data.containsKey("message")) {
                          String message = data["message"];
                          SnackbarHelper.showSnackBar(context, message);
                        }
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            homedRoute, (route) => false);
                      } else {
                        if (data.containsKey("message")) {
                          String errorMessage = data["message"];
                          SnackbarHelper.showSnackBar(context, errorMessage);
                        }
                      }
                    } else {
                      SnackbarHelper.showSnackBar(
                          context, "please enter  name!");
                    }
                  },
                  text: "Proceed",
                  backgroundColor: ConstantColors.borderButtonColor,
                  textColor: ConstantColors.whiteColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
