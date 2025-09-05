import 'dart:convert';

import 'package:enavatek_mobile/model/billing.dart';
import 'package:enavatek_mobile/model/country_data.dart';
import 'package:enavatek_mobile/model/energy.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class RemoteServices {
  static var client = http.Client();
  static String url = 'http://18.140.164.164/';

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

  static Future<Response> resetPasswordToken(String emailId) async {
    try {
      print('${url}api/token/resetpasswordtoken?_emailId=$emailId');
      String apiUrl = '${url}api/token/resetpasswordtoken?_emailId=$emailId';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
      );
      print(response.body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> resetPassword(
      String emailId, String token, String password) async {
    try {
      print('${url}api/token/resetpassword');
      String apiUrl = '${url}api/token/resetpassword';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> requestBody = {
        "token": token,
        "emailId": emailId,
        "password": password,
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

      http.Response response = await http.post(
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
      // String deviceId,
      String authToken,
      String deviceName,
      String deviceSerialNo,
      String bussiness,
      String location,
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
        "id": 0,
        "deviceId": deviceSerialNo,
        "deviceName": deviceName,
        "displayName": deviceName,
        "roomId": roomId,
        "userId": userId,
        "wifiName": "",
        "wifiPassword": "",
        "location_name": location,
        "business_unit_name": bussiness
      };
      print('Request Body: $requestBody');
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

  static Future<Response> actionCommand(String authToken, String value,
      String deviceId, int actionTypeId, int loginId) async {
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

  //get actionCommand
  static Future<Response> powerusages(String authToken, List<String> deviceId,
      String type, String typeValue, String consumptionType, int userId) async {
    try {
      print('${url}api/user/consumption_data');
      String apiUrl = '${url}api/user/consumption_data';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };
      Map<String, dynamic> requestBody = {
        "device_id": deviceId,
        "user_id": userId,
        "period_type": type,
        "period_value": typeValue,
        "consumption_type": consumptionType
      };
      print('hshhdhd $requestBody');
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

  static Future<Response> fetchDeviceRealTimeData(String token) async {
    try {
      print('${url}api/user/devicerealtimedata?id=21');
      String apiUrl = '${url}api/user/devicerealtimedata?id=21';
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

  static Future<List<EnergyData>> fetchEnergyData(
      {required List<String> deviceId,
      required String periodType,
      required int userId,
      required int countryId}) async {
    final apiUrl = Uri.parse('${url}api/user/power_consumption_data');
    print('${url}api/user/power_consumption_data');
    final response = await http.post(
      apiUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'device_id': deviceId,
        'period_type': periodType,
        'user_id': userId,
        "country_id": countryId
      }),
    );
    print('request ${jsonEncode({
          'device_id': deviceId,
          'period_type': periodType,
          'user_id': userId,
          "country_id": countryId
        })}');
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data =
          json.decode(response.body)['energy_calculation']['chart'];
      print(data);
      return data.map((json) => EnergyData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<Response> sendConfiguration(
      String authToken,
      String deviceId,
      String uid,
      String syncFrequency,
      String mqttEndPoint,
      String port,
      String publishTopic,
      String subscribeTopic,
      String ssid,
      String ssidPassword,
      String lat,
      String long) async {
    try {
      print('${url}api/mqtt/send_configuration');
      String apiUrl = '${url}api/mqtt/send_configuration';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };
      Map<String, dynamic> requestBody = {
        "deviceId": deviceId,
        "uid": uid,
        "sync_frequency": syncFrequency,
        "mqtt_end_point": mqttEndPoint,
        "port": port,
        "publish_topic": publishTopic,
        "subscribe_topic": subscribeTopic,
        "ssid": ssid,
        "ssid_password": ssidPassword,
        "longitude": "",
        "latitude": "",
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

  static Future<Response> createCountry(
      String token,
      int id,
      String countryName,
      String currencyType,
      double energyRate,
      double factor,
      double temperature) async {
    try {
      print('${url}api/master/create_update_country');
      String apiUrl = '${url}api/master/create_update_country';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      Map<String, dynamic> requestBody = {
        "id": id,
        "name": countryName,
        "currency_type": currencyType,
        "energy_rate": energyRate,
        "factor": factor,
        "temperature": temperature
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

  static Future<Response> deleteCountry(
    String token,
    int countryId,
  ) async {
    try {
      print('${url}api/master/delete_country_details');
      String apiUrl = '${url}api/master/delete_country_details';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      Map<String, dynamic> requestBody = {
        "id": countryId,
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

  static Future<List<CountryData>> fetchCountryList(
      {required String token}) async {
    final apiUrl = Uri.parse('${url}api/master/list_of_country');
    final response = await http.get(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('list_od_contry $data');
      final List list = data['data'];
      return list.map((json) => CountryData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<Response> getBusinessUnit(String token) async {
    try {
      print('${url}api/master/list_of_business');
      String apiUrl = '${url}api/master/list_of_business';
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

  static Future<Response> getLocation(String token) async {
    try {
      print('${url}api/master/list_of_location');
      String apiUrl = '${url}api/master/list_of_location';
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

  static Future<Response> filteredDevices(
    String authToken,
    int userId,
    Map<String, dynamic> requestBody,
  ) async {
    final apiUrl = '${url}api/user/devices?id=$userId';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
    final body = jsonEncode(requestBody);

    return await post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );
  }

  Future<http.Response> export({
    required List<String> deviceId,
    required String periodType,
    required int userId,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse('${url}api/user/power_consumption_csv_data'),
      body: jsonEncode({
        'device_id': deviceId,
        'period_type': periodType,
        'user_id': userId
      }),
      headers: headers,
    );
    print(
      jsonEncode({
        'device_id': deviceId,
        'period_type': periodType,
        'user_id': userId
      }),
    );
    print(response.body);

    return response;
  }

  //get billStatus

  static Future<Map<String, dynamic>> consumptionBillStatus(
      List<String> deviceId,
      int userId,
      int countryId,
      String periodValue) async {
    try {
      print('${url}api/user/power_consumption_bill_status_data');
      String apiUrl = '${url}api/user/power_consumption_bill_status_data';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> requestBody = {
        "device_id": deviceId,
        "user_id": userId,
        "country_id": countryId,
        "period_value": periodValue,
      };

      print(requestBody);
      String jsonBody = jsonEncode(requestBody);

      // Make the API request
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );

      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        List<BillingData> billingDataList =
            (responseBody['device_wise_bill'] as List)
                .map((data) => BillingData.fromJson(data))
                .toList();

        // Parse summary bill
        List<SummaryBill> summaryBillList =
            (responseBody['summary_bill'] as List)
                .map((data) => SummaryBill.fromJson(data))
                .toList();

        // Parse summary detail
        SummaryDetail summaryDetail =
            SummaryDetail.fromJson(responseBody['summary_detail']);

        // Return both lists in a map
        return {
          'billingData': billingDataList,
          'summaryBill': summaryBillList,
          'summaryDetail': summaryDetail,
        };
      } else {
        throw Exception('Failed to load billing data');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  static Future<Response> paymentUpdate(
      List<String> deviceId, String month, String paymentId) async {
    try {
      print('${url}api/user/device_bill_payment_update');
      String apiUrl = '${url}api/user/device_bill_payment_update';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> requestBody = {
        "device_id": deviceId,
        "payment_id": paymentId,
        "status": "paid",
        "period_value": month.toLowerCase()
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

  static Future<Response> downloadInvoice(String? paymentId) async {
    try {
      print('${url}api/user/invoice_generation');
      String apiUrl = '${url}api/user/invoice_generation';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> requestBody = {
        "payment_id": paymentId,
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

  static Future<Response> updateFcmToken(String fcmToken, String token) async {
    try {
      print('${url}api/user/fcm_token_update');
      String apiUrl = '${url}api/user/fcm_token_update';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      Map<String, dynamic> requestBody = {
        "fcm_token": fcmToken,
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

  static Future<Response> deleteAccount(
    String token,
    int userId,
  ) async {
    try {
      print('${url}api/user/delete_account/?id=$userId');
      String apiUrl = '${url}api/user/delete_account/?id=$userId';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      http.Response response = await http.delete(
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
