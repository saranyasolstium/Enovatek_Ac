// ignore_for_file: use_build_context_synchronously

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/screen/add_device/add_building.dart';
import 'package:enavatek_mobile/screen/add_device/device_assign/device_assigning.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/decoration.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WifiPasswordScreen extends StatefulWidget {
  final String deviceSerialNo;
  final int buildingID;
  final String buildingName;
  const WifiPasswordScreen(
      {Key? key,
      required this.deviceSerialNo,
      required this.buildingID,
      required this.buildingName})
      : super(key: key);

  @override
  WifiPasswordScreenState createState() => WifiPasswordScreenState();
}

class WifiPasswordScreenState extends State<WifiPasswordScreen> {
  TextEditingController wifiNameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.deviceSerialNo);

    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      body: Padding(
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
                  'Add Device',
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
            Center(
              child: Text(
                textAlign: TextAlign.center,
                'Select a Wi-Fi network from the list \n to connect air conditioner.',
                style: GoogleFonts.roboto(
                    fontSize: 16, color: ConstantColors.mainlyTextColor),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              padding: const EdgeInsets.only(left: 20, right: 0),
              decoration: BoxDecoration(
                color: ConstantColors.inputColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                autocorrect: false,
                controller: wifiNameTextController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.expand_more,
                      color: ConstantColors.mainlyTextColor,
                    ),
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    hintText: 'Your_Wi-Fi_name'),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 0),
              child: TextField(
                controller: passwordTextController,
                obscureText: true,
                style: GoogleFonts.roboto(
                  color: ConstantColors.mainlyTextColor,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecorationStyle.textFieldDecoration(
                    placeholder: "Enter Password", context: context),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Center(
              child: SizedBox(
                width: 150,
                height: 50,
                child: RoundedButton(
                  onPressed: () async {
                    String wifiName = wifiNameTextController.text;
                    String password = passwordTextController.text;
                    if (wifiName.isNotEmpty && password.isNotEmpty) {
                      if (widget.buildingID == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeviceAddBuildingScreen(
                                    deviceSerialNo: widget.deviceSerialNo,
                                    wifinName: wifiName,
                                    password: password,
                                  )),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeviceAssigningScreen(
                                    buildingID: widget.buildingID,
                                    buildingName: widget.buildingName,
                                    deviceSerialNo: widget.deviceSerialNo,
                                    wifinName: wifiName,
                                    password: password,
                                  )),
                        );
                      }
                    } else {
                      SnackbarHelper.showSnackBar(
                          context, "Filed cannot be empty");
                    }
                  },
                  text: "Connect",
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
