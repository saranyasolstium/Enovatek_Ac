import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SavingDisplayScreen extends StatefulWidget {
  const SavingDisplayScreen({Key? key}) : super(key: key);

  @override
  SavingDisplayScreenState createState() => SavingDisplayScreenState();
}

class SavingDisplayScreenState extends State<SavingDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      bottomNavigationBar: Footer(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Image.asset(
                    ImgPath.pngArrowBack,
                    height: 25,
                    width: 25,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Calculate saving',
                    style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ConstantColors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                // ignore: prefer_adjacent_string_concatenation
                r'$50 saving per year' + '\n',
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: ConstantColors.mainlyTextColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                'As per saving and stats it looks good',
                style: GoogleFonts.roboto(
                    fontSize: 14, color: ConstantColors.mainlyTextColor),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      ImgPath.pngCelTower,
                      height: 40,
                      width: 30,
                    ),
                    const SizedBox(width: 20),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '8.7 Million\n\n',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          TextSpan(
                            text: 'KWH Saved per year',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      ImgPath.pngCo2,
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(width: 20),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '3.2 Million Kgs\n\n',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          TextSpan(
                            text: 'CO2 Avoided',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      ImgPath.pngDoller,
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(width: 20),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '50%\n\n',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          TextSpan(
                            text: 'Saving Achieved',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      ImgPath.pngSolar,
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(width: 20),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '5.9 MW\n\n',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          TextSpan(
                            text: 'Solar Installation',
                            style: GoogleFonts.roboto(
                                color: ConstantColors.mainlyTextColor,
                                fontSize: 13),
                          ),
                        ],
                      ),
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
