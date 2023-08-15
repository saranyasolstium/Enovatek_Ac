import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/device_details/schedule_list.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeviceAssigningScreen extends StatefulWidget {
  const DeviceAssigningScreen({Key? key}) : super(key: key);

  @override
  DeviceAssigningScreenState createState() => DeviceAssigningScreenState();
}

class DeviceAssigningScreenState extends State<DeviceAssigningScreen> {
  final List<SheduleItem> data = [
    SheduleItem(
        header: 'Add schedule', schedules: ['schedule 1', 'schedule 2']),
  ];

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
                Image.asset(
                  ImgPath.pngArrowBack,
                  height: 25,
                  width: 25,
                ),
                const SizedBox(width: 10),
                Text(
                  'Device assigning',
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
            Text(
              'Lorem ipsum building',
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ConstantColors.black),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 5),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, editFloorNameRoute);
                      },
                      child: Row(
                        children: [
                          Text(
                            'Floor 1',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: ConstantColors.mainlyTextColor,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1),
                    Row(
                      children: [
                        Text(
                          'Floor 2',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.mainlyTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: ConstantColors.mainlyTextColor,
                          size: 18,
                        ),
                      ],
                    ),
                    const Divider(thickness: 1),
                    Row(
                      children: [
                        Text(
                          'Add Floor',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.mainlyTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        const Spacer(),
                        MaterialButton(
                          onPressed: () {
                            //showTimePickerSpinnerDialog(context);
                          },
                          color: ConstantColors.whiteColor,
                          textColor: Colors.white,
                          minWidth: 20,
                          height: 20,
                          shape: const CircleBorder(
                            side: BorderSide(
                              color: ConstantColors.borderButtonColor,
                              width: 2,
                            ),
                          ),
                          child: Image.asset(
                            ImgPath.pngPlus,
                            height: 10,
                            width: 10,
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 1),
                    Row(
                      children: [
                        Text(
                          'Add Room',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.mainlyTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        const Spacer(),
                        MaterialButton(
                          onPressed: () {},
                          color: ConstantColors.whiteColor,
                          textColor: Colors.white,
                          minWidth: 20,
                          height: 20,
                          shape: const CircleBorder(
                            side: BorderSide(
                              color: ConstantColors.borderButtonColor,
                              width: 2,
                            ),
                          ),
                          child: Image.asset(
                            ImgPath.pngPlus,
                            height: 10,
                            width: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 5, bottom: 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Add new building',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.mainlyTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        const Spacer(),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pushNamed(context, addFloorNameRoute);
                          },
                          color: ConstantColors.whiteColor,
                          textColor: Colors.white,
                          minWidth: 20,
                          height: 20,
                          shape: const CircleBorder(
                            side: BorderSide(
                              color: ConstantColors.borderButtonColor,
                              width: 2,
                            ),
                          ),
                          child: Image.asset(
                            ImgPath.pngPlus,
                            height: 10,
                            width: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
