import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/dialog_logout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnginnerMenuScreen extends StatefulWidget {
  const EnginnerMenuScreen({Key? key}) : super(key: key);

  @override
  EnginnerMenuScreenState createState() => EnginnerMenuScreenState();
}

class EnginnerMenuScreenState extends State<EnginnerMenuScreen> {
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    getUserDataFromSharedPreferences();
  }

  Future<void> getUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName');
      userEmail = prefs.getString('userEmail');
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth >= 600;
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
          isTablet ? 0.05 * screenHeight : 0.05 * screenHeight,
          isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
          isTablet ? 0.02 * screenHeight : 0.05 * screenHeight,
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
                  'Menu',
                  style: GoogleFonts.roboto(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: ConstantColors.black),
                ),
              ],
            ),
            SizedBox(
              height: 0.05 * screenHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: ConstantColors.inputColor,
                          borderRadius:
                              BorderRadius.circular(screenHeight * 0.05)),
                      width: screenWidth * 0.2,
                      height: screenHeight * 0.1,
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Image.asset(
                          ImgPath.pngPerson,
                          height: screenWidth * 0.08,
                          width: screenWidth * 0.08,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$userName\n\n',
                          style: GoogleFonts.roboto(
                            color: ConstantColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.042,
                          ),
                        ),
                        TextSpan(
                          text: userEmail,
                          style: GoogleFonts.roboto(
                            color: ConstantColors.mainlyTextColor,
                            fontSize: screenWidth * 0.042,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: ConstantColors.mainlyTextColor,
                  size: screenWidth * 0.07,
                ),
              ],
            ),
            SizedBox(
              height: 0.05 * screenHeight,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              margin: EdgeInsets.all(
                screenWidth * 0.02,
              ),
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.05,
                screenHeight * 0.05,
                screenWidth * 0.05,
                screenHeight * 0.05,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showLogoutDialog(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          ImgPath.pngLogout,
                          height: screenWidth * 0.06,
                          width: screenWidth * 0.06,
                        ),
                        SizedBox(
                          width: 0.02 * screenHeight,
                        ),
                        Text(
                          'Log out',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.black,
                              fontSize: screenWidth * 0.045),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
