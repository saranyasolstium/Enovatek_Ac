import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputDecorationStyle {
  static InputDecoration textFieldDecoration({
    required String placeholder,
    required BuildContext context,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(screenHeight * 0.1),
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? screenWidth * 0.03 : screenWidth * 0.05,
        vertical: isTablet ? screenWidth * 0.015 : screenWidth * 0.05,
      ),
      hintText: placeholder,
      fillColor: ConstantColors.inputColor,
      filled: true,
      hintStyle: GoogleFonts.roboto(
        fontSize: isTablet ? screenWidth * 0.025 : screenWidth * 0.04,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
