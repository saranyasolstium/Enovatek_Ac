import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:google_fonts/google_fonts.dart';

void showTimePickerSpinnerDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          DateTime selectedTime = DateTime.now();

          return AlertDialog(
            title: const Text('Set Time'),
            content: TimePickerSpinner(
              is24HourMode: false,
              normalTextStyle: const TextStyle(fontSize: 24, color: ConstantColors.mainlyTextColor),
              highlightedTextStyle: const TextStyle(fontSize: 24, color: ConstantColors.lightBlueColor),
              spacing: 50,
              itemHeight: 80,
              isForce2Digits: true,
              time: selectedTime,
              onTimeChange: (time) {
                selectedTime = time;
              },
            ),
                    actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    primary: ConstantColors.lightBlueColor,
                    onPrimary: ConstantColors.whiteColor,
                    side: const BorderSide(
                      color: ConstantColors.borderButtonColor,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.roboto(
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 30,),
              Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    primary: ConstantColors.whiteColor,
                    onPrimary: ConstantColors.lightBlueColor,
                    side: const BorderSide(
                      color: ConstantColors.borderButtonColor,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  onPressed: () {
                      Navigator.pushNamed(context, addScheduleRoute);                  },
                  child: Text(
                    "Save",
                    style: GoogleFonts.roboto(
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
       );
        },
      );
    }
