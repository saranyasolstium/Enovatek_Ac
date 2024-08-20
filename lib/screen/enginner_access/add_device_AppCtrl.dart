import 'dart:convert';
import 'dart:io';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';

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
  String frequency = "60";

  void sendConfigurationPackage() async {
    const String deviceIP = '192.6.6.6';
    const int devicePort = 8006;

    const String packageHead = 'C6F9G0';
    String deviceId = deviceIDController.text.toString();
    String deviceUID = deviceUIDController.text.toString();
    String syncFreqMin = frequency;
    String mqttEndPoint = mqttEndPointController.text.toString();
    String mqttPort = mqttPortController.text.toString();
    String mqttPublishTopic = mqttPublishTopicController.text.toString();
    String mqttSubscribeTopic = mqttSubscribeTopicController.text.toString();
    String wifiSSID = wifiSSIDController.text.toString();
    String wifiPassword = wifiPasswordController.text.toString();
    String packageEnd = 'E0N7D5';

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
          SnackbarHelper.showSnackBar(context,
              "Configuration has been successfully sent to the controller.");
          sendConfig();
        } else {
          print('Configuration failed.');
        }
      });
      await Future.delayed(const Duration(seconds: 2));
      await socket.close();
      print('Connection closed.');
    } catch (e) {
      print(e);
      SnackbarHelper.showSnackBar(context, 'Error sending configuration: $e');
      if (e is SocketException) {
        SnackbarHelper.showSnackBar(context, 'SocketException: ${e.message}');
      } else {
        SnackbarHelper.showSnackBar(context, 'Other exception: $e');
      }
    }
  }

  Future<void> sendConfig() async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    String deviceId = deviceIDController.text.toString();
    String deviceUID = deviceUIDController.text.toString();
    String syncFreqMin = frequency;
    String mqttEndPoint = mqttEndPointController.text.toString();
    String mqttPort = mqttPortController.text.toString();
    String mqttPublishTopic = mqttPublishTopicController.text.toString();
    String mqttSubscribeTopic = mqttSubscribeTopicController.text.toString();
    String wifiSSID = wifiSSIDController.text.toString();
    String wifiPassword = wifiPasswordController.text.toString();

    final response = await RemoteServices.sendConfiguration(
        authToken!,
        deviceId,
        deviceUID,
        syncFreqMin,
        mqttEndPoint,
        mqttPort,
        mqttPublishTopic,
        mqttSubscribeTopic,
        wifiSSID,
        wifiPassword,
        "",
        "");
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      String status = responseBody['status'];
      print('Status: $status');
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
      bottomNavigationBar: Footer(),
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
                      label: const Text(
                        "Device ID",
                      )),
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
                      label: const Text(
                        "UID",
                      )),
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
                      if (newValue == 1) {
                        frequency = "1";
                      } else if (newValue == 2) {
                        frequency = "5";
                      } else if (newValue == 3) {
                        frequency = "15";
                      } else if (newValue == 4) {
                        frequency = "30";
                      } else {
                        frequency = "60";
                      }
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
                      label: const Text(
                        "MQTT End Point",
                      )),
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
                      label: const Text(
                        "MQTT Port",
                      )),
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
                      label: const Text(
                        "MQTT Publish Topic",
                      )),
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
                      label: const Text(
                        "Subscribe Topic",
                      )),
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
                      label: const Text(
                        "Wi-Fi SSID",
                      )),
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
                      label: const Text(
                        "Wi-Fi Password",
                      )),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: RoundedButton(
                    onPressed: () {
                      String deviceId = deviceIDController.text.toString();
                      String deviceUID = deviceUIDController.text.toString();
                      String mqttEndPoint =
                          mqttEndPointController.text.toString();
                      String mqttPort = mqttPortController.text.toString();
                      String mqttPublishTopic =
                          mqttPublishTopicController.text.toString();
                      String mqttSubscribeTopic =
                          mqttSubscribeTopicController.text.toString();
                      String wifiSSID = wifiSSIDController.text.toString();
                      String wifiPassword =
                          wifiPasswordController.text.toString();
                      if (deviceId.isEmpty ||
                          deviceUID.isEmpty ||
                          mqttEndPoint.isEmpty ||
                          mqttPort.isEmpty ||
                          mqttPublishTopic.isEmpty ||
                          mqttSubscribeTopic.isEmpty ||
                          wifiPassword.isEmpty ||
                          wifiSSID.isEmpty) {
                        SnackbarHelper.showSnackBar(
                            context, "Please fill in all required fields.");
                      } else if (selectedFrequency == 0) {
                        SnackbarHelper.showSnackBar(
                            context, "Please select frequency");
                      } else {
                        sendConfigurationPackage();
                      }
                    },
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
