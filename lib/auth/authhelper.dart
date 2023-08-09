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

// InputDecoration textFielWithIcondDecoration({required String placeholder}) {
//     return InputDecoration(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10.0),
//         borderSide: const BorderSide(
//           width: 0,
//           style: BorderStyle.none,
//         ),
//       ),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       hintText: placeholder,
//       fillColor: ConstantColors.inputColor,
//       filled: true,
//       suffixIcon: const Icon(Icons.calendar_today), 
//       hintStyle: GoogleFonts.nunito(
//         color: ConstantColors.mainlyTextColor,
//         fontSize: 16,
//         fontWeight: FontWeight.w500,
//       ),
//     );
//   }


//   InputDecoration textFieldDecoration({required String placeholder}) {
//     return InputDecoration(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10.0),
//         borderSide: const BorderSide(
//           width: 0,
//           style: BorderStyle.none,
//         ),
//       ),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       hintText: placeholder,
//       fillColor: ConstantColors.inputColor,
//       filled: true,
//       hintStyle: GoogleFonts.nunito(
//         color: ConstantColors.mainlyTextColor,
//         fontSize: 16,
//         fontWeight: FontWeight.w500,
//       ),
//     );
//   }

}



