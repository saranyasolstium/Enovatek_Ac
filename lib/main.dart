
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/router/routers.dart';
import 'package:enavatek_mobile/value/branding_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:enavatek_mobile/auth/authhelper.dart';

import 'package:device_preview/device_preview.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    runApp(
    DevicePreview(
      enabled: false, // Enable device preview
      builder: (context) => Sizer(
        builder: (context, orientation, deviceType) {
          return const Enavatek();
        },
      ),
    ),
  );
}



// void main() async {
//   // Load the login state from shared preferences
//   WidgetsFlutterBinding.ensureInitialized();
//   AuthHelper authHelper = AuthHelper();
//   await authHelper.loadLoggedInState();

//   runApp(
//     ChangeNotifierProvider.value(
//       value: authHelper,
//       child: Builder(
//         builder: (context) {
//           return MaterialApp(
//             builder: DevicePreview.appBuilder, 
            
//             title: 'Enavatek',
//             debugShowCheckedModeBanner: false,
//             theme: ThemeData(
//               fontFamily: GoogleFonts.nunito(
//                 fontWeight: FontWeight.w500,
//               ).fontFamily,
//               primarySwatch: brandingColor,
//             ),
//             onGenerateRoute: Routers.onGenerateRoute,
//             initialRoute: splashRoute,
//           );
//         },
//       ),
//     ),
//   );
// }




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
        theme: ThemeData(
          fontFamily: GoogleFonts.nunito(
            fontWeight: FontWeight.w500,
          ).fontFamily,
          primarySwatch: brandingColor,
        ),
        onGenerateRoute: Routers.onGenerateRoute,
        initialRoute: splashRoute,
        
      ),
    );
  }
}