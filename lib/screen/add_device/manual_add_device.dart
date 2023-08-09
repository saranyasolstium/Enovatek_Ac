import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/decoration.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManualAddDevice extends StatefulWidget {
  const ManualAddDevice({Key? key}) : super(key: key);

  @override
  ManualAddDeviceState createState() => ManualAddDeviceState();
}

class ManualAddDeviceState extends State<ManualAddDevice> {
  TextEditingController passwordEditingController =
      TextEditingController(text: '**** **** **** 1234');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  ImgPath.pngArrowBack,
                  height: 25,
                  width: 25,
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
                'Add serial no. manually of your device',
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ConstantColors.black),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Container(
              decoration: const BoxDecoration(color: ConstantColors.whiteColor),
              width: 250,
              height: 250,
              child: Center(
                child: Text(
                  'Please need photo (Client)',
                  style: GoogleFonts.roboto(
                      fontSize: 16, color: ConstantColors.mainlyTextColor),
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 0),
              child: TextField(
                controller: passwordEditingController,
                style: GoogleFonts.roboto(
                  color: ConstantColors.mainlyTextColor,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecorationStyle.textFieldDecoration(
                  placeholder: "**** **** **** 1234",
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
             const Center(
              child: SizedBox(
              width: 150,
              height: 50,
              child: RoundedButton(
                text: "Proceed",
                backgroundColor: ConstantColors.borderButtonColor,
                textColor: ConstantColors.whiteColor,
                naviagtionRoute: wifiPassword,),
            ),
          
            )
          ],
        ),
      ),
    );
  }
}
