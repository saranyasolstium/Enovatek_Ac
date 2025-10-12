// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/screen/device_details/power_statistics.dart';
import 'package:flutter/material.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigateToInitialScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImgPath.pngSplashBg),
                fit: BoxFit.cover,
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned(
            child: Center(
              child: Image.asset(
                ImgPath.pngName,
              ),
            ),
          )
        ],
      ),
    );
  }

  // Function to get the device ID
  Future<String> getDeviceId() async {
    String deviceId = '';
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo =
            await deviceInfoPlugin.androidInfo;
        deviceId = androidInfo.id ?? '';
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
      }
    } catch (e) {
      print('Error getting device ID: $e');
    }

    print(deviceId);
    return deviceId;
  }

  // Function to store the device ID in shared preferences
  Future<void> saveDeviceIdToSharedPreferences() async {
    final String deviceId = await getDeviceId();
    await SharedPreferencesHelper.instance.setDeviceId(deviceId);
  }

  Future<void> _navigateToInitialScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    saveDeviceIdToSharedPreferences();
    // Check if the user is logged in
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Check if the app has been launched before
    bool hasBeenLaunched = prefs.getBool('hasBeenLaunched') ?? false;

    if (!hasBeenLaunched) {
      await prefs.setBool('hasBeenLaunched', true);
      Navigator.pushReplacementNamed(context, introduceRoute);
    } else {
      if (isLoggedIn) {
        int? userTypeId =
            await SharedPreferencesHelper.instance.getUserTypeID();
        if (userTypeId == 1 || userTypeId == 2) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const PowerStatisticsScreen(
                deviceId: "",
                deviceList: [],
                tabIndex: 1,
              ),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.pushReplacementNamed(context, enginnerHomeRounte);
        }
      } else {
        Navigator.pushReplacementNamed(context, loginRoute);
      }
    }
  }
}
