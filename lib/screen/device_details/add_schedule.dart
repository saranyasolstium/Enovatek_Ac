import 'package:enavatek_mobile/screen/device_details/schedule_list.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/dialog_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

class AddSheduleScreen extends StatefulWidget {
  const AddSheduleScreen({Key? key}) : super(key: key);

  @override
  AddSheduleScreenState createState() => AddSheduleScreenState();
}

class AddSheduleScreenState extends State<AddSheduleScreen> {
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
                  'Add schedule',
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
              child: TextFormField(
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: "Add schedule name",
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
            Container(
              decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Turn On',
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
                    const Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Divider(thickness: 1),
                    ),
                    Row(
                      children: [
                        Text(
                          'Turn Off',
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
                    const Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Divider(thickness: 1),
                    ),
                    Row(
                      children: [
                        Text(
                          'Sleep Timer',
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
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
