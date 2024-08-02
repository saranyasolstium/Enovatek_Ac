import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BluetoothScan extends StatefulWidget {
  const BluetoothScan({Key? key}) : super(key: key);

  @override
  BluetoothScanState createState() => BluetoothScanState();
}

class BluetoothScanState extends State<BluetoothScan> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      bottomNavigationBar: Footer(),

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
                  'Add Device',
                  style: GoogleFonts.roboto(
                      fontSize: screenWidth * 0.05,
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
                'Bring you phone closer to the device',
                style: GoogleFonts.roboto(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: ConstantColors.black),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Center(
              child: Image.asset(
                ImgPath.pngWifi,
                height: screenWidth * 0.2,
                width: screenWidth * 0.3,
              ),
            ),
            Center(
              child: Image.asset(
                ImgPath.pngAirConditioner,
                height: screenWidth * 0.5,
                width: screenWidth * 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
