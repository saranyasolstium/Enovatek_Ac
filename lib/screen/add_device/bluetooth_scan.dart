import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
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
                'Bring you phone closer to the device',
                style: GoogleFonts.roboto(
                    fontSize: 18,
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
                height: 50,
                width: 100,
              ),
            ),
            Center(
              child: Image.asset(
                ImgPath.pngAirConditioner,
                height: 200,
                width: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
