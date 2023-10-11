import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  SharedPreferencesHelper._privateConstructor();

  static final SharedPreferencesHelper instance = SharedPreferencesHelper._privateConstructor();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Method to set the device ID in shared preferences
  Future<void> setDeviceId(String deviceId) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('deviceId', deviceId);
  }

  // Method to get the device ID from shared preferences
  Future<String?> getDeviceId() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('deviceId');
  }

}
