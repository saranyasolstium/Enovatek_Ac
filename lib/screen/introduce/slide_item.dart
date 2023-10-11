import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SlideItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const SlideItem({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth < 600 ? screenWidth * 0.05 : screenWidth * 0.1,
        vertical: screenWidth < 600 ? screenHeight * 0.02 : screenHeight * 0.1,
      ),
      child: Column(
        children: [
          Image.asset(
            imageUrl,
            height: screenWidth < 600 ? screenHeight * 0.6 : screenHeight * 0.5,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          SizedBox(height: screenWidth < 600 ? screenHeight * 0.02 : screenHeight * 0.03 ), 
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: screenWidth < 600 ? screenWidth * 0.05 : screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.01), 
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth < 600 ? screenWidth * 0.01 : screenWidth * 0.01),
            child: Text(
              description,
              style: GoogleFonts.roboto(
                fontSize: screenWidth < 600 ? screenWidth * 0.04 : screenWidth * 0.04,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
