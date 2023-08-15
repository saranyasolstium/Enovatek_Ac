import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

class DeviceDetailScreen extends StatefulWidget {
  const DeviceDetailScreen({Key? key}) : super(key: key);

  @override
  DeviceDetailScreenState createState() => DeviceDetailScreenState();
}

class DeviceDetailScreenState extends State<DeviceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: AppBar(
            backgroundColor: ConstantColors.backgroundColor,
            automaticallyImplyLeading: false, 
            elevation: 0.0, 
            title: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            ImgPath.pngArrowBack,
                            height: 25,
                            width: 25,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Devices',
                            style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.black),
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
                        ImgPath.pngEdit,
                        height: 10,
                        width: 10,
                        color: ConstantColors.lightBlueColor,
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
        child: Column(
          children: [
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Total Energy saving: ',
                      style: GoogleFonts.roboto(
                          color: ConstantColors.mainlyTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    TextSpan(
                      text: '80% ',
                      style: GoogleFonts.roboto(
                          color: ConstantColors.greenColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    const WidgetSpan(
                      child: SizedBox(
                        width: 10,
                      ),
                    ),
                    const WidgetSpan(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: ConstantColors.mainlyTextColor,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: const BoxDecoration(
                color: ConstantColors.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Instant Cool\n\n ',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          TextSpan(
                            text: 'Automatically turn off in 5 min',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    GFToggle(
                      onChanged: (val) {},
                      value: true,
                      enabledThumbColor: ConstantColors.whiteColor,
                      enabledTrackColor: ConstantColors.lightBlueColor,
                      type: GFToggleType.ios,
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 300,
              decoration: const BoxDecoration(
                color: ConstantColors.lightBlueColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: ConstantColors.whiteColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Fan Speed\n\n ',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          TextSpan(
                            text: 'Level 7',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 80),
                    MaterialButton(
                      onPressed: () {},
                      color: ConstantColors.whiteColor,
                      textColor: Colors.white,
                      minWidth: 40,
                      height: 40,
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
                        color: ConstantColors.lightBlueColor,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {},
                      color: ConstantColors.whiteColor,
                      textColor: Colors.white,
                      minWidth: 40,
                      height: 40,
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
                        color: ConstantColors.lightBlueColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: ConstantColors.whiteColor,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Mode',
                      style: GoogleFonts.roboto(
                          color: ConstantColors.mainlyTextColor, fontSize: 15),
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              ImgPath.pngAutoNew,
                              height: 12,
                              width: 12,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Auto',
                              style: GoogleFonts.roboto(
                                  color: ConstantColors.mainlyTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ]),
                      GFToggle(
                        onChanged: (val) {},
                        value: true,
                        enabledThumbColor: ConstantColors.whiteColor,
                        enabledTrackColor: ConstantColors.lightBlueColor,
                        type: GFToggleType.ios,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              ImgPath.pngCool,
                              height: 12,
                              width: 12,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Cool',
                              style: GoogleFonts.roboto(
                                  color: ConstantColors.mainlyTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ]),
                      GFToggle(
                        onChanged: (val) {},
                        value: true,
                        enabledThumbColor: ConstantColors.whiteColor,
                        enabledTrackColor: ConstantColors.lightBlueColor,
                        type: GFToggleType.ios,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              ImgPath.pngCoolDry,
                              height: 12,
                              width: 12,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Dry',
                              style: GoogleFonts.roboto(
                                  color: ConstantColors.mainlyTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ]),
                      GFToggle(
                        onChanged: (val) {},
                        value: true,
                        enabledThumbColor: ConstantColors.whiteColor,
                        enabledTrackColor: ConstantColors.lightBlueColor,
                        type: GFToggleType.ios,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              ImgPath.pngFan,
                              height: 12,
                              width: 12,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Fan',
                              style: GoogleFonts.roboto(
                                  color: ConstantColors.mainlyTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ]),
                      GFToggle(
                        onChanged: (val) {},
                        value: true,
                        enabledThumbColor: ConstantColors.whiteColor,
                        enabledTrackColor: ConstantColors.lightBlueColor,
                        type: GFToggleType.ios,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              ImgPath.pngSunny,
                              height: 12,
                              width: 12,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Heat',
                              style: GoogleFonts.roboto(
                                  color: ConstantColors.mainlyTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ]),
                      GFToggle(
                        onChanged: (val) {},
                        value: true,
                        enabledThumbColor: ConstantColors.whiteColor,
                        enabledTrackColor: ConstantColors.lightBlueColor,
                        type: GFToggleType.ios,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context, manualAddDevice);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: ConstantColors.whiteColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Adjust Swing ',
                        style: GoogleFonts.roboto(
                            color: ConstantColors.mainlyTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: ConstantColors.mainlyTextColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                 Navigator.pushNamed(context, scheduleRoute);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: ConstantColors.whiteColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Schedule ',
                        style: GoogleFonts.roboto(
                            color: ConstantColors.mainlyTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: ConstantColors.mainlyTextColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: ConstantColors.whiteColor,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Additional Information',
                      style: GoogleFonts.roboto(
                          color: ConstantColors.mainlyTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Image.asset(
                                    ImgPath.pngThermometer,
                                    height: 12,
                                    width: 12,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(
                                    width: 8,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Room Temp\n',
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: ConstantColors.mainlyTextColor),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(
                                      width: 10), // Adjust the width as needed
                                ),
                                TextSpan(
                                  text: '28° C',
                                  style: GoogleFonts.roboto(
                                      color: ConstantColors.mainlyTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Image.asset(
                                    ImgPath.pngHumidity,
                                    height: 12,
                                    width: 12,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(
                                    width: 8,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Humidity\n',
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: ConstantColors.mainlyTextColor,
                                  ),
                                ),
                                TextSpan(
                                  text: '20%',
                                  style: GoogleFonts.roboto(
                                      color: ConstantColors.mainlyTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Image.asset(
                                    ImgPath.pngGrain,
                                    height: 12,
                                    width: 12,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(
                                    width: 8,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Air Quality\n',
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: ConstantColors.mainlyTextColor,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Good',
                                  style: GoogleFonts.roboto(
                                      color: ConstantColors.mainlyTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Image.asset(
                                    ImgPath.pngBuildIcon,
                                    height: 12,
                                    width: 12,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(
                                    width: 8,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Maintaince\n',
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: ConstantColors.mainlyTextColor),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(
                                      width: 10), // Adjust the width as needed
                                ),
                                TextSpan(
                                  text: 'Not required',
                                  style: GoogleFonts.roboto(
                                      color: ConstantColors.greenColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Image.asset(
                                    ImgPath.pngThermometer,
                                    height: 12,
                                    width: 12,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(
                                    width: 8,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Filter cleaning\n',
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: ConstantColors.mainlyTextColor,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Required',
                                  style: GoogleFonts.roboto(
                                      color: ConstantColors.orangeColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Image.asset(
                                    ImgPath.pngValumeUp,
                                    height: 12,
                                    width: 12,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(
                                    width: 8,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Noise Level\n',
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: ConstantColors.mainlyTextColor,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Normal',
                                  style: GoogleFonts.roboto(
                                      color: ConstantColors.yellowColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                //Navigator.pushNamed(context, manualAddDevice);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: ConstantColors.whiteColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Having any trouble?\n\n ',
                              style: GoogleFonts.roboto(
                                  color: ConstantColors.mainlyTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            TextSpan(
                              text:
                                  'Contact to our customer service',
                              style: GoogleFonts.roboto(
                                  color: ConstantColors.mainlyTextColor,
                                  fontSize: 13),
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
              ),
            ),

            const SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
