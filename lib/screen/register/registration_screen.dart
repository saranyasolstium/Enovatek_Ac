import 'dart:convert';

import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/decoration.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController countryController = TextEditingController(text: '+65');
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  late String imageUrl = "";

  @override
  void initState() {
    countryController.text = "+65";
    super.initState();
  }

  String? userName;
  String? userEmail;

// Function to validate an email address
  bool isValidEmail(String email) {
    String emailPattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: ConstantColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            ImgPath.pngArrowBack,
            height: isTablet ? 40 : screenWidth * 0.05,
            width: isTablet ? 40 : screenWidth * 0.05,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Registration',
          style: GoogleFonts.roboto(
            fontSize: isTablet ? screenWidth * 0.025 : screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: ConstantColors.black,
          ),
        ),
      ),
      bottomNavigationBar: const Footer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            SizedBox(
              height: isTablet ? 0 : screenHeight * 0.03,
            ),
            Center(
              child: Text(
                'Register to',
                style: GoogleFonts.roboto(
                  fontSize: screenWidth * 0.03,
                  color: ConstantColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: isTablet ? 350 : 40,
                  right: isTablet ? 350 : 40,
                  top: 20,
                  bottom: 20),
              child: Center(
                child: Image.asset(ImgPath.pngName),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Padding(
              padding: isTablet
                  ? const EdgeInsets.symmetric(horizontal: 200, vertical: 0)
                  : const EdgeInsets.all(20),
              child: TextField(
                controller: nameController,
                style: GoogleFonts.roboto(
                  color: ConstantColors.mainlyTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: isTablet ? screenWidth * 0.03 : screenWidth * 0.04,
                ),
                decoration: InputDecorationStyle.textFieldDecoration(
                    placeholder: "Your Name", context: context),
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(
              height: isTablet ? 30 : 20,
            ),
            Padding(
              padding: isTablet
                  ? const EdgeInsets.symmetric(horizontal: 200, vertical: 0)
                  : const EdgeInsets.all(20),
              child: TextField(
                controller: emailController,
                style: GoogleFonts.roboto(
                  color: ConstantColors.mainlyTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: isTablet ? screenWidth * 0.03 : screenWidth * 0.04,
                ),
                decoration: InputDecorationStyle.textFieldDecoration(
                    placeholder: "Email Id", context: context),
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(
              height: isTablet ? 30 : 20,
            ),
            Padding(
              padding: isTablet
                  ? const EdgeInsets.symmetric(horizontal: 200, vertical: 0)
                  : const EdgeInsets.all(20),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                style: GoogleFonts.roboto(
                  color: ConstantColors.mainlyTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: isTablet ? screenWidth * 0.03 : screenWidth * 0.04,
                ),
                decoration: InputDecorationStyle.textFieldDecoration(
                    placeholder: "password", context: context),
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(
              height: isTablet ? 30 : 20,
            ),
            Padding(
              padding: isTablet
                  ? const EdgeInsets.symmetric(horizontal: 200, vertical: 0)
                  : const EdgeInsets.all(20),
              child: TextField(
                controller: confirmPasswordController,
                obscureText: true,
                style: GoogleFonts.roboto(
                  color: ConstantColors.mainlyTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: isTablet ? screenWidth * 0.03 : screenWidth * 0.04,
                ),
                decoration: InputDecorationStyle.textFieldDecoration(
                    placeholder: "confirm password", context: context),
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(
              height: isTablet ? 30 : 20,
            ),
            Padding(
              padding: isTablet
                  ? const EdgeInsets.symmetric(horizontal: 200, vertical: 0)
                  : const EdgeInsets.all(20),
              child: Container(
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
                        enabled: false,
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.roboto(
                          color: ConstantColors.mainlyTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: isTablet
                              ? screenWidth * 0.03
                              : screenWidth * 0.04,
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
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(8),
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone",
                        hintStyle: GoogleFonts.roboto(
                          fontSize: isTablet
                              ? screenWidth * 0.025
                              : screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isTablet
                              ? screenWidth * 0.03
                              : screenWidth * 0.05,
                          vertical: isTablet
                              ? screenWidth * 0.015
                              : screenWidth * 0.05,
                        ),
                      ),
                      style: GoogleFonts.roboto(
                        color: ConstantColors.mainlyTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize:
                            isTablet ? screenWidth * 0.03 : screenWidth * 0.04,
                      ),
                    ))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: isTablet ? 50 : 30,
            ),
            RoundedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();

                // Step 1: Check Validation
                String name = nameController.text;
                String email = emailController.text;
                String mobile =
                    "${countryController.text} ${mobileController.text}";
                String password = passwordController.text;
                String confirmpassword = confirmPasswordController.text;

                if (name.isEmpty) {
                  SnackbarHelper.showSnackBar(
                      context, "Please enter your name");
                  return;
                }

                if (email.isEmpty || !isValidEmail(email)) {
                  SnackbarHelper.showSnackBar(
                      context, "Please enter a valid email");
                  return;
                }
                if (password.isEmpty) {
                  SnackbarHelper.showSnackBar(context, "Please enter password");
                  return;
                }

                if (confirmpassword.isEmpty) {
                  SnackbarHelper.showSnackBar(
                      context, "Please enter confirm password");
                  return;
                }
                if (password != confirmpassword) {
                  SnackbarHelper.showSnackBar(
                      context, "Passwords do not match");
                  return;
                }

                if (mobileController.text.isEmpty ||
                    mobileController.text.length != 8) {
                  // Show an error message for mobile validation
                  SnackbarHelper.showSnackBar(
                      context, "Please enter a valid mobile number");
                  return;
                }
                try {
                  Response response = await RemoteServices.userSignUp(
                      name, email, mobile, password);
                  if (response.statusCode == 200) {
                    var data = jsonDecode(response.body);
                    if (data.containsKey("message")) {
                      SnackbarHelper.showSnackBar(
                          context, "Successfully registered the account.");
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    }
                    //  else {
                    //   await SharedPreferencesHelper.instance
                    //       .saveUserDataToSharedPreferences(name, email);
                    //   Navigator.of(context).pushNamedAndRemoveUntil(
                    //       homedRoute, (route) => false);
                    // }
                  } else {
                    var data = jsonDecode(response.body);
                    if (data.containsKey("message")) {
                      String errorMessage = data["message"];
                      SnackbarHelper.showSnackBar(context, errorMessage);
                    }
                  }
                } catch (e) {
                  print(e.toString());
                }
              },
              text: "Register",
              backgroundColor: ConstantColors.borderButtonColor,
              textColor: ConstantColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
