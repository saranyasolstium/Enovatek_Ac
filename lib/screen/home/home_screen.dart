import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
                  ImgPath.pngName,
                  height: 50,
                  width: 200,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, notificationRoute);
                        },
                        child: Image.asset(
                          ImgPath.pngNotifcation,
                          height: 30,
                          width: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, menuRoute);
                        },
                        child: Image.asset(
                          ImgPath.pngMenu,
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
                child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Hi,\n ',
                    style: GoogleFonts.roboto(
                        color: ConstantColors.mainlyTextColor, fontSize: 16),
                  ),
                  TextSpan(
                    text: 'Lorem Name',
                    style: GoogleFonts.roboto(
                        color: ConstantColors.mainlyTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ],
              ),
            )),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, allDeviceRoute);
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: ConstantColors.whiteColor,
                      borderRadius: BorderRadius.circular(30)),
                  height: 180,
                  child: Column(children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Lorem ipsum building',
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: ConstantColors.mainlyTextColor),
                          ),
                          const SizedBox(width: 20),
                          Image.asset(
                            ImgPath.pngAdd,
                            height: 25,
                            width: 25,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: ConstantColors.mainlyTextColor,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 10, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Device (10),\n ',
                                  style: GoogleFonts.roboto(
                                      color: ConstantColors.mainlyTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                TextSpan(
                                  text: 'Energy consumption: 1256 wh',
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
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Image.asset(
                                      ImgPath.pngThermometer,
                                      width: 12,
                                      height: 12,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Temp\n',
                                    style: GoogleFonts.roboto(
                                      color: ConstantColors.mainlyTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '    24° C',
                                    style: GoogleFonts.roboto(
                                      color: ConstantColors.mainlyTextColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Image.asset(
                                      ImgPath.pngAutoNew,
                                      width: 12,
                                      height: 12,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' Mobile\n',
                                    style: GoogleFonts.roboto(
                                      color: ConstantColors.mainlyTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '    Cool',
                                    style: GoogleFonts.roboto(
                                      color: ConstantColors.mainlyTextColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                            MaterialButton(
                              onPressed: () {},
                              color: ConstantColors.greenColor,
                              textColor: Colors.white,
                              minWidth: 30,
                              height: 30,
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: ConstantColors.greenColor,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(Icons.power_settings_new,
                                  size: 20, color: ConstantColors.whiteColor),
                            )
                          ]),
                    ),
                  ])),
            ),
            const SizedBox(
              height: 30,
            ),
            const Center(
              child: SizedBox(
                width: 150,
                height: 50,
                child: RoundedButton(
                  text: "Add Device",
                  backgroundColor: ConstantColors.borderButtonColor,
                  textColor: ConstantColors.whiteColor,
                  naviagtionRoute: addDeviceRoute,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
