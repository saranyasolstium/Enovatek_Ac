// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:enavatek_mobile/auth/authhelper.dart';
import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/device_details/power_statistics.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/decoration.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? deviceID;
  bool obscureText = true;
  @override
  void initState() {
    super.initState();
  }

  void toggleVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Future<void> loginToken(String emailId, String password) async {
    try {
      deviceID = await SharedPreferencesHelper.instance.getDeviceId();
      Response response =
          await RemoteServices.login(emailId, password, deviceID!);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data.containsKey("error")) {
          String errorMessage =
              data["error_description"] ?? "Unknown error occurred.";
          SnackbarHelper.showSnackBar(context, errorMessage);
          await RemoteServices.createUserActivity(
            userId: 0, // unknown on failure
            userTypeId: 0,
            remarks:
                'Login failed for $emailId (device: $deviceID): $errorMessage',
            module: 'Auth',
            action: 'Failed',
          );
          return;
        } else {
          String accessToken = data['accessToken'];
          int loginId = data['loginId'];
          Map<String, dynamic> profile = data['profile'];
          String profileName = profile['name'];
          String profileEmailId = profile['emailId'];
          int userId = profile['userId'];
          int userType = profile['userTypeId'] ?? 2;
          await SharedPreferencesHelper.instance.setAuthToken(accessToken);
          await SharedPreferencesHelper.instance.setLoginID(loginId);
          await SharedPreferencesHelper.instance.setUserID(userId);
          await SharedPreferencesHelper.instance.setUserTypeID(userType);
          await SharedPreferencesHelper.instance
              .saveUserDataToSharedPreferences(profileName, profileEmailId);
          await RemoteServices.createUserActivity(
            userId: userId,
            userTypeId: userType,
            remarks: 'Login success for $emailId (device: $deviceID)',
            module: 'Auth',
            action: 'Login',
            bearerToken: accessToken,
          );
          AuthHelper authHelper =
              Provider.of<AuthHelper>(context, listen: false);
          authHelper.setLoggedIn(true);
          //userType == 1 Enginner
          if (userType == 1 || userType == 2) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const PowerStatisticsScreen(
                  deviceId: "",
                  deviceList: [],
                  tabIndex: 1,
                ),
              ),
              (Route<dynamic> route) => false,
            );
          } else {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(enginnerHomeRounte, (route) => false);
          }
          SnackbarHelper.showSnackBar(context, "Login Successful");
        }
      } else {
        var data = jsonDecode(response.body);
        print(data);
        String? msg;

        if (data.containsKey("error_description")) {
          msg = data["error_description"];

          String errorMessage = data["error_description"];
          SnackbarHelper.showSnackBar(context, errorMessage);
        } else if (data.containsKey("message")) {
          msg = data["message"];

          String errorMessage = data["message"];
          SnackbarHelper.showSnackBar(context, errorMessage);
        } else {
          msg ??= "Login failed! Please try again.";

          SnackbarHelper.showSnackBar(
              context, "Login failed! Please try again.");
        }
        await RemoteServices.createUserActivity(
          userId: 0,
          userTypeId: 0,
          remarks:
              'Login failed for $emailId (device: $deviceID): HTTP ${response.statusCode} - $msg',
          module: 'Auth',
          action: 'Failed',
        );
      }
    } catch (error) {
      print(error);
    }
  }

  bool isEmailValid(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  void _launchURL(String webURL) async {
    String encodedURL = Uri.encodeFull(webURL);
    if (await canLaunch(encodedURL)) {
      await launch(encodedURL);
    } else {
      throw 'Could not launch $encodedURL';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isTablet = screenWidth >= 600;
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      bottomNavigationBar: const Footer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Center(
              child: Text(
                'Welcome to',
                style: GoogleFonts.roboto(
                  fontSize: screenWidth * 0.03,
                  color: ConstantColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: isTablet ? 400 : 40,
                  right: isTablet ? 400 : 40,
                  top: 20,
                  bottom: 20),
              child: Center(
                child: Image.asset(ImgPath.pngName),
              ),
            ),
            Padding(
              padding: isTablet
                  ? const EdgeInsets.symmetric(horizontal: 200, vertical: 20)
                  : const EdgeInsets.all(20),
              child: TextField(
                controller: emailController,
                style: GoogleFonts.roboto(
                  color: ConstantColors.mainlyTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: isTablet ? screenWidth * 0.03 : screenWidth * 0.04,
                ),
                decoration: InputDecorationStyle.textFieldDecoration(
                    placeholder: "Email", context: context),
                textInputAction: TextInputAction.next,
              ),
            ),
            Padding(
              padding: isTablet
                  ? const EdgeInsets.symmetric(horizontal: 200, vertical: 20)
                  : const EdgeInsets.all(20),
              child: TextField(
                controller: passwordController,
                obscureText: obscureText,
                style: GoogleFonts.roboto(
                  color: ConstantColors.mainlyTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: isTablet ? screenWidth * 0.03 : screenWidth * 0.04,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenHeight * 0.1),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal:
                        isTablet ? screenWidth * 0.03 : screenWidth * 0.05,
                    vertical:
                        isTablet ? screenWidth * 0.015 : screenWidth * 0.05,
                  ),
                  hintText: "Password",
                  fillColor: ConstantColors.inputColor,
                  filled: true,
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(
                      right: isTablet ? screenWidth * 0.02 : 0,
                    ),
                    child: IconButton(
                      icon: Icon(
                        size: isTablet ? 40 : 25,
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: ConstantColors.mainlyTextColor,
                      ),
                      onPressed: toggleVisibility,
                    ),
                  ),
                  hintStyle: GoogleFonts.roboto(
                    fontSize:
                        isTablet ? screenWidth * 0.025 : screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, forgetPasswordRoute);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'Forgot password',
                    style: GoogleFonts.lato(
                        color: ConstantColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet
                            ? screenWidth * 0.022
                            : screenWidth * 0.035),
                  ),
                ),
              ),
            ),
            RoundedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (emailController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  SnackbarHelper.showSnackBar(context,
                      "Please fill in both email and password fields.");
                } else if (!isEmailValid(emailController.text)) {
                  SnackbarHelper.showSnackBar(context,
                      "Invalid email format. Please enter a valid email.");
                } else {
                  loginToken(emailController.text, passwordController.text);
                }
              },
              text: "Login",
              backgroundColor: ConstantColors.borderButtonColor,
              textColor: ConstantColors.whiteColor,
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, registerRoute);
              },
              child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 60),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account?   ",
                          style: GoogleFonts.lato(
                              color: ConstantColors.mainlyTextColor,
                              fontSize: isTablet
                                  ? screenWidth * 0.025
                                  : screenWidth * 0.037),
                        ),
                        TextSpan(
                            text: 'Sign Up',
                            style: GoogleFonts.lato(
                                color: ConstantColors.blueColor,
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet
                                    ? screenWidth * 0.025
                                    : screenWidth * 0.037)),
                      ],
                    ),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'OR',
                style: GoogleFonts.roboto(
                  fontSize: isTablet ? screenWidth * 0.025 : screenWidth * 0.04,
                  color: ConstantColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
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
                            fontSize: isTablet
                                ? screenWidth * 0.02
                                : screenWidth * 0.037),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: GoogleFonts.lato(
                            color: ConstantColors.blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet
                                ? screenWidth * 0.02
                                : screenWidth * 0.035),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _launchURL(
                                'https://enovatekenergy.com/contact-us/');
                          },
                      ),
                      TextSpan(
                        text: ' and ',
                        style: GoogleFonts.lato(
                            color: ConstantColors.mainlyTextColor,
                            fontSize: isTablet
                                ? screenWidth * 0.02
                                : screenWidth * 0.037),
                      ),
                      TextSpan(
                        text: 'Terms and Condition',
                        style: GoogleFonts.lato(
                            color: ConstantColors.blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet
                                ? screenWidth * 0.02
                                : screenWidth * 0.037),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _launchURL(
                                'https://enovatekenergy.com/contact-us/');
                          },
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 40)
          ],
        ),
      ),
    );
  }
}
