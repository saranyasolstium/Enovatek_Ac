import 'package:enavatek_mobile/auth/authhelper.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    primary: ConstantColors.lightBlueColor,
                    onPrimary: ConstantColors.whiteColor,
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    primary: ConstantColors.whiteColor,
                    onPrimary: ConstantColors.lightBlueColor,
                    side: const BorderSide(
                      color: ConstantColors.borderButtonColor,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  onPressed: () {
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
