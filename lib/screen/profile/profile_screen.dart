import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/decoration.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  TextEditingController emailEditingController =
      TextEditingController(text: 'Loremipsum@gmail.com');
  TextEditingController countryController = TextEditingController(text: '+65');

  @override
  void initState() {
    countryController.text = "+65";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: ConstantColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            ImgPath.pngArrowBack,
            height: screenWidth * 0.05,
            width: screenWidth * 0.05,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Create Profile',
          style: GoogleFonts.roboto(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: ConstantColors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: ConstantColors.inputColor,
                      borderRadius: BorderRadius.circular(200)),
                  width: screenHeight * 0.15,
                  height: screenHeight * 0.15,
                ),
                Positioned.fill(
                  child: Center(
                    child: Image.asset(
                      ImgPath.pngPerson,
                      height: screenHeight * 0.05,
                      width: screenHeight * 0.05,
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 5,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: isTablet ? 100 : 100, top: isTablet ? 200 : 110),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: ConstantColors.lightBlueColor,
                              borderRadius: BorderRadius.circular(50)),
                          // width: isTablet ? 50 : 30,
                          // height: isTablet ? 60 : 100,
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Image.asset(
                              ImgPath.pngEdit,
                              height: isTablet ? 20 : 12,
                              width: isTablet ? 20 : 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              style: GoogleFonts.roboto(
                color: ConstantColors.mainlyTextColor,
                fontWeight: FontWeight.w500,
                fontSize: isTablet ? screenWidth * 0.05 : screenWidth * 0.04,
              ),
              decoration: InputDecorationStyle.textFieldDecoration(
                  placeholder: "Your Name", context: context),
            ),
            SizedBox(
              height: isTablet ? 30 : 20,
            ),
            TextField(
              controller: emailEditingController,
              style: GoogleFonts.roboto(
                color: ConstantColors.mainlyTextColor,
                fontWeight: FontWeight.w500,
                fontSize: isTablet ? screenWidth * 0.05 : screenWidth * 0.04,
              ),
              decoration: InputDecorationStyle.textFieldDecoration(
                  placeholder: "Loremipsum@gmail.com", context: context),
            ),
            SizedBox(
              height: isTablet ? 30 : 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ConstantColors.inputColor,
                  borderRadius: BorderRadius.circular(75)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: isTablet ? 30 : 10,
                  ),
                  SizedBox(
                    width: isTablet ? 80 : 40,
                    child: TextField(
                      controller: countryController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: GoogleFonts.roboto(
                        color: ConstantColors.mainlyTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                  const Text(
                    "|",
                    style: TextStyle(fontSize: 33, color: Colors.grey),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Phone",
                      hintStyle: GoogleFonts.roboto(
                        fontSize:
                            isTablet ? screenWidth * 0.04 : screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenWidth * 0.05,
                      ),
                    ),
                    style: GoogleFonts.roboto(
                      color: ConstantColors.mainlyTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: screenWidth * 0.04,
                    ),
                  ))
                ],
              ),
            ),
            SizedBox(
              height: isTablet ? 50 : 30,
            ),
            const RoundedButton(
              text: "Next",
              backgroundColor: ConstantColors.borderButtonColor,
              textColor: ConstantColors.whiteColor,
              naviagtionRoute: homedRoute,
            ),
          ],
        ),
      ),
    );
  }
}
