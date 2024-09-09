// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/model/country_data.dart';
import 'package:enavatek_mobile/screen/device_details/power_statistics.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({Key? key}) : super(key: key);

  @override
  CountryScreenState createState() => CountryScreenState();
}

class CountryScreenState extends State<CountryScreen> {
  List<CountryData> countryList = [];
  ValueNotifier<String> currencyCodeNotifier = ValueNotifier<String>("SGD");

  @override
  void initState() {
    super.initState();
    fetchCountry();
  }

  Future<void> getCountryCurrency(String countryCode) async {
    final response = await http
        .get(Uri.parse('https://restcountries.com/v3.1/alpha/$countryCode'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Check if the data contains the 'currencies' field
      if (data.isNotEmpty && data[0].containsKey('currencies')) {
        final currencies = data[0]['currencies'];

        // Loop through the currencies map to get details
        currencies.forEach((code, details) {
          final name = details['name'];
          final symbol = details['symbol'];
          currencyCodeNotifier.value = code;
          print('Currency Code: $code');
          print('Currency Name: $name');
          print('Currency Symbol: $symbol');
        });
      } else {
        print('Currency information not found');
      }
    } else {
      print('Failed to load country data');
    }
  }

  Future<void> fetchCountry() async {
    try {
      String? authToken = await SharedPreferencesHelper.instance.getAuthToken();

      final data = await RemoteServices.fetchCountryList(token: authToken!);
      print(data);
      setState(() {
        countryList = data;
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  void showDeleteDialog(BuildContext context, int countryId) {
    Future<void> deleteCountry() async {
      String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
      print(authToken);
      var response = await RemoteServices.deleteCountry(
        authToken!,
        countryId,
      );
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data.containsKey("message")) {
          String message = data["message"];
          SnackbarHelper.showSnackBar(context, message);
          Navigator.pop(context);
          fetchCountry();
        }
      } else {
        SnackbarHelper.showSnackBar(context, "Failed to create country");
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final double screenWidth = MediaQuery.of(context).size.width;
        return AlertDialog(
          backgroundColor: ConstantColors.whiteColor,
          content: Text(
            'Are you sure want to delete this country?',
            style: GoogleFonts.roboto(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: ConstantColors.mainlyTextColor),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: ConstantColors.whiteColor,
                      backgroundColor: ConstantColors.lightBlueColor,
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
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.roboto(fontSize: screenWidth * 0.035),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: ConstantColors.lightBlueColor,
                      backgroundColor: ConstantColors.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      side: const BorderSide(
                        color: ConstantColors.borderButtonColor,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    onPressed: () async {
                      deleteCountry();
                    },
                    child: Text(
                      "Delete",
                      style: GoogleFonts.roboto(fontSize: screenWidth * 0.035),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> countryAddUpdateDialog(
      CountryData country, String status) async {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    Future<void> createCountry(String countryName, String currencyType,
        double energyRate, double factor, double temperature) async {
      String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
      print(authToken);
      Response response = await RemoteServices.createCountry(
          authToken!,
          status == "update" ? country.id : 0,
          countryName,
          currencyType,
          energyRate,
          factor,
          temperature);
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data.containsKey("message")) {
          String message = data["message"];
          SnackbarHelper.showSnackBar(context, message);
          Navigator.pop(context);
          fetchCountry();
        }
      } else {
        SnackbarHelper.showSnackBar(context, "Failed to create country");
      }
    }

    String currency = "";
    TextEditingController countryController =
        TextEditingController(text: status == "update" ? country.name : "");
    TextEditingController energyController = TextEditingController(
        text: status == "update" ? country.energyRate.toString() : "");
    TextEditingController temperatureController = TextEditingController(
        text: status == "update" ? country.temperature.toString() : "");
    TextEditingController factorController = TextEditingController(
        text: status == "update" ? country.factor.toString() : "");

    return showDialog(
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              contentPadding: EdgeInsets.zero,
              insetPadding: const EdgeInsets.all(14),
              actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              actions: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.82,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            status == "create"
                                ? 'Create Country'
                                : "Update Country",
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ConstantColors.appColor,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.close),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Divider(
                          thickness: 1,
                          color: ConstantColors.appColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 0,
                          top: isTablet ? 20 : 0,
                          bottom: isTablet ? 20 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: ConstantColors.inputColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: false,
                              onSelect: (Country country) {
                                countryController.text = country.name;
                                currency = country.countryCode;
                                getCountryCurrency(currency);
                              },
                            );
                          },
                          controller: countryController,
                          autocorrect: false,
                          readOnly: true,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.expand_more,
                              size: screenWidth * 0.05,
                              color: ConstantColors.mainlyTextColor,
                            ),
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.roboto(
                              fontSize: screenWidth * 0.04,
                            ),
                            hintText: 'Select Country',
                          ),
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 0,
                          top: isTablet ? 20 : 0,
                          bottom: isTablet ? 20 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: ConstantColors.inputColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ValueListenableBuilder<String>(
                          valueListenable: currencyCodeNotifier,
                          builder: (context, currencyCode, child) {
                            return TextField(
                              controller: energyController,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: Text(
                                    '$currencyCode | ',
                                    style: GoogleFonts.roboto(
                                      fontSize: screenWidth * 0.04,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                border: InputBorder.none,
                                hintStyle: GoogleFonts.roboto(
                                  fontSize: screenWidth * 0.04,
                                ),
                                hintText: 'Energy rate',
                                label: const Text(
                                  "Energy rate",
                                ),
                              ),
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 0,
                          top: isTablet ? 20 : 0,
                          bottom: isTablet ? 10 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: ConstantColors.inputColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: temperatureController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.roboto(
                              fontSize: screenWidth * 0.04,
                            ),
                            hintText: 'Temperature',
                            label: const Text(
                              "Temperature",
                            ),
                          ),
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 0,
                          top: isTablet ? 20 : 0,
                          bottom: isTablet ? 10 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: ConstantColors.inputColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: factorController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          textAlignVertical: TextAlignVertical.center,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.roboto(
                              fontSize: screenWidth * 0.04,
                            ),
                            hintText: 'Factor',
                            label: const Text(
                              "Factor",
                            ),
                          ),
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      RoundedButton(
                          text: status == "update" ? "Update" : "Create",
                          backgroundColor: ConstantColors.borderButtonColor,
                          textColor: ConstantColors.whiteColor,
                          onPressed: () {
                            if (countryController.text.isEmpty) {
                              SnackbarHelper.showSnackBar(
                                  context, "Please select country");
                            } else if (energyController.text.isEmpty) {
                              SnackbarHelper.showSnackBar(
                                  context, "Please enter energy rate");
                            } else if (temperatureController.text.isEmpty) {
                              SnackbarHelper.showSnackBar(
                                  context, "Please enter temperature");
                            } else if (factorController.text.isEmpty) {
                              SnackbarHelper.showSnackBar(
                                  context, "Please enter factor");
                            } else {
                              double? energyRate =
                                  double.tryParse(energyController.text);
                              double? temperature =
                                  double.tryParse(temperatureController.text);
                              double? factor =
                                  double.tryParse(factorController.text);
                              createCountry(countryController.text, currency,
                                  energyRate!, factor!, temperature!);
                            }
                          }),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth >= 600;

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
                        'Country',
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
          MaterialButton(
            onPressed: () {
              countryAddUpdateDialog(
                  CountryData(
                      id: 0,
                      currencyType: "",
                      energyRate: 0,
                      factor: 0,
                      name: "",
                      temperature: 0),
                  "create");
            },
            color: ConstantColors.whiteColor,
            textColor: Colors.white,
            minWidth: isTablet ? 0.04 * screenWidth : 0.035 * screenWidth,
            height: isTablet ? 0.04 * screenHeight : 0.035 * screenHeight,
            shape: const CircleBorder(
              side: BorderSide(
                color: ConstantColors.borderButtonColor,
                width: 2,
              ),
            ),
            child: Image.asset(
              ImgPath.pngPlus,
              width: isTablet ? 0.03 * screenWidth : 0.03 * screenWidth,
              height: isTablet ? 0.03 * screenHeight : 0.03 * screenHeight,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
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
            SizedBox(
              height: screenHeight * 0.02,
            ),
            ListView.builder(
              itemCount: countryList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final country = countryList[index];

                return Container(
                  margin: EdgeInsets.only(
                    bottom:
                        isTablet ? 0.03 * screenHeight : 0.03 * screenHeight,
                  ),
                  decoration: BoxDecoration(
                    color: ConstantColors.whiteColor,
                    borderRadius: BorderRadius.circular(0.1 * screenHeight),
                  ),
                  child: Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: isTablet ? 30 : 0,
                        bottom: isTablet ? 30 : 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            country.name,
                            style: GoogleFonts.roboto(
                              color: ConstantColors.mainlyTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                          Row(
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  getCountryCurrency(country.currencyType);
                                  countryAddUpdateDialog(country, "update");
                                },
                                color: ConstantColors.whiteColor,
                                textColor: Colors.white,
                                minWidth: isTablet
                                    ? 0.04 * screenWidth
                                    : 0.03 * screenWidth,
                                height: isTablet
                                    ? 0.04 * screenHeight
                                    : 0.03 * screenHeight,
                                shape: const CircleBorder(
                                  side: BorderSide(
                                    color: ConstantColors.borderButtonColor,
                                    width: 2,
                                  ),
                                ),
                                child: Image.asset(
                                  ImgPath.pngEdit,
                                  width: isTablet
                                      ? 0.03 * screenWidth
                                      : 0.025 * screenWidth,
                                  height: isTablet
                                      ? 0.03 * screenHeight
                                      : 0.02 * screenHeight,
                                  color: ConstantColors.lightBlueColor,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  showDeleteDialog(context, country.id);
                                },
                                color: ConstantColors.orangeColor,
                                textColor: Colors.white,
                                minWidth: isTablet
                                    ? 0.04 * screenWidth
                                    : 0.03 * screenWidth,
                                height: isTablet
                                    ? 0.04 * screenHeight
                                    : 0.03 * screenHeight,
                                shape: const CircleBorder(
                                  side: BorderSide(
                                    color: ConstantColors.orangeColor,
                                    width: 2,
                                  ),
                                ),
                                child: Image.asset(
                                  ImgPath.pngDelete,
                                  width: isTablet
                                      ? 0.03 * screenWidth
                                      : 0.025 * screenWidth,
                                  height: isTablet
                                      ? 0.03 * screenHeight
                                      : 0.025 * screenHeight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
