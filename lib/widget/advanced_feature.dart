import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:getwidget/types/gf_toggle_type.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowAdvancedDialog extends StatelessWidget {
  const ShowAdvancedDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isCelsiusSelected = true;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Advanced Feature',
                  style: GoogleFonts.roboto(
                      fontSize: screenWidth * 0.04,
                      color: ConstantColors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    color: ConstantColors.black,
                    size: 25,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            const Divider(
              height: 20,
              thickness: 1,
              color: ConstantColors.black,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      ImgPath.pngThermometer,
                      height: 15,
                      width: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '°C/°F',
                      style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.035,
                          color: ConstantColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    MaterialButton(
                      onPressed: () async {
                        isCelsiusSelected = true;
                      },
                      color: isCelsiusSelected
                          ? ConstantColors.borderButtonColor
                          : ConstantColors.modeDefault,
                      textColor: Colors.white,
                      minWidth: 30,
                      height: 30,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: isCelsiusSelected
                              ? ConstantColors.borderButtonColor
                              : ConstantColors.modeDefault,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '°C',
                        style: GoogleFonts.roboto(
                            fontSize: screenWidth * 0.035,
                            color: ConstantColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        isCelsiusSelected = false;
                      },
                       color: isCelsiusSelected
                          ? ConstantColors.modeDefault 
                          : ConstantColors.borderButtonColor, 
                      textColor: Colors.white,
                      minWidth: 30,
                      height: 30,
                      shape:  CircleBorder(
                        side: BorderSide(
                           color: isCelsiusSelected
                          ? ConstantColors.modeDefault
                          : ConstantColors.borderButtonColor, 
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '°F',
                        style: GoogleFonts.roboto(
                            fontSize: screenWidth * 0.035,
                            color: ConstantColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      ImgPath.pngStrongWind,
                      height: 15,
                      width: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Strong Wind',
                      style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.035,
                          color: ConstantColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                GFToggle(
                  onChanged: (val) {},
                  value: false,
                  enabledThumbColor: ConstantColors.whiteColor,
                  enabledTrackColor: ConstantColors.lightBlueColor,
                  type: GFToggleType.ios,
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      ImgPath.pngBuildIcon,
                      height: 15,
                      width: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Overhaul',
                      style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.035,
                          color: ConstantColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                GFToggle(
                  onChanged: (val) {},
                  value: false,
                  enabledThumbColor: ConstantColors.whiteColor,
                  enabledTrackColor: ConstantColors.lightBlueColor,
                  type: GFToggleType.ios,
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      ImgPath.pngAround,
                      height: 15,
                      width: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Around',
                      style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.035,
                          color: ConstantColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                GFToggle(
                  onChanged: (val) {},
                  value: false,
                  enabledThumbColor: ConstantColors.whiteColor,
                  enabledTrackColor: ConstantColors.lightBlueColor,
                  type: GFToggleType.ios,
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      ImgPath.pngUpDown,
                      height: 15,
                      width: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Up and down',
                      style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.035,
                          color: ConstantColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                GFToggle(
                  onChanged: (val) {},
                  value: false,
                  enabledThumbColor: ConstantColors.whiteColor,
                  enabledTrackColor: ConstantColors.lightBlueColor,
                  type: GFToggleType.ios,
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      ImgPath.pngEco,
                      height: 15,
                      width: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Eco',
                      style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.035,
                          color: ConstantColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                GFToggle(
                  onChanged: (val) {},
                  value: false,
                  enabledThumbColor: ConstantColors.whiteColor,
                  enabledTrackColor: ConstantColors.lightBlueColor,
                  type: GFToggleType.ios,
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      ImgPath.pngSleep,
                      height: 15,
                      width: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Sleep',
                      style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.035,
                          color: ConstantColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                GFToggle(
                  onChanged: (val) {},
                  value: false,
                  enabledThumbColor: ConstantColors.whiteColor,
                  enabledTrackColor: ConstantColors.lightBlueColor,
                  type: GFToggleType.ios,
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      ImgPath.pngDisplay,
                      height: 15,
                      width: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Display',
                      style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.035,
                          color: ConstantColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                GFToggle(
                  onChanged: (val) {},
                  value: false,
                  enabledThumbColor: ConstantColors.whiteColor,
                  enabledTrackColor: ConstantColors.lightBlueColor,
                  type: GFToggleType.ios,
                )
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
