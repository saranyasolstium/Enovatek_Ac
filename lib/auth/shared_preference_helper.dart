import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  SharedPreferencesHelper._privateConstructor();

  static final SharedPreferencesHelper instance =
      SharedPreferencesHelper._privateConstructor();

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

  Future<void> saveUserDataToSharedPreferences(
      String userName, String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    await prefs.setString('userEmail', userEmail);
  }

// Method to set the authentication token in shared preferences
  Future<void> setAuthToken(String authToken) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('authToken', authToken);
  }

  // Method to get the auth ID from shared preferences
  Future<String?> getAuthToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('authToken');
  }

  Future<void> setLoginID(int loginID) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt('loginid', loginID);
  }

  Future<int?> getLoginID() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt('loginid');
  }

  Future<void> setUserID(int userId) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt('userId', userId);
  }

  Future<int?> getUserID() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt('userId');
  }

  Future<void> setUserTypeID(int userTypeId) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt('userTypeId', userTypeId);
  }

  Future<int?> getUserTypeID() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt('userTypeId');
  }

  Future<void> setMode(String mode) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('mode', mode);
  }

  Future<String?> getMode() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('mode');
  }

  Future<void> setFanMode(String mode) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('fan', mode);
  }

  Future<String?> getFanMode() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('fan');
  }

  // Future<void> saveBuildingData(int buildingID, String buildingName) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('buildingID', buildingID);
  //   await prefs.setString('buildingName', buildingName);
  // }

  // Future<int?> getBuildingID() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getInt('buildingID');
  // }
  // Future<String?> getBuildingName() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('buildingName');
  // }
}
