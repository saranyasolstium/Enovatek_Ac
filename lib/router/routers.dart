import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/add_device/bluetooth_scan.dart';
import 'package:enavatek_mobile/screen/device_details/add_schedule.dart';
import 'package:enavatek_mobile/screen/device_details/schedule.dart';
import 'package:enavatek_mobile/screen/enginner_access/enginner_home.dart';
import 'package:enavatek_mobile/screen/enginner_access/enginner_menu.dart';
import 'package:enavatek_mobile/screen/home/home_screen.dart';
import 'package:enavatek_mobile/screen/introduce/introduce_screen.dart';
import 'package:enavatek_mobile/screen/login_screen/forgetpassword.dart';
import 'package:enavatek_mobile/screen/login_screen/login_screen.dart';
import 'package:enavatek_mobile/screen/menu/building/add_building.dart';
import 'package:enavatek_mobile/screen/menu/building/building_screen.dart';
import 'package:enavatek_mobile/screen/menu/calculate/calculate_saving.dart';
import 'package:enavatek_mobile/screen/menu/calculate/saving_display.dart';
import 'package:enavatek_mobile/screen/menu/menu.dart';
import 'package:enavatek_mobile/screen/menu/request.dart';
import 'package:enavatek_mobile/screen/menu/support.dart';
import 'package:enavatek_mobile/screen/notification/notification_screen.dart';
import 'package:enavatek_mobile/screen/register/registration_screen.dart';
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

      case registerRoute:
        return PageTransition(
          child: const RegistrationScreen(),
          type: PageTransitionType.rightToLeft,
        );

      case forgetPasswordRoute:
        return PageTransition(
          child: const ForgetPasswordScreen(),
          type: PageTransitionType.rightToLeft,
        );

      case homedRoute:
        return PageTransition(
          child: const HomeScreen(),
          type: PageTransitionType.rightToLeft,
        );

      case enginnerHomeRounte:
        return PageTransition(
          child: const EnginnerHomeScreen(),
          type: PageTransitionType.rightToLeft,
        );

      case addBuildingRoute:
        return PageTransition(
          child: const AddBuilding(),
          type: PageTransitionType.rightToLeft,
        );

      // case allDeviceRoute:
      //   return PageTransition(
      //     child: const AllDeviceScreen(),
      //     type: PageTransitionType.rightToLeft,
      //   );

      // case deviceDetailRoute:
      //   return PageTransition(
      //     child: const DeviceDetailScreen(),
      //     type: PageTransitionType.rightToLeft,
      //   );

      // case addDeviceRoute:
      //   return PageTransition(
      //     child: const AddDeviceScreen(),
      //     type: PageTransitionType.rightToLeft,
      //   );

      case blueToothScanRoute:
        return PageTransition(
          child: const BluetoothScan(),
          type: PageTransitionType.rightToLeft,
        );

      // case manualAddDeviceRoute:
      //   return PageTransition(
      //     child: const ManualAddDevice(),
      //     type: PageTransitionType.rightToLeft,
      //   );

      // case wifiPasswordRoute:
      //   return PageTransition(
      //     child: const WifiPasswordScreen(),
      //     type: PageTransitionType.rightToLeft,
      //   );

      // case deviceNameRoute:
      //   return PageTransition(
      //     child: const DeviceNameScreen(),
      //     type: PageTransitionType.rightToLeft,
      //   );

      case notificationRoute:
        return PageTransition(
          child: const NotificationScreen(),
          type: PageTransitionType.rightToLeft,
        );
      case menuRoute:
        return PageTransition(
          child: const MenuScreen(),
          type: PageTransitionType.rightToLeft,
        );
      case enginnerMenuRoute:
        return PageTransition(
          child: const EnginnerMenuScreen(),
          type: PageTransitionType.rightToLeft,
        );
      case calculateRoute:
        return PageTransition(
          child: const CalculateSavingScreen(),
          type: PageTransitionType.rightToLeft,
        );

      case savingRoute:
        return PageTransition(
          child: const SavingDisplayScreen(),
          type: PageTransitionType.rightToLeft,
        );

      case supportRoute:
        return PageTransition(
          child: const SupportScreen(),
          type: PageTransitionType.rightToLeft,
        );

      case requestRoute:
        return PageTransition(
          child: const RequestScreen(),
          type: PageTransitionType.rightToLeft,
        );
      case buildingRoute:
        return PageTransition(
          child: const BuildingScreen(),
          type: PageTransitionType.rightToLeft,
        );

      case scheduleRoute:
        return PageTransition(
          child: const SheduleScreen(),
          type: PageTransitionType.rightToLeft,
        );

      case addScheduleRoute:
        return PageTransition(
          child: const AddSheduleScreen(),
          type: PageTransitionType.rightToLeft,
        );

      // case deviceAssignRoute:
      // return PageTransition(
      //   child: const DeviceAssigningScreen(buildingId: '1'),
      //   type: PageTransitionType.rightToLeft,
      // );

      // case addFloorNameRoute:
      // return PageTransition(
      //   child: const AddFloorName(),
      //   type: PageTransitionType.rightToLeft,
      // );

      // case editFloorNameRoute:
      // return PageTransition(
      //   child: const EditFloorName(),
      //   type: PageTransitionType.rightToLeft,
      // );

      default:
        return MaterialPageRoute(builder: (_) => Container());
    }
  }
}
