import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  // Load the login state from shared preferences
  Future<void> loadLoggedInState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  // Set the login state and store it in shared preferences
  Future<void> setLoggedIn(bool value) async {
    _isLoggedIn = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
    notifyListeners();
  }
}
