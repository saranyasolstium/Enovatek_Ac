// ignore_for_file: use_build_context_synchronously

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/screen/add_device/add_building.dart';
import 'package:enavatek_mobile/screen/add_device/device_assign/device_assigning.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/decoration.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicDetailScreen extends StatefulWidget {
  final String deviceSerialNo;
  final int buildingID;
  final String buildingName;
  const BasicDetailScreen(
      {Key? key,
      required this.deviceSerialNo,
      required this.buildingID,
      required this.buildingName})
      : super(key: key);

  @override
  BasicDetailScreenState createState() => BasicDetailScreenState();
}

class BasicDetailScreenState extends State<BasicDetailScreen> {
  TextEditingController bussinessUnitController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.deviceSerialNo);

    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      bottomNavigationBar: Footer(),
      body: SingleChildScrollView(
        child: Padding(
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
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Business Unit',
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: ConstantColors.mainlyTextColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: TextField(
                  controller: bussinessUnitController,
                  style: GoogleFonts.roboto(
                    color: ConstantColors.mainlyTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecorationStyle.textFieldDecoration(
                      placeholder: "Enter business unit", context: context),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Location',
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: ConstantColors.mainlyTextColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: TextField(
                  controller: locationController,
                  style: GoogleFonts.roboto(
                    color: ConstantColors.mainlyTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecorationStyle.textFieldDecoration(
                      placeholder: "Enter location", context: context),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Center(
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: RoundedButton(
                    onPressed: () async {
                      String bussinessUnit = bussinessUnitController.text;
                      String location = locationController.text;
                      if (bussinessUnit.isNotEmpty && location.isNotEmpty) {
                        if (widget.buildingID == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DeviceAddBuildingScreen(
                                      deviceSerialNo: widget.deviceSerialNo,
                                      bussiness: bussinessUnit,
                                      location: location,
                                    )),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DeviceAssigningScreen(
                                      buildingID: widget.buildingID,
                                      buildingName: widget.buildingName,
                                      deviceSerialNo: widget.deviceSerialNo,
                                      business: bussinessUnit,
                                      location: location,
                                    )),
                          );
                        }
                      } else {
                        SnackbarHelper.showSnackBar(
                            context, "Filed cannot be empty");
                      }
                    },
                    text: "Connect",
                    backgroundColor: ConstantColors.borderButtonColor,
                    textColor: ConstantColors.whiteColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
