import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SlideItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const SlideItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 50, 30, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            ImgPath.pngArrowBack,
            height: 25,
            width: 25,
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Text(
              title,
              style:  GoogleFonts.roboto(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: ConstantColors.black,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
             child: Center(
            child: Text(
              description,
              style:  GoogleFonts.roboto(
                fontSize: 18.0,
                color: ConstantColors.mainlyTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          )
         
        ],
      ),
    );
  }
}
