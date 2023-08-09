import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeviceDetailScreen extends StatefulWidget {
  const DeviceDetailScreen({Key? key}) : super(key: key);

  @override
  DeviceDetailScreenState createState() => DeviceDetailScreenState();
}

class DeviceDetailScreenState extends State<DeviceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: AppBar(
            backgroundColor: ConstantColors.backgroundColor,
            automaticallyImplyLeading: false, // Hide the back button
            elevation: 0.0, // Remove elevation (shadow)
            title: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            ImgPath.pngArrowBack,
                            height: 25,
                            width: 25,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Devices',
                            style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.black),
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {},
                      color: ConstantColors.whiteColor,
                      textColor: Colors.white,
                      minWidth: 30,
                      height: 30,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: ConstantColors.borderButtonColor,
                          width: 2,
                        ),
                      ),
                      child: Image.asset(
                        ImgPath.pngEdit,
                        height: 10,
                        width: 10,
                        color: ConstantColors.lightBlueColor,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {},
                      color: ConstantColors.greenColor,
                      textColor: Colors.white,
                      minWidth: 30,
                      height: 30,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: ConstantColors.greenColor,
                          width: 2,
                        ),
                      ),
                      child: const Icon(Icons.power_settings_new,
                          size: 20, color: ConstantColors.whiteColor),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(
          children: [
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Total Energy saving: ',
                      style: GoogleFonts.roboto(
                          color: ConstantColors.mainlyTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    TextSpan(
                      text: '80% ',
                      style: GoogleFonts.roboto(
                          color: ConstantColors.greenColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    const WidgetSpan(
                      child: SizedBox(
                        width: 10,
                      ),
                    ),
                    const WidgetSpan(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: ConstantColors.mainlyTextColor,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
