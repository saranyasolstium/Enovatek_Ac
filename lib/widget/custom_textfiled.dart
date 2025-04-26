import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../value/constant_colors.dart'; // Adjust your import path

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? suffixIcon;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return Padding(
      padding: EdgeInsets.only(
        left: 0.03 * screenWidth,
        right: 0.03 * screenWidth,
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        style: GoogleFonts.roboto(
          color: ConstantColors.mainlyTextColor,
          fontSize: isTablet ? screenWidth * 0.025 : screenWidth * 0.04,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    suffixIcon,
                    size: 20,
                    color: ConstantColors.mainlyTextColor,
                  ),
                )
              : null,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ConstantColors.mainlyTextColor),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ConstantColors.mainlyTextColor),
          ),
        ),
      ),
    );
  }
}
