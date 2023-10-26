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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth >= 600;
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
            isTablet ? 0.05 * screenHeight : 0.05 * screenHeight,
            isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
            0),
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
                  'Support',
                  style: GoogleFonts.roboto(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: ConstantColors.black),
                ),
              ],
            ),
            SizedBox(
              height: 0.1 * screenHeight,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 0,
                  top: isTablet ? 20 : 0,
                  bottom: isTablet ? 20 : 0),
              decoration: BoxDecoration(
                color: ConstantColors.inputColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                autocorrect: false,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.expand_more,
                    size: screenWidth * 0.05,
                    color: ConstantColors.mainlyTextColor,
                  ),
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.roboto(
                    fontSize: screenWidth * 0.04,
                  ),
                  hintText: 'Subject',
                ),
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 0,
                  top: isTablet ? 20 : 0,
                  bottom: isTablet ? 20 : 0),
              decoration: BoxDecoration(
                color: ConstantColors.inputColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                autocorrect: false,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.expand_more,
                      size: screenWidth * 0.05,
                      color: ConstantColors.mainlyTextColor,
                    ),
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.roboto(
                      fontSize: screenWidth * 0.04,
                    ),
                    hintText: 'Product'),
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 0,
                  top: isTablet ? 20 : 0,
                  bottom: isTablet ? 20 : 0),
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
                      fontSize: screenWidth * 0.04,
                    ),
                    hintText: 'Write your problem'),
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 0,
                  top: isTablet ? 20 : 0,
                  bottom: isTablet ? 20 : 0),
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
                      constraints: BoxConstraints(
                        maxHeight: screenHeight * 0.1,
                        maxWidth: screenWidth * 0.1,
                      ),
                      child: Image(
                        image: AssetImage(
                          ImgPath.pngUpload,
                        ),
                      ),
                    ),
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.roboto(
                      fontSize: screenWidth * 0.04,
                    ),
                    hintText: 'Upload attachment'),
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: RoundedButton(
                onPressed: () {
                  Navigator.pushNamed(context, savingRoute);
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
