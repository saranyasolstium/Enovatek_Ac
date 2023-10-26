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

  Future<void> saveUserDataToSharedPreferences(String userName, String userEmail) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userName', userName);
  await prefs.setString('userEmail', userEmail);
}

// Method to set the authentication token in shared preferences
  Future<void> setAuthToken(String authToken) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('authToken', authToken);
  }

  // Method to get the device ID from shared preferences
  Future<String?> getAuthToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('authToken');
  }

  Future<void> saveBuildingData(String buildingID, String buildingName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('buildingID', buildingID);
  await prefs.setString('buildingName', buildingName);
}
Future<String?> getBuildingID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('buildingID');
}



}
