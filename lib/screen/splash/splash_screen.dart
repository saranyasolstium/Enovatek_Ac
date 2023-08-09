import 'dart:async';

import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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

  // Function to check the login state from SharedPreferences and navigate accordingly
  Future<void> _navigateToInitialScreen() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    //final String initialRoute = isLoggedIn ? dashboardRoute : loginRoute;
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(
        context,
        introduceRoute,
      ),
    );
  }
}
