import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  SupportScreenState createState() => SupportScreenState();
}

class SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 30, 10),
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
                  'Support',
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
                    hintText: 'Subject'),
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
                    hintText: 'Product'),
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
                maxLines: 6,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 14,
                    ),
                    hintText: 'Write your problem'),
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
                    suffixIcon: Container(
                      padding: const EdgeInsets.all(15.0),
                      constraints: const BoxConstraints(
                        maxHeight: 10.0,
                        maxWidth: 10.0,
                      ),
                      child: Image(
                        image: AssetImage(
                          ImgPath.pngUpload,
                        ),
                        height: 20,
                        width: 20,
                      ),
                    ),
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 14,
                    ),
                    hintText: 'Upload attachment'),
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
