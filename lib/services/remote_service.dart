import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class RemoteServices {
  static var client = http.Client();
  static String url = 'http://13.212.177.46/';

  //Facebook login
  static Future<Response> login(
      String emailId, String password, String deviceID) async {
    try {
      print('${url}api/token');
      String apiUrl = '${url}api/token';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> requestBody = {
        "emailId": emailId,
        "password": password,
        "deviceId": deviceID
      };
      print(requestBody);
      String jsonBody = jsonEncode(requestBody);

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

//google login
  static Future<Response> googleApiLogin(
      String name, String emailId, String deviceID) async {
    try {
      print('${url}api/token/google');
      String apiUrl = '${url}api/token/google';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> requestBody = {
        "name": name,
        "emailId": emailId,
        "mobileNo": "00000000",
        "deviceId": deviceID
      };
      print(requestBody);
      String jsonBody = jsonEncode(requestBody);

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

//Facebook login
  static Future<Response> fbApiLogin(
      String name, String emailId, String deviceID) async {
    try {
      print('${url}api/token/fb');
      String apiUrl = '${url}api/token/fb';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> requestBody = {
        "name": name,
        "emailId": emailId,
        "mobileNo": "00000000",
        "deviceId": deviceID
      };
      print(requestBody);
      String jsonBody = jsonEncode(requestBody);

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //registration
  static Future<Response> userSignUp(
      String name, String emailId, String mobileNo, String password) async {
    try {
      print('${url}api/register');
      String apiUrl = '${url}api/register';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> requestBody = {
        "name": name,
        "emailId": emailId,
        "mobileNo": mobileNo,
        "password": password
      };
      print(requestBody);
      String jsonBody = jsonEncode(requestBody);

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //add building
  static Future<Response> addBuildingName(
      String token, String buildingName, int buildingID, int userId) async {
    try {
      print('${url}api/building');
      String apiUrl = '${url}api/building';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      Map<String, dynamic> requestBody = {
        "buildingId": buildingID,
        "userId": userId,
        "name": buildingName,
      };
      print(requestBody);
      String jsonBody = jsonEncode(requestBody);

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

   //add building
  static Future<Response> deleteBuilding(
      String token, String buildingName, int buildingID, int userId) async {
    try {
      print('${url}api/building/delete');
      String apiUrl = '${url}api/building/delete';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      Map<String, dynamic> requestBody = {
        "buildingId": buildingID,
        "userId": userId,
        "name": buildingName,
      };
      print(requestBody);
      String jsonBody = jsonEncode(requestBody);

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }


  //get device by user
  static Future<Response> getAllDeviceByUserId(String token, int userId) async {
    try {
      print('${url}api/user/devices?id=$userId');
      String apiUrl = '${url}api/user/devices?id=$userId';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

//add floor
  static Future<Response> createFloor(String authToken, String floorName,
      int buildingId, int floorId, int userId) async {
    try {
      print('${url}api/floor');
      String apiUrl = '${url}api/floor';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };
      Map<String, dynamic> requestBody = {
        "buildingId": buildingId,
        "floorId": floorId,
        "userId": userId,
        "name": floorName
      };
      print(requestBody);
      String jsonBody = jsonEncode(requestBody);

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

//delete floor
static Future<Response> deleteFloor(String authToken, String floorName,
      int buildingId, int floorId, int userId) async {
    try {
      print('${url}api/floor/delete');
      String apiUrl = '${url}api/floor/delete';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };
      Map<String, dynamic> requestBody = {
        "buildingId": buildingId,
        "floorId": floorId,
        "userId": userId,
        "name": floorName
      };
      print(requestBody);
      String jsonBody = jsonEncode(requestBody);

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //add room
  static Future<Response> createRoom(String authToken, String roomName,
      int buildingId, int floorId, int roomId, int userId) async {
    try {
      print('${url}api/room');
      String apiUrl = '${url}api/room';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };
      Map<String, dynamic> requestBody = {
        "roomId": roomId,
        "floorId": floorId,
        "buildingId": buildingId,
        "userId": userId,
        "name": roomName
      };
      print(requestBody);
      String jsonBody = jsonEncode(requestBody);

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

//delete room
  static Future<Response> deleteRoom(String authToken, String roomName,
      int buildingId, int floorId, int roomId, int userId) async {
    try {
      print('${url}api/room/delete');
      String apiUrl = '${url}api/room/delete';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };
      Map<String, dynamic> requestBody = {
        "roomId": roomId,
        "floorId": floorId,
        "buildingId": buildingId,
        "userId": userId,
        "name": roomName
      };
      print(requestBody);
      String jsonBody = jsonEncode(requestBody);

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }


  //add device
  static Future<Response> createDevice(
      String authToken,
      String deviceName,
      String deviceSerialNo,
      String wifiName,
      String password,
      int deviceID,
      int roomId,
      int userId) async {
    try {
      print('${url}api/device');
      String apiUrl = '${url}api/device';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };
      Map<String, dynamic> requestBody = {
        "deviceId": deviceID,
        "deviceName": deviceSerialNo,
        "displayName": deviceName,
        "roomId": roomId,
        "userId": userId,
        "wifiName": wifiName,
        "wifiPassword": password,
      };
      print(requestBody);
      String jsonBody = jsonEncode(requestBody);

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //get actiontype
  static Future<Response> getActiontype() async {
    try {
      print('${url}api/master/actiontype');
      String apiUrl = '${url}api/master/actiontype';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //get actionCommand
  static Future<Response> actionCommand(String authToken, String value,
      int deviceId, int actionTypeId, int loginId) async {
    try {
      print('${url}api/appcommand');
      String apiUrl = '${url}api/appcommand';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };
      Map<String, dynamic> requestBody = {
        "deviceId": deviceId,
        "actionTypeId": actionTypeId,
        "loginId": loginId,
        "value": value
      };
      print(requestBody);
      String jsonBody = jsonEncode(requestBody);

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
