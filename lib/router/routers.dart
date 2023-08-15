import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/add_device/add_device_screen.dart';
import 'package:enavatek_mobile/screen/add_device/bluetooth_scan.dart';
import 'package:enavatek_mobile/screen/add_device/device_assign/add_floor.dart';
import 'package:enavatek_mobile/screen/add_device/device_assign/device_assigning.dart';
import 'package:enavatek_mobile/screen/add_device/device_assign/edit_floor.dart';
import 'package:enavatek_mobile/screen/add_device/device_name_screen.dart';
import 'package:enavatek_mobile/screen/add_device/manual_add_device.dart';
import 'package:enavatek_mobile/screen/add_device/wifi_password_screen.dart';
import 'package:enavatek_mobile/screen/all_device/all_device_screen.dart';
import 'package:enavatek_mobile/screen/device_details/add_schedule.dart';
import 'package:enavatek_mobile/screen/device_details/device_details_screen.dart';
import 'package:enavatek_mobile/screen/device_details/schedule.dart';
import 'package:enavatek_mobile/screen/home/home_screen.dart';
import 'package:enavatek_mobile/screen/introduce/introduce_screen.dart';
import 'package:enavatek_mobile/screen/login_screen/login_screen.dart';
import 'package:enavatek_mobile/screen/menu/building.dart';
import 'package:enavatek_mobile/screen/menu/calculate/calculate_saving.dart';
import 'package:enavatek_mobile/screen/menu/calculate/saving_display.dart';
import 'package:enavatek_mobile/screen/menu/menu.dart';
import 'package:enavatek_mobile/screen/menu/request.dart';
import 'package:enavatek_mobile/screen/menu/support.dart';
import 'package:enavatek_mobile/screen/notification/notification_screen.dart';
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

      case blueToothScanRoute:
        return PageTransition(
          child: const BluetoothScan(),
          type: PageTransitionType.rightToLeft,
        );

      case manualAddDeviceRoute:
        return PageTransition(
          child: const ManualAddDevice(),
          type: PageTransitionType.rightToLeft,
        );

      case wifiPasswordRoute:
        return PageTransition(
          child: const WifiPasswordScreen(),
          type: PageTransitionType.rightToLeft,
        );

      case deviceNameRoute:
        return PageTransition(
          child: const DeviceNameScreen(),
          type: PageTransitionType.rightToLeft,
        );

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

        case deviceAssignRoute:
        return PageTransition(
          child: const DeviceAssigningScreen(),
          type: PageTransitionType.rightToLeft,
        );

         case addFloorNameRoute:
        return PageTransition(
          child: const AddFloorName(),
          type: PageTransitionType.rightToLeft,
        );

        case editFloorNameRoute:
        return PageTransition(
          child: const EditFloorName(),
          type: PageTransitionType.rightToLeft,
        );

      default:
        return MaterialPageRoute(builder: (_) => Container());
    }
  }
}
