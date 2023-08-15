import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: ConstantColors.whiteColor,
        content: Text(
          'Are you sure to log out?',
          style: GoogleFonts.roboto(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: ConstantColors.mainlyTextColor
          ),
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
                    style: GoogleFonts.roboto(
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 30,),
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
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Log out",
                    style: GoogleFonts.roboto(
                      fontSize: 12.0,
                    ),
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
