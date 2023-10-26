import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/decoration.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeviceNameScreen extends StatefulWidget {
  const DeviceNameScreen({Key? key}) : super(key: key);

  @override
  DeviceNameScreenState createState() => DeviceNameScreenState();
}

class DeviceNameScreenState extends State<DeviceNameScreen> {
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
             Center(
              child: SizedBox(
                width: 150,
                height: 50,
                child: RoundedButton(
                   onPressed: (){
                Navigator.pushNamed(context, deviceAssignRoute);
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
