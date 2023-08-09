import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../value/constant_colors.dart';

class InputDecorationStyle {
  

static InputDecoration textFieldDecoration({required String placeholder}) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(
        width: 0,
        style: BorderStyle.none,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    hintText: placeholder,
    fillColor: ConstantColors.inputColor,
    filled: true,
    hintStyle: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  );
}
}
