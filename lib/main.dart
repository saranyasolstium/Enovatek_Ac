import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/router/routers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:enavatek_mobile/auth/authhelper.dart';

import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    Sizer(
      builder: (context, orientation, deviceType) {
        return const Enavatek();
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
