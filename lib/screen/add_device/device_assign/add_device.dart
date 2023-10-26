// ignore_for_file: use_build_context_synchronously

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class AddDeviceName extends StatefulWidget {
  final List<Map<String, dynamic>> roomList;

  const AddDeviceName({Key? key, required this.roomList}) : super(key: key);

  @override
  AddDeviceNameState createState() => AddDeviceNameState();
}

class AddDeviceNameState extends State<AddDeviceName> {
  TextEditingController deviceNameController = TextEditingController();

  List<String> roomNames = [];
  List<String> roomIds = [];
  String? selectedRoomId;

  @override
  void initState() {
    super.initState();
    for (final floor in widget.roomList) {
      roomNames.add(floor['room_number']);
      roomIds.add(floor['id']);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    ImgPath.pngArrowBack,
                    height: 25,
                    width: 25,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Add Device',
                  style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ConstantColors.black),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedRoomId,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRoomId = newValue;
                  });
                },
                items: roomNames.asMap().entries.map((entry) {
                  final index = entry.key;
                  final floorName = entry.value;
                  final floorId = roomIds[index];
                  return DropdownMenuItem<String>(
                    value: floorId,
                    child: Text(floorName),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: deviceNameController,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: "Add device name",
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: ConstantColors.mainlyTextColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: ConstantColors.mainlyTextColor),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            RoundedButton(
              onPressed: () async {
                String deviceName = deviceNameController.text;

                if (deviceName.isEmpty) {
                  SnackbarHelper.showSnackBar(
                      context, "Please enter a device name");
                  return;
                }
                if (selectedRoomId == null) {
                  SnackbarHelper.showSnackBar(context, "Please select a room");
                  return;
                }
                print(selectedRoomId);
                String? authToken =
                    await SharedPreferencesHelper.instance.getAuthToken();
                Response response = await RemoteServices.createDevice(
                    authToken!, deviceName, selectedRoomId!);
                print(response.statusCode);
                if (response.statusCode == 201) {
                  SnackbarHelper.showSnackBar(
                      context, "device created successfully.'");
                  Navigator.pushReplacementNamed(context, deviceAssignRoute);
                } else {
                  SnackbarHelper.showSnackBar(
                      context, "Failed to create the device.Please try again!");
                }
              },
              text: "Add",
              backgroundColor: ConstantColors.borderButtonColor,
              textColor: ConstantColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
