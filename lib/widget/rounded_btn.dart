import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final String naviagtionRoute;

  const RoundedButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.naviagtionRoute,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
        final isTablet = screenWidth >= 600;


    return Padding(
      padding: const EdgeInsets.all(0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenHeight * 0.1),
          ),
          primary: backgroundColor,
          onPrimary: textColor,
          side: const BorderSide(
            color: ConstantColors.borderButtonColor,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, naviagtionRoute);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ?screenWidth * 0.05  : screenWidth * 0.02,
            vertical: isTablet ?screenHeight * 0.02 : screenHeight * 0.015,
          ),
          child: Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: screenWidth * 0.04,
            ),
          ),
        ),
      ),
    );
  }
}
