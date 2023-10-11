import 'dart:async';
import 'dart:io';
import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/value/path/path.dart';

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
        deviceId = androidInfo.androidId;
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId =
            iosInfo.identifierForVendor; // For iOS, use identifierForVendor
      }
    } catch (e) {
      print('Error getting device ID: $e');
    }

    return deviceId;
  }

  // Function to store the device ID in shared preferences
  Future<void> saveDeviceIdToSharedPreferences() async {
    final String deviceId = await getDeviceId();
    await SharedPreferencesHelper.instance.setDeviceId(deviceId);
  }

  Future<void> _navigateToInitialScreen() async {
    // Check if the device ID is already in shared preferences
    String? retrievedDeviceId =
        await SharedPreferencesHelper.instance.getDeviceId();
    if (retrievedDeviceId == null) {
      await saveDeviceIdToSharedPreferences();
    }

    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(
        context,
        introduceRoute,
      ),
    );
  }
}
