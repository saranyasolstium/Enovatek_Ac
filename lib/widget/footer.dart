import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Container(
      color: Colors.grey,
      height: isTablet ? 50 : 30,
      child: Align(
          alignment: Alignment.center,
          child: Text(
            'App Version: 5.0',
            style: GoogleFonts.roboto(
              fontSize: isTablet ? 22 : 12.0,
              color: Colors.white,
            ),
          )),
    );
  }
}
