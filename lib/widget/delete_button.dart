import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';

class MaterialDeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MaterialDeleteButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth >= 600;
    return MaterialButton(
      onPressed: onPressed,
      color: ConstantColors.orangeColor,
      textColor: Colors.white,
      minWidth: isTablet ? 0.04 * screenWidth : 0.03 * screenWidth,
      height: isTablet ? 0.04 * screenHeight : 0.03 * screenHeight,
      shape: const CircleBorder(
        side: BorderSide(
          color: ConstantColors.orangeColor,
          width: 2,
        ),
      ),
      child: Image.asset(
        ImgPath.pngDelete,
        width: isTablet ? 0.03 * screenWidth : 0.025 * screenWidth,
        height: isTablet ? 0.03 * screenHeight : 0.025 * screenHeight,
      ),
    );
  }
}
