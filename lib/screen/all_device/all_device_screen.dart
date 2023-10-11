import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AllDeviceScreen extends StatefulWidget {
  const AllDeviceScreen({Key? key}) : super(key: key);

  @override
  AllDeviceScreenState createState() => AllDeviceScreenState();
}

class AllDeviceScreenState extends State<AllDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                        'All 50 Devices',
                        style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ConstantColors.black),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.filter_alt_rounded,
                  color: ConstantColors.mainlyTextColor,
                  size: 30,
                ),
                const SizedBox(width: 20),
                const Icon(
                  Icons.search,
                  color: ConstantColors.mainlyTextColor,
                  size: 30,
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     const SizedBox(
            //       width: 80,
            //       child: RoundedButton(
            //         text: "All(50)",
            //         backgroundColor: ConstantColors.borderButtonColor,
            //         textColor: ConstantColors.whiteColor,
            //         naviagtionRoute: "",
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 10,
            //     ),
            //     const SizedBox(
            //       width: 90,
            //       child: RoundedButton(
            //         text: "Floor 1",
            //         backgroundColor: ConstantColors.whiteColor,
            //         textColor: ConstantColors.borderButtonColor,
            //         naviagtionRoute: "",
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 10,
            //     ),
            //     const SizedBox(
            //       width: 90,
            //       child: RoundedButton(
            //         text: "Floor 2",
            //         backgroundColor: ConstantColors.whiteColor,
            //         textColor: ConstantColors.borderButtonColor,
            //         naviagtionRoute: "",
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 10,
            //     ),
            //     MaterialButton(
            //       onPressed: () {},
            //       color: ConstantColors.whiteColor,
            //       textColor: Colors.white,
            //       minWidth: 20,
            //       height: 20,
            //       shape: const CircleBorder(
            //         side: BorderSide(
            //           color: ConstantColors.borderButtonColor,
            //           width: 2,
            //         ),
            //       ),
            //       child: Image.asset(
            //         ImgPath.pngPlus,
            //         height: 10,
            //         width: 10,
            //       ),
            //     ),
            //   ],
            // ),

            const CustomTile(
              floorName: 'Floor 1',
              status: 'off',
              mode: "-",
            ),
            const CustomTile(
              floorName: 'Unassigned',
              status: '24° C',
              mode: "cool",
            ),
            const CustomTile(
              floorName: 'Floor 1',
              status: 'off',
              mode: "-",
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  final String floorName;
  final String status;
  final String mode;

  const CustomTile(
      {super.key,
      required this.floorName,
      required this.status,
      required this.mode});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Navigator.pushNamed(context, addDeviceRoute);
          Navigator.pushNamed(context, deviceDetailRoute);
        },
        child: Card(
          elevation: 10.0,
          child: Container(
              decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(50)),
              height: 150,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Device Name\n\n ',
                              style: GoogleFonts.roboto(
                                  color: ConstantColors.mainlyTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            TextSpan(
                              text: floorName,
                              style: GoogleFonts.roboto(
                                  color: ConstantColors.mainlyTextColor,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: ConstantColors.mainlyTextColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 0, top: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              const WidgetSpan(
                                child: Icon(
                                  CupertinoIcons.thermometer,
                                  color: ConstantColors.mainlyTextColor,
                                  size: 18,
                                ),
                              ),
                              TextSpan(
                                text: 'Temp\n',
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: ConstantColors.mainlyTextColor),
                              ),
                              const WidgetSpan(
                                child: SizedBox(
                                    width: 10), // Adjust the width as needed
                              ),
                              TextSpan(
                                text: status,
                                style: GoogleFonts.roboto(
                                    color: ConstantColors.mainlyTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              const WidgetSpan(
                                child: Icon(
                                  CupertinoIcons.clock,
                                  color: ConstantColors.mainlyTextColor,
                                  size: 15,
                                ),
                              ),
                              TextSpan(
                                text: 'Mobile\n',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  color: ConstantColors.mainlyTextColor,
                                ),
                              ),
                              TextSpan(
                                text: mode,
                                style: GoogleFonts.roboto(
                                    color: ConstantColors.mainlyTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        MaterialButton(
                          onPressed: () {},
                          color: ConstantColors.whiteColor,
                          textColor: Colors.white,
                          minWidth: 30,
                          height: 30,
                          shape: const CircleBorder(
                            side: BorderSide(
                              color: ConstantColors.borderButtonColor,
                              width: 2,
                            ),
                          ),
                          child: Image.asset(
                            ImgPath.pngPlus,
                            height: 15,
                            width: 15,
                          ),
                        ),
                        const SizedBox(width: 12),
                        MaterialButton(
                          onPressed: () {},
                          color: ConstantColors.whiteColor,
                          textColor: Colors.white,
                          minWidth: 30,
                          height: 30,
                          shape: const CircleBorder(
                            side: BorderSide(
                              color: ConstantColors.borderButtonColor,
                              width: 2,
                            ),
                          ),
                          child: Image.asset(
                            ImgPath.pngRemove,
                            height: 15,
                            width: 15,
                          ),
                        ),
                        const SizedBox(width: 12),
                        MaterialButton(
                          onPressed: () {},
                          color: status == 'off'
                              ? ConstantColors.orangeColor
                              : ConstantColors.greenColor,
                          textColor: Colors.white,
                          minWidth: 30,
                          height: 30,
                          shape: CircleBorder(
                            side: BorderSide(
                              color: status == 'off'
                                  ? ConstantColors.orangeColor
                                  : ConstantColors.greenColor,
                              width: 2,
                            ),
                          ),
                          child: const Icon(Icons.power_settings_new,
                              size: 20, color: ConstantColors.whiteColor),
                        )
                      ]),
                ),
              ])),
        ));
  }
}
