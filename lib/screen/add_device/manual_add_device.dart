import 'package:enavatek_mobile/screen/add_device/add_building.dart';
import 'package:enavatek_mobile/screen/add_device/device_assign/device_assigning.dart';
import 'package:enavatek_mobile/screen/add_device/basic_detail_screen.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/decoration.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManualAddDevice extends StatefulWidget {
  final int buildingID;
  final String buildingName;
  const ManualAddDevice(
      {Key? key, required this.buildingID, required this.buildingName})
      : super(key: key);

  @override
  ManualAddDeviceState createState() => ManualAddDeviceState();
}

class ManualAddDeviceState extends State<ManualAddDevice> {
  TextEditingController deviceSerialNoTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      bottomNavigationBar: Footer(),
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
                'Add serial no. manually of your device',
                style: GoogleFonts.roboto(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: ConstantColors.black),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              ImgPath.pngSerialNo,
              height: screenWidth * 0.6,
              width: screenWidth * 0.6,
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 0),
              child: TextField(
                controller: deviceSerialNoTextController,
                style: GoogleFonts.roboto(
                  color: ConstantColors.mainlyTextColor,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecorationStyle.textFieldDecoration(
                    placeholder: "**** **** **** 1234", context: context),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: RoundedButton(
                onPressed: () {
                  String deviceSerialNo = deviceSerialNoTextController.text;
                  if (deviceSerialNo.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BasicDetailScreen(
                                buildingID: widget.buildingID,
                                buildingName: widget.buildingName,
                                deviceSerialNo: deviceSerialNo,
                              )),
                    );
                  } else {
                    SnackbarHelper.showSnackBar(
                        context, "Please enter a device serial no!");
                  }
                },
                text: "Proceed",
                backgroundColor: ConstantColors.borderButtonColor,
                textColor: ConstantColors.whiteColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
