import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({Key? key}) : super(key: key);

  @override
  AddDeviceScreenState createState() => AddDeviceScreenState();
}

class AddDeviceScreenState extends State<AddDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
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
                    height: 25,
                    width: 25,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Add Device',
                  style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ConstantColors.black),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Text(
                'Select option',
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ConstantColors.black),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Scan QR code\n\n ',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          TextSpan(
                            text: 'Scan the QR code available on your device',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: ConstantColors.mainlyTextColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, blueToothScanRoute);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: ConstantColors.whiteColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Scan for nearby device\n\n ',
                              style: GoogleFonts.roboto(
                                  color: ConstantColors.mainlyTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            TextSpan(
                              text: 'Scan the QR code available on your device',
                              style: GoogleFonts.roboto(
                                  color: ConstantColors.mainlyTextColor,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: ConstantColors.mainlyTextColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, manualAddDeviceRoute);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: ConstantColors.whiteColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Enter serial no.\n\n ',
                              style: GoogleFonts.roboto(
                                  color: ConstantColors.mainlyTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            TextSpan(
                              text:
                                  'Enter the serial number manually to connect',
                              style: GoogleFonts.roboto(
                                  color: ConstantColors.mainlyTextColor,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: ConstantColors.mainlyTextColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
