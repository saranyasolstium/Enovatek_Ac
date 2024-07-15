import 'dart:convert';
import 'dart:io';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'package:wifi_iot/wifi_iot.dart';

class AddDeviceAppCtrlScreen extends StatefulWidget {
  const AddDeviceAppCtrlScreen({Key? key}) : super(key: key);

  @override
  AddDeviceAppCtrlScreenState createState() => AddDeviceAppCtrlScreenState();
}

class AddDeviceAppCtrlScreenState extends State<AddDeviceAppCtrlScreen> {
  TextEditingController deviceIDController = TextEditingController();
  TextEditingController deviceUIDController = TextEditingController();
  TextEditingController mqttEndPointController = TextEditingController();
  TextEditingController mqttPortController = TextEditingController();
  TextEditingController mqttPublishTopicController = TextEditingController();
  TextEditingController mqttSubscribeTopicController = TextEditingController();
  TextEditingController wifiSSIDController = TextEditingController();
  TextEditingController wifiPasswordController = TextEditingController();

  int selectedFrequency = 0;

  Future<void> _disconnectFromWifi() async {
    try {
      await WiFiForIoTPlugin.disconnect();
      sendConfig();
      print('Disconnected from Wi-Fi');
    } catch (e) {
      print('Error disconnecting from Wi-Fi: $e');
    }
  }

  void sendConfigurationPackage() async {
    // Device IP address and port
    const String deviceIP = '192.6.6.6';
    const int devicePort = 8000;

    // Configuration package detailsS
    const String packageHead = 'C6F9G0';
    String deviceId = "987654";
    String deviceUID = "70B8F665D734";
    const int syncFreqMin = 60;
    const String mqttEndPoint =
        'a3bd9ic9v4dpst-ats.iot.ap-southeast-1.amazonaws.com';
    const int mqttPort = 8883;
    const String mqttPublishTopic = 'power/data';
    const String mqttSubscribeTopic = 'power/cmd';
    const String wifiSSID = 'Enovatek01';
    const String wifiPassword = 'GoGreen01';
    const String packageEnd = 'E0N7D5';

    // Construct the configuration package
    String configPackage =
        '$packageHead;$deviceId;$deviceUID;$syncFreqMin;$mqttEndPoint;$mqttPort;$mqttPublishTopic;$mqttSubscribeTopic;$wifiSSID;$wifiPassword;$packageEnd';
    print(configPackage);
    try {
      final socket = await Socket.connect(deviceIP, devicePort,
          timeout: const Duration(seconds: 60));
      print(
          'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

      socket.write(configPackage);
      socket.listen((List<int> data) {
        String response = String.fromCharCodes(data);
        print('Response: $response');
        if (response.contains('CFGUOK')) {
          print('Configuration was successful.');
          _disconnectFromWifi();
        } else {
          print('Configuration failed.');
        }
      });
      await Future.delayed(const Duration(seconds: 2));
      await socket.close();
      print('Connection closed.');
    } catch (e) {
      print('Error sending configuration: $e');
    }
  }

  Future<void> sendConfig() async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();

    final response = await RemoteServices.sendConfiguration(authToken!);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      String status = responseBody['status'];
      print('Status: $status');
      SnackbarHelper.showSnackBar(context, "Configuration send successful.");
    } else {
      print('error ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: ConstantColors.backgroundColor,
        leading: IconButton(
          icon: Image.asset(
            ImgPath.pngArrowBack,
            height: 20,
            width: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Device Configuration',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ConstantColors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, right: 0),
                decoration: BoxDecoration(
                  color: ConstantColors.inputColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  autocorrect: false,
                  controller: deviceIDController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    hintText: 'Enter Device ID',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 0),
                decoration: BoxDecoration(
                  color: ConstantColors.inputColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  autocorrect: false,
                  controller: deviceUIDController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    hintText: 'Enter UID',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 0),
                decoration: BoxDecoration(
                  color: ConstantColors.inputColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.roboto(fontSize: 16),
                    hintText: 'Select Frequency',
                  ),
                  value: selectedFrequency,
                  onChanged: (newValue) {
                    setState(() {
                      selectedFrequency = newValue!;
                    });
                  },
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.expand_more,
                      color: ConstantColors.mainlyTextColor,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem<int>(
                      value: 0,
                      child: Text(
                        "Select Frequency",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    DropdownMenuItem<int>(
                      value: 1,
                      child: Text("1 min"),
                    ),
                    DropdownMenuItem<int>(
                      value: 2,
                      child: Text("5 min"),
                    ),
                    DropdownMenuItem<int>(
                      value: 3,
                      child: Text("15 min"),
                    ),
                    DropdownMenuItem<int>(
                      value: 4,
                      child: Text("30 min"),
                    ),
                    DropdownMenuItem<int>(
                      value: 5,
                      child: Text("1 hour"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 0),
                decoration: BoxDecoration(
                  color: ConstantColors.inputColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  autocorrect: false,
                  controller: mqttEndPointController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    hintText: 'Enter MQTT End Point',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 0),
                decoration: BoxDecoration(
                  color: ConstantColors.inputColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  autocorrect: false,
                  controller: mqttPortController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    hintText: 'Enter MQTT Port',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 0),
                decoration: BoxDecoration(
                  color: ConstantColors.inputColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  autocorrect: false,
                  controller: mqttPublishTopicController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    hintText: 'Enter Publish Topic',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 0),
                decoration: BoxDecoration(
                  color: ConstantColors.inputColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  autocorrect: false,
                  controller: mqttSubscribeTopicController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    hintText: 'Enter Subscribe Topic',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 0),
                decoration: BoxDecoration(
                  color: ConstantColors.inputColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  autocorrect: false,
                  controller: wifiSSIDController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    hintText: 'Enter Wi-Fi SSID',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 0),
                decoration: BoxDecoration(
                  color: ConstantColors.inputColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  autocorrect: false,
                  controller: wifiPasswordController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    hintText: 'Enter Wi-Fi Password',
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: RoundedButton(
                    onPressed: sendConfigurationPackage,
                    text: "Save",
                    backgroundColor: ConstantColors.borderButtonColor,
                    textColor: ConstantColors.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
