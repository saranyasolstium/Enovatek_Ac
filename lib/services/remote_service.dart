import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class RemoteServices {
  static var client = http.Client();
  static String url = 'http://13.212.177.46/';

  //add building

  static Future<Response> authenticationToken() async {
    try {
      String apiUrl = '${url}authentication/token/';

      // Encode the username and password for Basic Authentication
      String basicAuth = 'Basic ${base64Encode(utf8.encode('admin:admin'))}';

      // Create the request headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': basicAuth,
      };
      String jsonBody = jsonEncode({
        'password': 'admin',
        'username': 'admin',
      });

      Response response = await post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> login(String email, name, mobileNo) async {
    try {
      print('${url}users/register_user/');
      Response response =
          await post(Uri.parse('${url}users/register_user/'), body: {
        "email": email,
        "mobile_no": mobileNo,
        "first_name": name,
        "password": "password",
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //add building
  static Future<Response> addBuildingName(
      String token, String buildingName) async {
    try {
      print('${url}master/building/');
      String apiUrl = '${url}master/building/';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      Map<String, dynamic> requestBody = {
        'building_name': buildingName,
      };
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
  static Future<Response> getBuildingInfo(String token) async {
    try {
      print('${url}master/building/');
      String apiUrl = '${url}master/building/';
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
  static Future<Response> createFloor(
      String authToken, String floorName, String buildingId) async {
    try {
      print('${url}master/floor/');
      String apiUrl = '${url}master/floor/';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };
      Map<String, dynamic> requestBody = {
        'floor_name': floorName,
        'building_id': buildingId,
      };
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

   //get floor name
  static Future<Response> getFloorInfo(String token) async {
    try {
      print('${url}master/floor/');
      String apiUrl = '${url}master/floor/';
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

// static Future<Response> getFloorID(String token ,String ID) async {
//     try {
//       print('${url}master/floor/$ID');
//       String apiUrl = '${url}master/floor/$ID';
//       Map<String, String> headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       };

//       http.Response response = await http.get(
//         Uri.parse(apiUrl),
//         headers: headers,
//       );
//       print(response.body);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }


  //add floor
  static Future<Response> createRoom(
      String authToken, String roomName, String floorId) async {
    try {
      print('${url}master/room/');
      String apiUrl = '${url}master/room/';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };
      Map<String, dynamic> requestBody = {
        'room_number': roomName,
        'floor_id': floorId,
        
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
