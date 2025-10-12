// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class AddBuilding extends StatefulWidget {
  const AddBuilding({Key? key}) : super(key: key);

  @override
  AddBuildingState createState() => AddBuildingState();
}

class AddBuildingState extends State<AddBuilding> {
  TextEditingController buildingNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      bottomNavigationBar: const Footer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Image.asset(
                    ImgPath.pngArrowBack,
                    height: isTablet ? 40 : 22,
                    width: isTablet ? 40 : 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Add Building ',
                    style: GoogleFonts.roboto(
                        fontSize: isTablet ? 26 : 18,
                        fontWeight: FontWeight.bold,
                        color: ConstantColors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: buildingNameController,
                maxLines: 1,
                style: GoogleFonts.roboto(
                  color: ConstantColors.mainlyTextColor,
                  fontSize: isTablet ? screenWidth * 0.025 : screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  labelText: "Add building name",
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
                String buildingName = buildingNameController.text;

                if (buildingName.isEmpty) {
                  SnackbarHelper.showSnackBar(
                      context, "Please enter a building name");
                  return;
                }

                String? authToken =
                    await SharedPreferencesHelper.instance.getAuthToken();
                int? userId =
                    await SharedPreferencesHelper.instance.getUserID();
                int? userTypeId =
                    await SharedPreferencesHelper.instance.getUserTypeID();
                Response response = await RemoteServices.addBuildingName(
                    authToken!, buildingName, 0, userId!);
                var data = jsonDecode(response.body);

                if (response.statusCode == 200) {
                  if (data.containsKey("message")) {
                    String message = data["message"];
                    SnackbarHelper.showSnackBar(context, message);
                    await RemoteServices.createUserActivity(
                      userId: userId,
                      userTypeId: userTypeId!,
                      remarks:
                          'Success,MobileApp: Building created. name="$buildingName',
                      module: 'Building',
                      action: 'create',
                      bearerToken: authToken,
                    );
                  }
                  Navigator.pop(context);
                } else {
                  if (data.containsKey("message")) {
                    String errorMessage = data["message"];
                    SnackbarHelper.showSnackBar(context, errorMessage);
                    await RemoteServices.createUserActivity(
                      userId: userId,
                      userTypeId: userTypeId!,
                      remarks:
                          'Failed,MobileApp: Building create FAILED. name="$buildingName',
                      module: 'Building',
                      action: 'create',
                      bearerToken: authToken,
                    );
                  }
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
