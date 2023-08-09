import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/decoration.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WifiPasswordScreen extends StatefulWidget {
  const WifiPasswordScreen({Key? key}) : super(key: key);

  @override
  WifiPasswordScreenState createState() => WifiPasswordScreenState();
}

class WifiPasswordScreenState extends State<WifiPasswordScreen> {
  

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
              textAlign:TextAlign.center,
                'Select a Wi-Fi network from the list \n to connect air conditioner.',
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: ConstantColors.mainlyTextColor),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
           Padding(
              padding: const EdgeInsets.only(left: 20, right: 0),
              child: TextField(
                style: GoogleFonts.roboto(
                  color: ConstantColors.mainlyTextColor,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecorationStyle.textFieldDecoration(
                  placeholder: "Your_Wi-Fi_name",
                ),
              ),
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
                  placeholder: "Enter Password",
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
           
             const Center(
              child: SizedBox(
              width: 150,
              height: 50,
              child: RoundedButton(
                text: "Connect",
                backgroundColor: ConstantColors.borderButtonColor,
                textColor: ConstantColors.whiteColor,
                naviagtionRoute: deviceName,),
            ),
          
            )
          ],
        ),
      ),
    );
  }
}
