import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: 30,
      child: Align(
          alignment: Alignment.center,
          child: Text(
            'App Version:5.0',
            style: GoogleFonts.roboto(
              fontSize: 12.0,
              color: Colors.white,
            ),
          )),
    );
  }
}
