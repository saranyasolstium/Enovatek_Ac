import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildingScreen extends StatefulWidget {
  const BuildingScreen({Key? key}) : super(key: key);

  @override
  BuildingScreenState createState() => BuildingScreenState();
}

class BuildingScreenState extends State<BuildingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
        child: Column(
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
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Building',
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
                  minWidth: 25,
                  height: 25,
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
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Lorem building name',
                      style: GoogleFonts.roboto(
                          color: ConstantColors.mainlyTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    const SizedBox(width: 60),
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
                        ImgPath.pngEdit,
                        height: 10,
                        width: 10,
                        color: ConstantColors.lightBlueColor,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {},
                      color: ConstantColors.orangeColor,
                      textColor: Colors.white,
                      minWidth: 20,
                      height: 20,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: ConstantColors.orangeColor,
                          width: 2,
                        ),
                      ),
                      child: Image.asset(
                        ImgPath.pngDelete,
                        height: 10,
                        width: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
           
           const SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                  color: ConstantColors.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Lorem building name',
                      style: GoogleFonts.roboto(
                          color: ConstantColors.mainlyTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    const SizedBox(width: 60),
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
                        ImgPath.pngEdit,
                        height: 10,
                        width: 10,
                        color: ConstantColors.lightBlueColor,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {},
                      color: ConstantColors.orangeColor,
                      textColor: Colors.white,
                      minWidth: 20,
                      height: 20,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: ConstantColors.orangeColor,
                          width: 2,
                        ),
                      ),
                      child: Image.asset(
                        ImgPath.pngDelete,
                        height: 10,
                        width: 10,
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
