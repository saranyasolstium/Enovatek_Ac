// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      _user = authResult.user;

      assert(!_user!.isAnonymous);
      assert(await _user!.getIdToken() != null);

      final User currentUser = _auth.currentUser!;

      assert(_user!.uid == currentUser.uid);

      print("User Name: ${_user!.displayName}");
      print("User Email: ${_user!.email}");
      print('Google Sign-In Successful');
      String? displayname = _user!.displayName;
      String? email = _user!.email;
      await SharedPreferencesHelper.instance
               .saveUserDataToSharedPreferences(displayname!, email!);
      Navigator.pushNamed(context, profileRoute);

      
    } catch (error) {
      print(error);
    }
  }

  Future<void> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login(
      permissions: ['email'], // Request the 'email' permission.
    );

    if (loginResult.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();

      // Check if the 'email' key exists in the user data.
      if (userData.containsKey('email')) {
        final userEmail = userData['email'];
        print("User Email: $userEmail");
      } else {
        print("Email not found in user data.");
      }

      // You can also access other user information if needed.
      print("User ID: ${userData['id']}");
      print("User Name: ${userData['name']}");
              print("User Email: ${userData['email']}");
              String displayname = userData['name'];
              String email=userData['email'] ?? "";
await SharedPreferencesHelper.instance
               .saveUserDataToSharedPreferences(displayname, email);
      Navigator.pushNamed(context, profileRoute);

    } else {
      // Handle login failure.
      print("Facebook login failed: ${loginResult.status}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isTablet = screenWidth >= 600;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.1,
            ),
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
                  height: isTablet ? screenHeight * 0.45 : screenHeight * 0.5,
                ),
                Positioned.fill(
                  top: -screenWidth * 0.3,
                  child: Center(
                      child: Text(
                    'Welcome to',
                    style: GoogleFonts.roboto(
                        fontSize: screenWidth * 0.04,
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
            SizedBox(
              height: isTablet ? screenHeight * 0.03 : screenHeight * 0.03,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.1, right: screenWidth * 0.1),
              height: isTablet ? screenHeight * 0.09 : screenHeight * 0.07,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.1),
                  ),
                ),
                onPressed: () async {
                  // User? user = await _signInWithGoogle();
                  // if (user != null) {
                  //   print('Google Sign-In Successful');
                  //   Navigator.pushNamed(context, profileRoute);
                  // }
                  signInWithGoogle();
                },
                child: Text(
                  "Continue with google",
                  style: GoogleFonts.roboto(
                    fontSize:
                        isTablet ? screenWidth * 0.04 : screenWidth * 0.045,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: isTablet ? screenHeight * 0.02 : screenHeight * 0.02,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.1, right: screenWidth * 0.1),
              height: isTablet ? screenHeight * 0.09 : screenHeight * 0.07,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.1),
                  ),
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, profileRoute);
                  signInWithFacebook();
                },
                child: Text(
                  "Continue with Facebook",
                  style: GoogleFonts.roboto(
                    fontSize:
                        isTablet ? screenWidth * 0.04 : screenWidth * 0.045,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
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
                            color: ConstantColors.mainlyTextColor,
                            fontSize: screenWidth * 0.037),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: GoogleFonts.lato(
                            color: ConstantColors.blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.035),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: GoogleFonts.lato(
                            color: ConstantColors.mainlyTextColor,
                            fontSize: screenWidth * 0.037),
                      ),
                      TextSpan(
                        text: 'Terms and Condition',
                        style: GoogleFonts.lato(
                            color: ConstantColors.blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.035),
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
