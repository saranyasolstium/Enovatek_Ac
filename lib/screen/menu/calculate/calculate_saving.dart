import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalculateSavingScreen extends StatefulWidget {
  const CalculateSavingScreen({Key? key}) : super(key: key);

  @override
  CalculateSavingScreenState createState() => CalculateSavingScreenState();
}

class CalculateSavingScreenState extends State<CalculateSavingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      body: Padding(
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
                  'Calculate saving',
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
              child: Image.asset(ImgPath.pngIntro4,height: 200,),
            ),
            const SizedBox(
              height: 60,
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
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.expand_more,
                    color: ConstantColors.mainlyTextColor,
                  ),
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 14,
                  ),
                  hintText: 'Select Country'
                ),
              ),
            ),

            const SizedBox(
              height: 20,
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
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.expand_more,
                    color: ConstantColors.mainlyTextColor,
                  ),
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 14,
                  ),
                  hintText: 'No. of days your facility use the Air Con'
                ),
              ),
            ),

            const SizedBox(
              height: 20,
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
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.expand_more,
                    color: ConstantColors.mainlyTextColor,
                  ),
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 14,
                  ),
                  hintText: 'Select the timings of use'
                ),
              ),
            ),

            const SizedBox(
              height: 20,
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
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.expand_more,
                    color: ConstantColors.mainlyTextColor,
                  ),
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 14,
                  ),
                  hintText: 'Select the BTU/HP/Tonnage of your air con'
                ),
              ),
            ),

            const SizedBox(
              height: 40,
            ),
           

            const Center(
              child: SizedBox(
                width: 150,
                height: 50,
                child: RoundedButton(
                  text: "Proceed",
                  backgroundColor: ConstantColors.borderButtonColor,
                  textColor: ConstantColors.whiteColor,
                  naviagtionRoute: savingRoute,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
