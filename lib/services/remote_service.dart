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

  //get building name
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

  

//add floor
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


  
  //get room name
  static Future<Response> getRoomInfo(String token) async {
    try {
      print('${url}master/room/');
      String apiUrl = '${url}master/room/';
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
  static Future<Response> createDevice(
      String authToken, String deviceName, String roomId) async {
    try {
      print('${url}master/device/');
      String apiUrl = '${url}master/device/';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };
      Map<String, dynamic> requestBody = {
        'device_sku': deviceName,
        'room_id': roomId,
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

  //get device name
  static Future<Response> getDeviceInfo(String token) async {
    try {
      print('${url}master/device/');
      String apiUrl = '${url}master/device/';
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
}
