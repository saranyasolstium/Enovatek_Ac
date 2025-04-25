import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/dynamic_font.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Function onPressed;

  const RoundedButton(
      {super.key,
      required this.text,
      required this.backgroundColor,
      required this.textColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    return Padding(
      padding: const EdgeInsets.all(0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenHeight * 0.1),
          ),
          side: const BorderSide(
            color: ConstantColors.borderButtonColor,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        onPressed: () => onPressed(),
        // {
        //   Navigator.pushNamed(context, naviagtionRoute);
        // },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 30.dynamic : 15.dynamic,
            vertical: isTablet ? 10 : 15.dynamic,
          ),
          child: Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: isTablet ? screenWidth * 0.02 : screenWidth * 0.04,
            ),
          ),
        ),
      ),
    );
  }
}
