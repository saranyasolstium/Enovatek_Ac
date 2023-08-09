
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/router/routers.dart';
import 'package:enavatek_mobile/value/branding_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:enavatek_mobile/auth/authhelper.dart';




void main() async {
  // Load the login state from shared preferences
  WidgetsFlutterBinding.ensureInitialized();
  AuthHelper authHelper = AuthHelper();
  await authHelper.loadLoggedInState();

  runApp(
    ChangeNotifierProvider.value(
      value: authHelper,
      child: const Enavatek(),
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
          primarySwatch: brandingColor,
        ),
        onGenerateRoute: Routers.onGenerateRoute,
        initialRoute: splashRoute,
        
      ),
    );
  }
}