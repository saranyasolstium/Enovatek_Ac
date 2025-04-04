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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  User? _user;
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
      print(deviceID);
      Response response =
          await RemoteServices.login(emailId, password, deviceID!);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data.containsKey("error")) {
          String errorMessage =
              data["error_description"] ?? "Unknown error occurred.";
          SnackbarHelper.showSnackBar(context, errorMessage);
          return; // Stop further processing since it's an error
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
          AuthHelper authHelper =
              Provider.of<AuthHelper>(context, listen: false);
          authHelper.setLoggedIn(true);
          //userType == 1 Enginner
          if (userType == 1) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(enginnerHomeRounte, (route) => false);
          } else {
            // Navigator.of(context)
            //     .pushNamedAndRemoveUntil(homedRoute, (route) => false);

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
          }
          SnackbarHelper.showSnackBar(context, "Login Successful");
        }
      } else {
        var data = jsonDecode(response.body);
        print(data);
        if (data.containsKey("error_description")) {
          String errorMessage = data["error_description"];
          SnackbarHelper.showSnackBar(context, errorMessage);
        } else if (data.containsKey("message")) {
          String errorMessage = data["message"];
          SnackbarHelper.showSnackBar(context, errorMessage);
        } else {
          SnackbarHelper.showSnackBar(
              context, "Login failed! Please try again.");
        }
      }
    } catch (error) {
      print(error);
    }
  }

  // Future<void> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount =
  //         await _googleSignIn.signIn();
  //     final GoogleSignInAuthentication googleSignInAuthentication =
  //         await googleSignInAccount!.authentication;

  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication.accessToken,
  //       idToken: googleSignInAuthentication.idToken,
  //     );

  //     final UserCredential authResult =
  //         await _auth.signInWithCredential(credential);
  //     _user = authResult.user;

  //     assert(!_user!.isAnonymous);
  //     assert(await _user!.getIdToken() != null);

  //     final User currentUser = _auth.currentUser!;

  //     assert(_user!.uid == currentUser.uid);

  //     print("User Name: ${_user!.displayName}");
  //     print("User Email: ${_user!.email}");

  //     print('Google Sign-In Successful');
  //     String? displayname = _user!.displayName;
  //     String? email = _user!.email;
  //     deviceID = await SharedPreferencesHelper.instance.getDeviceId();
  //     Response response =
  //         await RemoteServices.googleApiLogin(displayname!, email!, deviceID!);
  //     if (response.statusCode == 200) {
  //       AuthHelper authHelper = Provider.of<AuthHelper>(context, listen: false);
  //       signOutGoogle();
  //       var data = jsonDecode(response.body);
  //       String accessToken = data['accessToken'];
  //       int loginId = data['loginId'];
  //       Map<String, dynamic> profile = data['profile'];
  //       int userId = profile['userId'];
  //       await SharedPreferencesHelper.instance.setUserID(userId);
  //       await SharedPreferencesHelper.instance.setAuthToken(accessToken);
  //       await SharedPreferencesHelper.instance.setLoginID(loginId);
  //       await SharedPreferencesHelper.instance
  //           .saveUserDataToSharedPreferences(displayname, email);
  //       Navigator.of(context)
  //           .pushNamedAndRemoveUntil(homedRoute, (route) => false);
  //       authHelper.setLoggedIn(true);
  //       SnackbarHelper.showSnackBar(context, "Login Successful");
  //     } else {
  //       SnackbarHelper.showSnackBar(
  //           context, "Login  failed! Please try again!");
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // Future<void> signInWithFacebook() async {
  //   final LoginResult loginResult = await FacebookAuth.instance.login(
  //     permissions: ['email'], // Request the 'email' permission.
  //   );

  //   if (loginResult.status == LoginStatus.success) {
  //     final userData = await FacebookAuth.instance.getUserData();
  //     if (userData.containsKey('email') && userData['email'] != null) {
  //       final userEmail = userData['email'];
  //       print("User Email: $userEmail");
  //     } else {
  //       print("Email not found in user data or is null.");
  //     }

  //     print("User Name: ${userData['name']}");
  //     print("User Email: ${userData['email']}");
  //     String displayname = userData['name'];
  //     String email = userData['email'] ?? "";

  //     deviceID = await SharedPreferencesHelper.instance.getDeviceId();
  //     Response response =
  //         await RemoteServices.fbApiLogin(displayname, email, deviceID!);
  //     signOutWithFacebook();

  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       String accessToken = data['accessToken'];
  //       int loginId = data['loginId'];
  //       Map<String, dynamic> profile = data['profile'];
  //       int userId = profile['userId'];
  //       await SharedPreferencesHelper.instance.setUserID(userId);
  //       await SharedPreferencesHelper.instance.setAuthToken(accessToken);
  //       await SharedPreferencesHelper.instance.setLoginID(loginId);
  //       await SharedPreferencesHelper.instance
  //           .saveUserDataToSharedPreferences(displayname, email);
  //       Navigator.of(context)
  //           .pushNamedAndRemoveUntil(homedRoute, (route) => false);
  //       AuthHelper authHelper = Provider.of<AuthHelper>(context, listen: false);
  //       authHelper.setLoggedIn(true);
  //       SnackbarHelper.showSnackBar(context, "Login Successful");
  //     } else {
  //       SnackbarHelper.showSnackBar(
  //           context, "Login  failed! Please try again!");
  //     }
  //   } else {
  //     // Handle login failure.
  //     print("Facebook login failed: ${loginResult.status}");
  //   }
  // }

  // Future<void> signOutWithFacebook() async {
  //   await FacebookAuth.instance.logOut();
  //   print("User Signed Out");
  // }

  // Future<void> signOutGoogle() async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //     await _googleSignIn.signOut();
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  bool isEmailValid(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  void _launchURL(String webURL) async {
    print(webURL);
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
      bottomNavigationBar: Footer(),
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
                  fontSize: screenWidth * 0.04,
                  color: ConstantColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: isTablet ? 100 : 40,
                  right: isTablet ? 100 : 40,
                  top: 20,
                  bottom: 20),
              child: Center(
                child: Image.asset(ImgPath.pngName),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
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
              padding: const EdgeInsets.all(20),
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
                        isTablet ? screenWidth * 0.05 : screenWidth * 0.05,
                    vertical:
                        isTablet ? screenWidth * 0.035 : screenWidth * 0.05,
                  ),
                  hintText: "Password",
                  fillColor: ConstantColors.inputColor,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      size: isTablet ? 50 : 25,
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: ConstantColors.mainlyTextColor,
                    ),
                    onPressed: toggleVisibility,
                  ),
                  hintStyle: GoogleFonts.roboto(
                    fontSize:
                        isTablet ? screenWidth * 0.035 : screenWidth * 0.04,
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
                        fontSize: screenWidth * 0.035),
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
                Navigator.pushNamed(context, profileRoute);
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
                                  ? screenWidth * 0.03
                                  : screenWidth * 0.037),
                        ),
                        TextSpan(
                            text: 'Sign Up',
                            style: GoogleFonts.lato(
                                color: ConstantColors.blueColor,
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet
                                    ? screenWidth * 0.03
                                    : screenWidth * 0.037)),
                      ],
                    ),
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                'OR',
                style: GoogleFonts.roboto(
                  fontSize: isTablet ? screenWidth * 0.03 : screenWidth * 0.04,
                  color: ConstantColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.all(20.0),
            //   width: double.infinity,
            //   child: ElevatedButton.icon(
            //     onPressed: () {
            //       // signInWithGoogle();
            //       // Navigator.of(context).pushNamedAndRemoveUntil(
            //       //     enginnerHomeRounte, (route) => false);
            //     },
            //     icon: const Icon(
            //       FontAwesomeIcons.google,
            //       color: Colors.white,
            //     ),
            //     label: const Text(
            //       'Google',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //     style: ElevatedButton.styleFrom(
            //       padding: const EdgeInsets.all(20),
            //       backgroundColor: googleColor,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //   ),
            // ),
            // Container(
            //   padding: const EdgeInsets.all(20.0),
            //   width: double.infinity,
            //   child: ElevatedButton.icon(
            //     onPressed: () {
            //       // signInWithFacebook();
            //     },
            //     icon: const Icon(
            //       FontAwesomeIcons.facebook,
            //       color: Colors.white,
            //     ),
            //     label: const Text(
            //       'Facebook',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //     style: ElevatedButton.styleFrom(
            //       padding: const EdgeInsets.all(20),
            //       backgroundColor: facebookColor,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //   ),
            // ),

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
                                ? screenWidth * 0.03
                                : screenWidth * 0.037),
                      ),
                      TextSpan(
                        text: 'Terms and Condition',
                        style: GoogleFonts.lato(
                            color: ConstantColors.blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet
                                ? screenWidth * 0.03
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
          ],
        ),
      ),
    );
  }
}
