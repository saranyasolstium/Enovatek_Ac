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

class AddRoomName extends StatefulWidget {
  final List<Map<String, dynamic>> floorList;

  const AddRoomName({Key? key, required this.floorList}) : super(key: key);

  @override
  AddRoomNameState createState() => AddRoomNameState();
}

class AddRoomNameState extends State<AddRoomName> {
  TextEditingController roomNameController = TextEditingController();

  List<String> floorNames = [];
  List<String> floorIds = [];
  String? selectedFloorId;

  @override
  void initState() {
    super.initState();
    for (final floor in widget.floorList) {
      floorNames.add(floor['floor_name']);
      floorIds.add(floor['id']);
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
                  'Add Room',
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
                value: selectedFloorId,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFloorId = newValue;
                  });
                },
                items: floorNames.asMap().entries.map((entry) {
                  final index = entry.key;
                  final floorName = entry.value;
                  final floorId = floorIds[index];
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
                controller: roomNameController,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: "Add Room name",
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
                String roomName = roomNameController.text;

                if (roomName.isEmpty) {
                  SnackbarHelper.showSnackBar(
                      context, "Please enter a room name");
                  return;
                }
                if (selectedFloorId == null) {
                  SnackbarHelper.showSnackBar(context, "Please select a floor");
                  return;
                }
                print(selectedFloorId);
                String? authToken =
                    await SharedPreferencesHelper.instance.getAuthToken();
                Response response = await RemoteServices.createRoom(
                    authToken!, roomName, selectedFloorId!);
                print(response.statusCode);
                if (response.statusCode == 201) {
                  SnackbarHelper.showSnackBar(
                      context, "room created successfully.'");
                  Navigator.pushReplacementNamed(context, deviceAssignRoute);
                } else {
                  SnackbarHelper.showSnackBar(
                      context, "Failed to create the room.Please try again!");
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
