// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/decoration.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  TextEditingController countryController = TextEditingController(text: '+65');
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  late String imageUrl = "";

  @override
  void initState() {
    countryController.text = "+65";
    super.initState();
    getUserDataFromSharedPreferences();
  }

  
  String? userName;
  String? userEmail;
  

// Function to validate an email address
  bool isValidEmail(String email) {
    String emailPattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  Future<void> getUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName');
    userEmail = prefs.getString('userEmail');
    nameController.text = userName ?? "";
    emailController.text = userEmail ?? "";
  }

  late File? pickedImage = null;

  late PickedFile? image;
  Future<void> getImage({required ImageSource source}) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
    }
  }

  Future<void> dialogBoxImagePicker(context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text("Pick Form Camera"),
                    onTap: () {
                      getImage(source: ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text("Pick Form Gallery"),
                    onTap: () {
                      getImage(source: ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
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
                pickedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.file(
                          pickedImage!,
                          fit: BoxFit.cover,
                          width: screenHeight * 0.15,
                          height: screenHeight * 0.15,
                        ),
                      )
                    : Positioned.fill(
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
                        GestureDetector(
                          onTap: () {
                            dialogBoxImagePicker(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: ConstantColors.lightBlueColor,
                                borderRadius: BorderRadius.circular(50)),
                            // width: isTablet ? 50 : 30,
                            // height: isTablet ? 60 : 100,
                          ),
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
              controller: nameController,
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
              controller: emailController,
              style: GoogleFonts.roboto(
                color: ConstantColors.mainlyTextColor,
                fontWeight: FontWeight.w500,
                fontSize: isTablet ? screenWidth * 0.05 : screenWidth * 0.04,
              ),
              decoration: InputDecorationStyle.textFieldDecoration(
                  placeholder: "Loremipsum@gmail.com", context: context),
              //enabled: false,
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
                    controller: mobileController,
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
            RoundedButton(
              onPressed: () async {
                // Step 1: Check Validation
                String name = nameController.text;
                String email = emailController.text;
                String mobile =
                    "${countryController.text} ${mobileController.text}";

                if (name.isEmpty) {
                  // Show an error message for name validation
                  SnackbarHelper.showSnackBar(
                      context, "Please enter your name");
                  return;
                }

                if (email.isEmpty || !isValidEmail(email)) {
                  // Show an error message for email validation
                  SnackbarHelper.showSnackBar(
                      context, "Please enter a valid email");
                  return;
                }

                if (mobileController.text.isEmpty) {
                  // Show an error message for mobile validation
                  SnackbarHelper.showSnackBar(
                      context, "Please enter a valid mobile number");
                  return;
                }
                try {
                  Response response =
                      await RemoteServices.login(email, name, mobile);
                  print(response.statusCode);
                  if (response.statusCode == 201 ||
                      response.statusCode == 400) {
                    await SharedPreferencesHelper.instance
                        .saveUserDataToSharedPreferences(name, email);
                    var data = jsonDecode(response.body);
                Navigator.pushNamed(context, homedRoute);

                    print(data);
                  } else {
                    SnackbarHelper.showSnackBar(
                        context, "Create profile failed! Please try again!");
                  }
                } catch (e) {
                  print(e.toString());
                }
              },
              text: "Next",
              backgroundColor: ConstantColors.borderButtonColor,
              textColor: ConstantColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
