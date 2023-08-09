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
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
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
        child: Text(
          text,
          style: GoogleFonts.roboto(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
