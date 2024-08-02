import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      
      bottomNavigationBar: Footer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.05,
          screenHeight * 0.05,
          screenWidth * 0.05,
          screenHeight * 0.02,
        ),
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
                    height: screenWidth * 0.05,
                    width: screenWidth * 0.05,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Notification',
                  style: GoogleFonts.roboto(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: ConstantColors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 0.05 * screenHeight,
            ),
            CustomListTile(
              status: 'PROGRESS PENDING',
              screenWidth: screenWidth,
            ),
            SizedBox(
              height: 0.02 * screenHeight,
            ),
            CustomListTile(
              status: 'REQUIRED MAINTENANCE',
              screenWidth: screenWidth,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String status;
  final double screenWidth;

  const CustomListTile(
      {Key? key, required this.status, required this.screenWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth >= 600;
    return Card(
      elevation: 10.0,
      child: Container(
        decoration: BoxDecoration(
          color: ConstantColors.whiteColor,
          borderRadius: BorderRadius.circular(0.05 * screenWidth),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
                isTablet ? 0.05 * screenHeight : 0.02 * screenHeight,
                isTablet ? 0.05 * screenWidth : 0.03 * screenWidth,
                isTablet ? 0.05 * screenWidth : 0.02 * screenWidth,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lorem building name',
                    style: GoogleFonts.roboto(
                      fontSize: 0.04 * screenWidth,
                      color: ConstantColors.black,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    color: ConstantColors.whiteColor,
                    minWidth: 0.06 * screenWidth,
                    height: 0.06 * screenWidth,
                    shape: const CircleBorder(
                      side: BorderSide(
                        color: ConstantColors.lightBlueColor,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.phone,
                      size: 0.04 * screenWidth,
                      color: ConstantColors.lightBlueColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 0.05 * screenWidth,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Floor 1 - Device name',
                          style: GoogleFonts.roboto(
                            fontSize: 0.04 * screenWidth,
                            color: ConstantColors.mainlyTextColor,
                          ),
                        ),
                        WidgetSpan(
                          child: SizedBox(
                            width: 0.03 * screenWidth,
                          ),
                        ),
                        TextSpan(
                          text: ' 3 Aug 2023',
                          style: GoogleFonts.roboto(
                            color: ConstantColors.mainlyTextColor,
                            fontSize: 0.04 * screenWidth,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 0.05 * screenWidth,
                bottom: 0.05 * screenWidth,
                top: 0.03 * screenWidth,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  status,
                  style: GoogleFonts.roboto(
                    color: ConstantColors.mainlyTextColor,
                    fontSize: 0.035 * screenWidth,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
