// ignore_for_file: use_build_context_synchronously


import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/enginner_access/add_device_AppCtrl.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wifi_iot/wifi_iot.dart';

class EnginnerHomeScreen extends StatefulWidget {
  const EnginnerHomeScreen({super.key});

  @override
  EnginnerHomeScreenState createState() => EnginnerHomeScreenState();
}

class EnginnerHomeScreenState extends State<EnginnerHomeScreen> {


  Future<void> _connectToControllerWifi() async {
    try {
      String ssid = 'PM20H20Q';
      String password = 'Eno420714Vatek';

      await WiFiForIoTPlugin.connect(ssid,
          password: password, joinOnce: true, security: NetworkSecurity.WPA);
      bool isConnected = await WiFiForIoTPlugin.isConnected();
      print(isConnected);

      setState(() {
      });
    } catch (e) {
      print('Error connecting to Wi-Fi: $e');
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth >= 600;
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              ImgPath.pngName,
              width: isTablet ? 0.5 * screenWidth : 0.4 * screenWidth,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, enginnerMenuRoute);
                    },
                    child: Image.asset(
                      ImgPath.pngMenu,
                      width: isTablet ? 0.07 * screenWidth : 0.07 * screenWidth,
                      height:
                          isTablet ? 0.05 * screenHeight : 0.07 * screenHeight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
        child: Column(
          children: [
            Center(
              child: Text(
                textAlign: TextAlign.center,
                'Connect to Controller',
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: ConstantColors.mainlyTextColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Center(
              child: SizedBox(
                width: 150,
                height: 50,
                child: RoundedButton(
                  onPressed: () {
                    _connectToControllerWifi().then((_) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AddDeviceAppCtrlScreen()),
                      );
                    });
                  },
                  text: "Connect",
                  backgroundColor: ConstantColors.borderButtonColor,
                  textColor: ConstantColors.whiteColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
