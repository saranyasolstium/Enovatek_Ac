import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTimerscreen extends StatefulWidget {
  const AddTimerscreen({Key? key}) : super(key: key);

  @override
  AddTimerscreenState createState() => AddTimerscreenState();
}

class AddTimerscreenState extends State<AddTimerscreen> {
  DateTime _dateTime = DateTime.now();

  Widget hourMinute15Interval() {
  return Transform.scale(
    scale: 0.8, // Adjust the scale factor to reduce text size
    child: TimePickerSpinner(
      spacing: 40,
      minutesInterval: 1,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.05,
          screenHeight * 0.05,
          screenWidth * 0.05,
          screenHeight * 0.02,
        ),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    ImgPath.pngArrowBack,
                    height: screenWidth * 0.05,
                    width: screenWidth * 0.05,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Add Timer',
                  style: GoogleFonts.roboto(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: ConstantColors.black),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: <Widget>[
                  hourMinute15Interval(),
                  // Container(
                  //   margin: const EdgeInsets.symmetric(vertical: 50),
                  //   child: Text(
                  //     '${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}',
                  //     style: const TextStyle(
                  //         fontSize: 24, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 0.05 * screenWidth,
                  right: 0.05 * screenWidth,
                  top: 0.03 * screenHeight,
                  bottom: 0.05 * screenWidth,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Repeat',
                          style: GoogleFonts.roboto(
                            fontSize: screenWidth * 0.04,
                            color: ConstantColors.mainlyTextColor,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Row(children: [
                          Text(
                            'Open',
                            style: GoogleFonts.roboto(
                              fontSize: screenWidth * 0.03,
                              color: ConstantColors.mainlyTextColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //Navigator.pushNamed(context, buildingRoute);
                            },
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: ConstantColors.mainlyTextColor,
                              size: 20,
                            ),
                          ),
                        ]),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Note',
                          style: GoogleFonts.roboto(
                            fontSize: screenWidth * 0.04,
                            color: ConstantColors.mainlyTextColor,
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            //Navigator.pushNamed(context, buildingRoute);
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: ConstantColors.mainlyTextColor,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Notification',
                          style: GoogleFonts.roboto(
                            fontSize: screenWidth * 0.04,
                            color: ConstantColors.mainlyTextColor,
                          ),
                        ),
                        const SizedBox(width: 20),
                        GFToggle(
                          onChanged: (val) {},
                          value: true,
                          enabledThumbColor: ConstantColors.whiteColor,
                          enabledTrackColor: ConstantColors.lightBlueColor,
                          type: GFToggleType.ios,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 0.05 * screenWidth,
                  right: 0.05 * screenWidth,
                  top: 0.03 * screenHeight,
                  bottom: 0.05 * screenWidth,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Switch',
                          style: GoogleFonts.roboto(
                            fontSize: screenWidth * 0.04,
                            color: ConstantColors.mainlyTextColor,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Row(children: [
                          Text(
                            'Open',
                            style: GoogleFonts.roboto(
                              fontSize: screenWidth * 0.03,
                              color: ConstantColors.mainlyTextColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //Navigator.pushNamed(context, buildingRoute);
                            },
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: ConstantColors.mainlyTextColor,
                              size: 20,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const AddTimerscreen()),
                // );
              },
              text: "Save",
              backgroundColor: ConstantColors.borderButtonColor,
              textColor: ConstantColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
