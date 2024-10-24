import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/router/routers.dart';
import 'package:enavatek_mobile/services/push_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:enavatek_mobile/auth/authhelper.dart';
import 'package:sizer/sizer.dart';
import 'package:device_preview/device_preview.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    Sizer(
      builder: (context, orientation, deviceType) {
        return DevicePreview(
          enabled: false,
          builder: (context) => const Enavatek(),
        );
      },
    ),
  );
}



class Enavatek extends StatelessWidget {
  const Enavatek({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthHelper()),
      ],
      child: MaterialApp(
        title: 'Enavatek',
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        localizationsDelegates: const [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData(
          fontFamily: GoogleFonts.nunito(
            fontWeight: FontWeight.w500,
          ).fontFamily,
        ),
        onGenerateRoute: Routers.onGenerateRoute,
        initialRoute: splashRoute,
      ),
    );
  }
}
