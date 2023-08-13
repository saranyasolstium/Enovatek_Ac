import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
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
                  'Notification',
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
            const CustomListTile(
              status: 'PROGRESS PENDING',
            ),
             const SizedBox(
              height: 20,
            ),
            const CustomListTile(
              status: 'REQUIRED MAINTENANCE',
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String status;

  const CustomListTile(
      {super.key,
      required this.status,});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      child: Container(
          decoration: BoxDecoration(
              color: ConstantColors.whiteColor,
              borderRadius: BorderRadius.circular(50)),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15,top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lorem building name',
                    style: GoogleFonts.roboto(
                        fontSize: 16, color: ConstantColors.black),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    color: ConstantColors.whiteColor,
                    minWidth: 30,
                    height: 30,
                    shape: const CircleBorder(
                      side: BorderSide(
                        color: ConstantColors.lightBlueColor,
                        width: 2,
                      ),
                    ),
                    child: const Icon(Icons.phone,
                        size: 20, color: ConstantColors.lightBlueColor),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, ),
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
                              fontSize: 14,
                              color: ConstantColors.mainlyTextColor,
                            ),
                          ),
                          const WidgetSpan(
                              child: SizedBox(
                            width: 20,
                          )),
                          const WidgetSpan(
                              child: Icon(
                            Icons.circle,
                            size: 8,
                            color: ConstantColors.mainlyTextColor,
                          )),
                          TextSpan(
                            text: ' 3 Aug 2023',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 20, top: 15),
              child: Align(alignment: Alignment.topLeft,
              child: Text(
                status,
                style: GoogleFonts.roboto(
                    color: ConstantColors.mainlyTextColor, fontSize: 14),
              ),)
              
              
            ),
          ])),
    );
  }
}
