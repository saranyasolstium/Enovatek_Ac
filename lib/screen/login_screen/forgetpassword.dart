// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:enavatek_mobile/auth/authhelper.dart';
import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/device_details/power_statistics.dart';
import 'package:enavatek_mobile/screen/enginner_access/add_device_AppCtrl.dart';
import 'package:enavatek_mobile/screen/enginner_access/enginner_home.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/dynamic_font.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/decoration.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  ForgetPasswordScreenState createState() => ForgetPasswordScreenState();
}

class ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> forgetpasswordApi(String emailId) async {
    try {
      Response response = await RemoteServices.resetPasswordToken(emailId);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        SnackbarHelper.showSnackBar(
            context, "Reset password token sent to your email.");
        showResetDialog(emailId);
      } else {
        SnackbarHelper.showSnackBar(context, "User not found.");
      }
    } catch (error) {
      print(error);
    }
  }

  void showResetDialog(String email) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isTablet = screenWidth >= 600;
    TextEditingController tokenController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController mailController = TextEditingController(text: email);

    bool obscureText = false;

    void toggleVisibility() {
      setState(() {
        obscureText = !obscureText;
      });
    }

    Future<void> resetPassword() async {
      try {
        Response response = await RemoteServices.resetPassword(
            email, tokenController.text, passwordController.text);
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 200) {
          SnackbarHelper.showSnackBar(
              context, "Successfully reset the password.");
          Navigator.of(context)
              .pushNamedAndRemoveUntil(loginRoute, (route) => false);
        } else {
          SnackbarHelper.showSnackBar(context, "Failed to reset the password!");
        }
      } catch (error) {
        print(error);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Reset Password",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 20.dynamic,
              color: ConstantColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 20.dynamic),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextField(
                        controller: tokenController,
                        style: GoogleFonts.roboto(
                          color: ConstantColors.mainlyTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: isTablet
                              ? screenWidth * 0.05
                              : screenWidth * 0.04,
                        ),
                        decoration: InputDecorationStyle.textFieldDecoration(
                            placeholder: "Token", context: context),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(height: 20.dynamic),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextField(
                        controller: mailController,
                        readOnly: true,
                        style: GoogleFonts.roboto(
                          color: ConstantColors.mainlyTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: isTablet
                              ? screenWidth * 0.05
                              : screenWidth * 0.04,
                        ),
                        decoration: InputDecorationStyle.textFieldDecoration(
                            placeholder: "Email", context: context),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(height: 20.dynamic),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextField(
                        controller: passwordController,
                        obscureText: obscureText,
                        style: GoogleFonts.roboto(
                          color: ConstantColors.mainlyTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: isTablet
                              ? screenWidth * 0.05
                              : screenWidth * 0.04,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.1),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenWidth * 0.05,
                          ),
                          hintText: "Password",
                          fillColor: ConstantColors.inputColor,
                          filled: true,
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: ConstantColors.mainlyTextColor,
                            ),
                            onPressed: toggleVisibility,
                          ),
                          hintStyle: GoogleFonts.roboto(
                            fontSize: isTablet
                                ? screenWidth * 0.04
                                : screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: "Cancel",
                  backgroundColor: ConstantColors.whiteColor,
                  textColor: ConstantColors.borderButtonColor,
                ),
                SizedBox(
                  width: 20.dynamic,
                ),
                RoundedButton(
                  onPressed: () {
                    if (tokenController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      SnackbarHelper.showSnackBar(context,
                          "Please fill in both token and password fields.");
                    } else {
                      resetPassword();
                    }
                    // Navigator.pushNamed(context, loginRoute);
                  },
                  text: "Reset",
                  backgroundColor: ConstantColors.borderButtonColor,
                  textColor: ConstantColors.whiteColor,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  bool isEmailValid(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isTablet = screenWidth >= 600;
    return Scaffold(
      bottomNavigationBar: Footer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Center(
              child: Text(
                'Reset Password',
                style: GoogleFonts.roboto(
                  fontSize: screenWidth * 0.06,
                  color: ConstantColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 40, right: 40, top: 20, bottom: 20),
              child: Center(
                child: Image.asset(ImgPath.pngName),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: emailController,
                style: GoogleFonts.roboto(
                  color: ConstantColors.mainlyTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: isTablet ? screenWidth * 0.05 : screenWidth * 0.04,
                ),
                decoration: InputDecorationStyle.textFieldDecoration(
                    placeholder: "Email", context: context),
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            RoundedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (emailController.text.isEmpty) {
                  SnackbarHelper.showSnackBar(
                      context, "Please enter email fields.");
                } else if (!isEmailValid(emailController.text.toString())) {
                  SnackbarHelper.showSnackBar(
                      context, "Please valid email id.");
                } else {
                  forgetpasswordApi(emailController.text.toString());
                }
              },
              text: "Reset Password",
              backgroundColor: ConstantColors.borderButtonColor,
              textColor: ConstantColors.whiteColor,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
