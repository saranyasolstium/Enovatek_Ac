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
    final isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      bottomNavigationBar: const Footer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          isTablet ? screenWidth * 0.025 : screenWidth * 0.05,
          screenHeight * 0.05,
          screenWidth * 0.05,
          screenHeight * 0.02,
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Image.asset(
                    ImgPath.pngArrowBack,
                    height: isTablet ? 40 : 22,
                    width: isTablet ? 40 : 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Add Device',
                    style: GoogleFonts.roboto(
                        fontSize: isTablet
                            ? screenWidth * 0.025
                            : screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: ConstantColors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: isTablet ? 30 : 50,
            ),
            Center(
              child: Text(
                'Bring you phone closer to the device',
                style: GoogleFonts.roboto(
                    fontSize:
                        isTablet ? screenWidth * 0.025 : screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: ConstantColors.black),
              ),
            ),
            SizedBox(
              height: isTablet ? 50 : 80,
            ),
            Center(
              child: Image.asset(
                ImgPath.pngWifi,
                height: isTablet ? screenWidth * 0.05 : screenWidth * 0.2,
                width: isTablet ? screenWidth * 0.05 : screenWidth * 0.3,
              ),
            ),
            Center(
              child: Image.asset(
                ImgPath.pngAirConditioner,
                height: isTablet ? screenWidth * 0.2 : screenWidth * 0.5,
                width: isTablet ? screenWidth * 0.2 : screenWidth * 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
