import 'package:country_pickers/country.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/add_device/add_device_screen.dart';
import 'package:enavatek_mobile/screen/all_device/all_device_screen.dart';
import 'package:enavatek_mobile/screen/device_details/power_statistics.dart';
import 'package:enavatek_mobile/screen/device_details/power_statistics/power_all_device_screen.dart';
import 'package:enavatek_mobile/screen/menu/country/country_screen.dart';
import 'package:enavatek_mobile/screen/menu/live_data.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/dynamic_font.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/dialog_logout.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  MenuScreenState createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    getUserDataFromSharedPreferences();
  }

  Future<void> getUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName');
      userEmail = prefs.getString('userEmail');
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth >= 600;
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      bottomNavigationBar: Footer(),
      appBar: AppBar(
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          ImgPath.pngArrowBack,
                          height: 22,
                          width: 22,
                          color: ConstantColors.appColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Menu',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ConstantColors.appColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
          isTablet ? 0.02 * screenHeight : 0.02 * screenHeight,
          isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
          isTablet ? 0.02 * screenHeight : 0.05 * screenHeight,
        ),
        child: Column(
          children: [
            // SizedBox(
            //   height: 0.05 * screenHeight,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: ConstantColors.inputColor,
                          borderRadius:
                              BorderRadius.circular(screenHeight * 0.05)),
                      width: screenWidth * 0.2,
                      height: screenHeight * 0.1,
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Image.asset(
                          ImgPath.pngPerson,
                          height: screenWidth * 0.08,
                          width: screenWidth * 0.08,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$userName\n\n',
                          style: GoogleFonts.roboto(
                            color: ConstantColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.042,
                          ),
                        ),
                        TextSpan(
                          text: userEmail,
                          style: GoogleFonts.roboto(
                            color: ConstantColors.mainlyTextColor,
                            fontSize: screenWidth * 0.042,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Icon(
                //   Icons.arrow_forward_ios,
                //   color: ConstantColors.mainlyTextColor,
                //   size: screenWidth * 0.07,
                // ),
              ],
            ),
            SizedBox(
              height: 0.02 * screenHeight,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              margin: EdgeInsets.all(
                screenWidth * 0.02,
              ),
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.05,
                screenHeight * 0.05,
                screenWidth * 0.05,
                screenHeight * 0.05,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddDeviceScreen(
                                  buildingID: 0,
                                  buildingName: "",
                                )),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          ImgPath.pngPlus,
                          height: screenWidth * 0.05,
                          width: screenWidth * 0.05,
                          color: ConstantColors.iconColr,
                        ),
                        SizedBox(
                          width: 0.02 * screenHeight,
                        ),
                        Text(
                          'Add Device',
                          style: GoogleFonts.roboto(
                              color: const Color.fromARGB(255, 7, 3, 3),
                              fontSize: screenWidth * 0.045),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.03 * screenHeight,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PowerStatisticsAllScreen(
                            isFilter: false,
                            businessUnits: [],
                            locationUnits: [],
                            roomUnits: [],
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.visibility,
                          size: screenWidth * 0.06,
                          color: ConstantColors.iconColr,
                        ),
                        SizedBox(
                          width: 0.02 * screenHeight,
                        ),
                        Text(
                          'View Device',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.black,
                              fontSize: screenWidth * 0.045),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.03 * screenHeight,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LiveDataScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          ImgPath.liveData,
                          height: screenWidth * 0.06,
                          width: screenWidth * 0.06,
                          color: ConstantColors.iconColr,
                        ),
                        SizedBox(
                          width: 0.02 * screenHeight,
                        ),
                        Text(
                          'Live data',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.black,
                              fontSize: screenWidth * 0.045),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.03 * screenHeight,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PowerStatisticsScreen(
                            deviceId: "",
                            deviceList: [],
                            tabIndex: 1,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          ImgPath.energyIcon,
                          height: screenWidth * 0.05,
                          width: screenWidth * 0.05,
                          color: ConstantColors.iconColr,
                        ),
                        SizedBox(
                          width: 0.02 * screenHeight,
                        ),
                        Text(
                          'Energy Saving',
                          style: GoogleFonts.roboto(
                              color: const Color.fromARGB(255, 7, 3, 3),
                              fontSize: screenWidth * 0.045),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.03 * screenHeight,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PowerStatisticsScreen(
                            deviceId: "",
                            deviceList: [],
                            tabIndex: 2,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          ImgPath.dollerSymbol,
                          height: screenWidth * 0.05,
                          width: screenWidth * 0.05,
                          color: ConstantColors.iconColr,
                        ),
                        SizedBox(
                          width: 0.02 * screenHeight,
                        ),
                        Text(
                          'S\$ Saving',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.black,
                              fontSize: screenWidth * 0.045),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.03 * screenHeight,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PowerStatisticsScreen(
                            deviceId: "",
                            deviceList: [],
                            tabIndex: 3,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          ImgPath.treeIcon,
                          height: screenWidth * 0.06,
                          width: screenWidth * 0.06,
                          color: ConstantColors.iconColr,
                        ),
                        SizedBox(
                          width: 0.02 * screenHeight,
                        ),
                        Text(
                          'Tree Planted',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.black,
                              fontSize: screenWidth * 0.045),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.03 * screenHeight,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CountryScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                          Container(
                            height: 25.dynamic,
                            width: 25.dynamic,
                            decoration: const BoxDecoration(
                              color: ConstantColors.iconColr,
                              shape: BoxShape.circle,
                            ),
                          ),
                        SizedBox(
                          width: 0.02 * screenHeight,
                        ),
                        Text(
                          'Manage Country',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.black,
                              fontSize: screenWidth * 0.045),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.03 * screenHeight,
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 0.03 * screenHeight,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, buildingRoute);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          ImgPath.pngApartment,
                          height: screenWidth * 0.06,
                          width: screenWidth * 0.06,
                        ),
                        SizedBox(
                          width: 0.02 * screenHeight,
                        ),
                        Text(
                          'Building',
                          style: GoogleFonts.roboto(
                              color: const Color.fromARGB(255, 7, 3, 3),
                              fontSize: screenWidth * 0.045),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.03 * screenHeight,
                  ),
                  GestureDetector(
                    onTap: () {
                     // Navigator.pushNamed(context, calculateRoute);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          ImgPath.pngSaving,
                          height: screenWidth * 0.06,
                          width: screenWidth * 0.06,
                        ),
                        SizedBox(
                          width: 0.02 * screenHeight,
                        ),
                        Text(
                          'Calculate saving',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.black,
                              fontSize: screenWidth * 0.045),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.03 * screenHeight,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        ImgPath.pngFaq,
                        height: screenWidth * 0.06,
                        width: screenWidth * 0.06,
                      ),
                      SizedBox(
                        width: 0.02 * screenHeight,
                      ),
                      Text(
                        'FAQ',
                        style: GoogleFonts.roboto(
                            color: ConstantColors.black,
                            fontSize: screenWidth * 0.045),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.03 * screenHeight,
                  ),
                  GestureDetector(
                    onTap: () {
                     // Navigator.pushNamed(context, supportRoute);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          ImgPath.pngSupport,
                          height: screenWidth * 0.06,
                          width: screenWidth * 0.06,
                        ),
                        SizedBox(
                          width: 0.02 * screenHeight,
                        ),
                        Text(
                          'Support',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.black,
                              fontSize: screenWidth * 0.045),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.03 * screenHeight,
                  ),
                  GestureDetector(
                    onTap: () {
                      //Navigator.pushNamed(context, requestRoute);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          ImgPath.pngGroup,
                          height: screenWidth * 0.06,
                          width: screenWidth * 0.06,
                        ),
                        SizedBox(
                          width: 0.02 * screenHeight,
                        ),
                        Text(
                          'Track Request',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.black,
                              fontSize: screenWidth * 0.045),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.03 * screenHeight,
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 0.03 * screenHeight,
                  ),
                  GestureDetector(
                    onTap: () {
                      showLogoutDialog(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          ImgPath.pngLogout,
                          height: screenWidth * 0.06,
                          width: screenWidth * 0.06,
                        ),
                        SizedBox(
                          width: 0.02 * screenHeight,
                        ),
                        Text(
                          'Log out',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.black,
                              fontSize: screenWidth * 0.045),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
