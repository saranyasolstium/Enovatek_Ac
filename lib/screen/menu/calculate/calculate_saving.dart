import 'package:enavatek_mobile/screen/device_details/power_statistics.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalculateSavingScreen extends StatefulWidget {
  const CalculateSavingScreen({Key? key}) : super(key: key);

  @override
  CalculateSavingScreenState createState() => CalculateSavingScreenState();
}

class CalculateSavingScreenState extends State<CalculateSavingScreen> {
  int selectedCountry = 0;
  int selectTimeUse = 0;
  int selectTonnage = 0;

  double total = 0.0;
  String currencySymbol = "";

  TextEditingController dayController = TextEditingController();
  int _value = 0;

  void _increment() {
    setState(() {
      _value++;
      dayController.text = _value.toString();
    });
  }

  void _decrement() {
    setState(() {
      _value--;
      dayController.text = _value.toString();
    });
  }

  // Method to calculate the total based on selected values
  void calculateTotal() {
    double hours = selectTimeUse == 1 ? 8 * 0.80 : 24 * 0.60;

    double tonuse = 0.0;
    if (selectTonnage == 1) {
      tonuse = 0.62;
    } else if (selectTonnage == 2) {
      tonuse = 0.72;
    } else if (selectTonnage == 3) {
      tonuse = 0.79;
    } else if (selectTonnage == 4) {
      tonuse = 0.88;
    }

    double days = double.tryParse(dayController.text) ?? 0;

    if (selectedCountry == 1) {
      total = hours * tonuse * 0.28 * 52 * days;
      currencySymbol = "\$";
    } else if (selectedCountry == 2) {
      total = hours * tonuse * 4.2 * 52 * days;
      currencySymbol = "฿";
    } else if (selectedCountry == 3) {
      total = hours * tonuse * 1.05 * 52 * days;
      currencySymbol = "RM";
    } else if (selectedCountry == 4) {
      total = hours * tonuse * 12 * 52 * days;
      currencySymbol = "₱";
    }
  }

  void onProceedButtonPressed() {
    calculateTotal();

    if (selectedCountry == 0 ||
        selectTimeUse == 0 ||
        selectTonnage == 0 ||
        dayController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Please fill in all the required fields."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Total Calculation"),
            content: Text("Total: $currencySymbol${total.toStringAsFixed(2)}"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
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
                        'Calculate Saving',
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
        actions: [
        
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const PowerStatisticsScreen(
                    deviceId: "",
                    deviceList: [],
                    tabIndex: 1,
                  ),
                ),
                (Route<dynamic> route) => false,
              );
            },
            child: const Icon(
              Icons.home,
              color: ConstantColors.iconColr,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
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
            Center(
              child: Image.asset(
                ImgPath.pngIntro4,
                height: screenHeight * 0.35,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: ConstantColors.inputColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.roboto(fontSize: screenWidth * 0.04),
                  hintText: 'Select Country',
                ),
                value: selectedCountry,
                onChanged: (newValue) {
                  setState(() {
                    selectedCountry = newValue!;
                  });
                },
                icon: const Icon(
                  Icons.expand_more,
                  color: ConstantColors.mainlyTextColor,
                ),
                items: [
                  DropdownMenuItem<int>(
                    value: 0,
                    child: Text(
                      "Select Country",
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ),
                  const DropdownMenuItem<int>(
                    value: 1,
                    child: Text("Singapore"),
                  ),
                  const DropdownMenuItem<int>(
                    value: 2,
                    child: Text("Thailand"),
                  ),
                  const DropdownMenuItem<int>(
                    value: 3,
                    child: Text("Malaysia"),
                  ),
                  const DropdownMenuItem<int>(
                    value: 4,
                    child: Text("Philippines"),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                '      No. of days your facility use the Air Con',
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                    fontSize: screenWidth * 0.035,
                    color: ConstantColors.mainlyTextColor),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _decrement,
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: ConstantColors.lightBlueColor,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: dayController,
                    keyboardType: TextInputType.number,
                    onChanged: (newValue) {
                      setState(() {
                        _value = int.tryParse(newValue) ?? 0;
                      });
                    },
                  ),
                ),
                IconButton(
                  onPressed: _increment,
                  icon: const Icon(Icons.add_circle_outline_outlined,
                      color: ConstantColors.lightBlueColor, size: 30),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: ConstantColors.inputColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.roboto(
                    fontSize: screenWidth * 0.04,
                  ),
                  hintText: 'Select the timings of use',
                ),
                value: selectTimeUse,
                onChanged: (newValue) {
                  setState(() {
                    selectTimeUse = newValue!;
                  });
                },
                icon: const Icon(
                  Icons.expand_more,
                  color: ConstantColors.mainlyTextColor,
                ),
                items: [
                  DropdownMenuItem<int>(
                    value: 0,
                    child: Text(
                      "Select the timings of use",
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ),
                  const DropdownMenuItem<int>(
                    value: 1,
                    child: Text("9am - 5pm "),
                  ),
                  const DropdownMenuItem<int>(
                    value: 2,
                    child: Text("24 hours"),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: ConstantColors.inputColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.roboto(fontSize: screenWidth * 0.04),
                  hintText: 'Select the BTU/HP/Tonnage of your air con',
                ),
                value: selectTonnage,
                onChanged: (newValue) {
                  setState(() {
                    selectTonnage = newValue!;
                  });
                },
                icon: const Icon(
                  Icons.expand_more,
                  color: ConstantColors.mainlyTextColor,
                ),
                items: [
                  DropdownMenuItem<int>(
                    value: 0,
                    child: Text(
                      "Select the BTU/HP/Tonnage of your air con",
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ),
                  const DropdownMenuItem<int>(
                    value: 1,
                    child: Text("9000 Btu/1HP/0.75 Ton - 2.6 KW"),
                  ),
                  const DropdownMenuItem<int>(
                    value: 2,
                    child: Text("12000 Btu/1.5/1 Ton - 3.5 KW"),
                  ),
                  const DropdownMenuItem<int>(
                    value: 3,
                    child: Text("18000 Btu/2/1.5 Ton - 5.2 KW"),
                  ),
                  const DropdownMenuItem<int>(
                    value: 4,
                    child: Text("24000 Btu/3HP/2 Ton - 7.0 KW"),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ConstantColors.whiteColor,
                    backgroundColor: ConstantColors.borderButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    side: const BorderSide(
                      color: ConstantColors.borderButtonColor,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  onPressed: () {
                    onProceedButtonPressed();
                  },
                  child: Text(
                    "Proceed",
                    style: GoogleFonts.roboto(fontSize: screenWidth * 0.05),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
