import 'package:enavatek_mobile/screen/device_details/schedule_list.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/dialog_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

class SheduleScreen extends StatefulWidget {
  const SheduleScreen({Key? key}) : super(key: key);

  @override
  SheduleScreenState createState() => SheduleScreenState();
}

class SheduleScreenState extends State<SheduleScreen> {
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
                  'Schedule',
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
                          'Turn on',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.mainlyTextColor,
                              fontSize: 16),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: ConstantColors.mainlyTextColor,
                          size: 20,
                        ),
                        const SizedBox(
                            height: 20,
                            child: VerticalDivider(
                              color: ConstantColors.mainlyTextColor,
                              thickness: 2,
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        GFToggle(
                          onChanged: (val) {},
                          value: true,
                          enabledThumbColor: ConstantColors.whiteColor,
                          enabledTrackColor: ConstantColors.lightBlueColor,
                          type: GFToggleType.ios,
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Divider(thickness: 1),
                    ),
                    Row(
                      children: [
                        Text(
                          'Turn Off',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.mainlyTextColor,
                              fontSize: 16),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: ConstantColors.mainlyTextColor,
                          size: 20,
                        ),
                        const SizedBox(
                            height: 20,
                            child: VerticalDivider(
                              color: ConstantColors.mainlyTextColor,
                              thickness: 2,
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        GFToggle(
                          onChanged: (val) {},
                          value: true,
                          enabledThumbColor: ConstantColors.whiteColor,
                          enabledTrackColor: ConstantColors.lightBlueColor,
                          type: GFToggleType.ios,
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Divider(thickness: 1),
                    ),
                    Row(
                      children: [
                        Text(
                          'Sleep Timer',
                          style: GoogleFonts.roboto(
                              color: ConstantColors.mainlyTextColor,
                              fontSize: 16),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: ConstantColors.mainlyTextColor,
                          size: 20,
                        ),
                        const SizedBox(
                            height: 20,
                            child: VerticalDivider(
                              color: ConstantColors.mainlyTextColor,
                              thickness: 2,
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        GFToggle(
                          onChanged: (val) {},
                          value: true,
                          enabledThumbColor: ConstantColors.whiteColor,
                          enabledTrackColor: ConstantColors.lightBlueColor,
                          type: GFToggleType.ios,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Repeat Schedule',
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                    color: ConstantColors.mainlyTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ExpansionPanelList(
              elevation: 1,
              expandedHeaderPadding: const EdgeInsets.all(0),
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  data[index].isExpanded = !isExpanded;
                });
              },
              children: data.map<ExpansionPanel>((SheduleItem item) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return CustomExpansionPanelHeader(
                      headerText: item.header,
                      onTap: () {
                        setState(() {
                          item.isExpanded = !item.isExpanded;
                        });
                      },
                    );
                  },
                  body: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: item.schedules.map<Widget>((schedule) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Text(
                                schedule,
                                style: GoogleFonts.roboto(
                                    color: ConstantColors.mainlyTextColor,
                                    fontSize: 16),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: ConstantColors.mainlyTextColor,
                                size: 20,
                              ),
                              const SizedBox(
                                  height: 20,
                                  child: VerticalDivider(
                                    color: ConstantColors.mainlyTextColor,
                                    thickness: 2,
                                  )),
                              const SizedBox(
                                width: 5,
                              ),
                              GFToggle(
                                onChanged: (val) {},
                                value: true,
                                enabledThumbColor: ConstantColors.whiteColor,
                                enabledTrackColor:
                                    ConstantColors.lightBlueColor,
                                type: GFToggleType.ios,
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  isExpanded: item.isExpanded,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomExpansionPanelHeader extends StatelessWidget {
  final String headerText;
  final VoidCallback onTap;

  const CustomExpansionPanelHeader(
      {super.key, required this.headerText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: onTap,
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                headerText,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              MaterialButton(
                onPressed: () {
                  showTimePickerSpinnerDialog(context);
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
          )),
    );
  }
}
