import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/add_device/add_device_screen.dart';
import 'package:enavatek_mobile/screen/add_device/bluetooth_scan.dart';
import 'package:enavatek_mobile/screen/add_device/device_name_screen.dart';
import 'package:enavatek_mobile/screen/add_device/manual_add_device.dart';
import 'package:enavatek_mobile/screen/add_device/wifi_password_screen.dart';
import 'package:enavatek_mobile/screen/all_device/all_device_screen.dart';
import 'package:enavatek_mobile/screen/device_details/device_details_screen.dart';
import 'package:enavatek_mobile/screen/home/home_screen.dart';
import 'package:enavatek_mobile/screen/introduce/introduce_screen.dart';
import 'package:enavatek_mobile/screen/login_screen/login_screen.dart';
import 'package:enavatek_mobile/screen/profile/profile_screen.dart';
import 'package:enavatek_mobile/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Routers {
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      // Auth Routes

      case introduceRoute:
        return PageTransition(
          child: IntroductionScreen(),
          type: PageTransitionType.rightToLeft,
        );

      case loginRoute:
        return PageTransition(
          child: const LoginScreen(),
          type: PageTransitionType.rightToLeft,
        );

      case profileRoute:
        return PageTransition(
          child: const ProfileScreen(),
          type: PageTransitionType.rightToLeft,
        );

      case homedRoute:
        return PageTransition(
          child: const HomeScreen(),
          type: PageTransitionType.rightToLeft,
        );

        case allDeviceRoute:
        return PageTransition(
          child: const AllDeviceScreen(),
          type: PageTransitionType.rightToLeft,
        );

        case deviceDetailRoute:
        return PageTransition(
          child: const DeviceDetailScreen(),
          type: PageTransitionType.rightToLeft,
        );

        case addDeviceRoute:
        return PageTransition(
          child: const AddDeviceScreen(),
          type: PageTransitionType.rightToLeft,
        );

      case blueToothScan:
        return PageTransition(
          child: const BluetoothScan(),
          type: PageTransitionType.rightToLeft,
        );

      case manualAddDevice:
        return PageTransition(
          child: const ManualAddDevice(),
          type: PageTransitionType.rightToLeft,
        );

        case wifiPassword:
        return PageTransition(
          child: const WifiPasswordScreen(),
          type: PageTransitionType.rightToLeft,
        );

         case deviceName:
        return PageTransition(
          child: const DeviceNameScreen(),
          type: PageTransitionType.rightToLeft,
        );

      default:
        return MaterialPageRoute(builder: (_) => Container());
    }
  }
}
