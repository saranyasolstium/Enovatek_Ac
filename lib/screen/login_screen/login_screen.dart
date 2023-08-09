import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 150),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImgPath.pngLoginBg),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                ),
                Positioned.fill(
                  top: -100,
                  child: Center(
                      child: Text(
                    'Welcome',
                    style: GoogleFonts.roboto(
                        fontSize: 20.0,
                        color: ConstantColors.black,
                        fontWeight: FontWeight.w700),
                  )),
                ),
                Positioned.fill(
                  left: 50,
                  right: 50,
                  child: Center(
                    child: Image.asset(
                      ImgPath.pngName,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.only(left: 50, right: 50),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  //Navigator.pushNamed(context, loginRoute);
                },
                child: Text(
                  "Continue with google",
                  style: GoogleFonts.roboto(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 50, right: 50),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, profileRoute);
                },
                child: Text(
                  "Continue with Facebook",
                  style: GoogleFonts.roboto(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
           
            Padding(
                padding: const EdgeInsets.only(left: 30, right: 60),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'By selecting option you are agreeing to our ',
                        style: GoogleFonts.lato(
                            color: ConstantColors.mainlyTextColor, fontSize: 14),
                      ),
                     
                      TextSpan(
                        text: 'Privacy Policy',
                        style: GoogleFonts.lato(
                            color: ConstantColors.blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: GoogleFonts.lato(
                            color: ConstantColors.mainlyTextColor, fontSize: 14),
                      ),
                      TextSpan(
                        text: 'Terms and Condition',
                        style: GoogleFonts.lato(
                            color: ConstantColors.blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
