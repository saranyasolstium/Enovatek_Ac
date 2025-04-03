import 'dart:convert';

import 'package:enavatek_mobile/auth/authhelper.dart';
import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final double screenWidth = MediaQuery.of(context).size.width;
      return AlertDialog(
        backgroundColor: ConstantColors.whiteColor,
        content: Text(
          'Are you sure to log out?',
          style: GoogleFonts.roboto(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: ConstantColors.mainlyTextColor),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ConstantColors.whiteColor,
                    backgroundColor: ConstantColors.lightBlueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    side: const BorderSide(
                      color: ConstantColors.borderButtonColor,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.roboto(fontSize: screenWidth * 0.035),
                  ),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ConstantColors.lightBlueColor,
                    backgroundColor: ConstantColors.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    side: const BorderSide(
                      color: ConstantColors.borderButtonColor,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  onPressed: () async {
                    AuthHelper authHelper =
                        Provider.of<AuthHelper>(context, listen: false);
                    authHelper.setLoggedIn(false);

                    Navigator.pushNamedAndRemoveUntil(
                        context, loginRoute, (route) => false);
                  },
                  child: Text(
                    "Log out",
                    style: GoogleFonts.roboto(fontSize: screenWidth * 0.035),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

void showDeleteDialog(BuildContext context) {
  Future<void> deleteAccount() async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? userId = await SharedPreferencesHelper.instance.getUserID();

    print(authToken);
    var response = await RemoteServices.deleteAccount(
      authToken!,
      userId!,
    );
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data.containsKey("message")) {
        String message = data["message"];
        SnackbarHelper.showSnackBar(context, message);
        AuthHelper authHelper = Provider.of<AuthHelper>(context, listen: false);
        authHelper.setLoggedIn(false);

        Navigator.pushNamedAndRemoveUntil(
          context,
          loginRoute,
          (route) => false,
        );
      }
    } else {
      SnackbarHelper.showSnackBar(context, "Failed to delete account");
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      final double screenWidth = MediaQuery.of(context).size.width;

      return AlertDialog(
        backgroundColor: ConstantColors.whiteColor,
        content: SizedBox(
          width: screenWidth * 0.9,
          child: Text(
            'Are you sure to Delete Account?',
            style: GoogleFonts.roboto(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: ConstantColors.mainlyTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 20),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: ConstantColors.whiteColor,
                  backgroundColor: ConstantColors.lightBlueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  side: const BorderSide(
                    color: ConstantColors.borderButtonColor,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.roboto(fontSize: screenWidth * 0.035),
                ),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: ConstantColors.lightBlueColor,
                  backgroundColor: ConstantColors.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  side: const BorderSide(
                    color: ConstantColors.borderButtonColor,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                ),
                onPressed: () async {
                  // deleteAccount();
                  SnackbarHelper.showSnackBar(
                      context, "Account deleted sucessfully");
                  AuthHelper authHelper =
                      Provider.of<AuthHelper>(context, listen: false);
                  authHelper.setLoggedIn(false);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    loginRoute,
                    (route) => false,
                  );
                },
                child: Text(
                  "Delete",
                  style: GoogleFonts.roboto(fontSize: screenWidth * 0.035),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
