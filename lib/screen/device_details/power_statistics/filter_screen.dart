import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/screen/all_device/devicelocation.dart';
import 'package:enavatek_mobile/screen/menu/building/building.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  FilterScreenState createState() => FilterScreenState();
}

class FilterScreenState extends State<FilterScreen> {
  // Track the currently selected label
  String selectedCategory = 'Business Unit';
  List<Building> buildings = [];

  // Example checkbox values
  Map<String, bool> businessUnits = {
    'Business Unit 1': false,
    'Business Unit 2': false,
    'Business Unit 3': false,
    'Business Unit 4': false,
    'Business Unit 5': false,
    'Business Unit 6': false,
  };

  // Map for Locations
  Map<String, bool> locationUnits = {
    'Location 1': false,
    'Location 2': false,
    'Location 3': false,
    'Location 4': false,
  };

  // Map for Floors
  Map<String, bool> floorUnits = {
    'Floor 1': false,
    'Floor 2': false,
    'Floor 3': false,
  };

  void _clearAll() {
    setState(() {
      // Clear all selections
      businessUnits.updateAll((key, value) => false);
      locationUnits.updateAll((key, value) => false);
      floorUnits.updateAll((key, value) => false);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchBusinessUnitList();
    fetchLocationList();
    getFloorList();
  }

  Future<void> fetchBusinessUnitList() async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    Response response = await RemoteServices.getBusinessUnit(authToken!);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];

      setState(() {
        businessUnits = {
          for (var unit in data) unit['business_unit_name']: false
        };
      });
    } else {
      throw Exception('Failed to load business units');
    }
  }

  Future<void> fetchLocationList() async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    Response response = await RemoteServices.getLocation(authToken!);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];

      setState(() {
        locationUnits = {for (var unit in data) unit['location_name']: false};
      });
    } else {
      throw Exception('Failed to load business units');
    }
  }

  Future<void> getFloorList() async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? userId = await SharedPreferencesHelper.instance.getUserID();
    print(authToken);

    Response response =
        await RemoteServices.getAllDeviceByUserId(authToken!, userId!);

    if (response.statusCode == 200) {
      String responseBody = response.body;
      Map<String, dynamic> jsonData = json.decode(responseBody);

      if (jsonData.containsKey("buildings")) {
        List<dynamic> buildingList = jsonData["buildings"];
        buildings =
            buildingList.map((data) => Building.fromJson(data)).toList();
        List<Floor> floors = getAllFloors(buildings);

        // Populate the floorUnits map with floor names
        setState(() {
          floorUnits = {for (var floor in floors) floor.name: false};
        });

        // Optional: Print floor names to verify
        for (var floor in floors) {
          print('Floor ID: ${floor.floorId}, Name: ${floor.name}');
        }
      } else {
        print('Response body does not contain buildings');
      }
    } else {
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: ConstantColors.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            child: Image.asset(
              ImgPath.pngArrowBack,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: const Text('Filter'),
        actions: [
          TextButton(
            onPressed: _clearAll,
            child: const Text(
              'Clear all',
              style: TextStyle(
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - Labels
            Expanded(
              flex: 2,
              child: Container(
                color: ConstantColors.darkBackgroundColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = 'Business Unit';
                        });
                      },
                      child: Text(
                        'Business Unit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: selectedCategory == 'Business Unit'
                              ? ConstantColors.iconColr
                              : ConstantColors.appColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = 'Location';
                        });
                      },
                      child: Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: selectedCategory == 'Location'
                              ? ConstantColors.iconColr
                              : ConstantColors.appColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = 'Floor';
                        });
                      },
                      child: Text(
                        'Floor',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: selectedCategory == 'Floor'
                              ? ConstantColors.iconColr
                              : ConstantColors.appColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Right side - ListView for checkboxes
            Expanded(
              flex: 4,
              child: ListView(
                children: _getCheckboxList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ConstantColors.backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RoundedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: "Close",
              backgroundColor: ConstantColors.whiteColor,
              textColor: ConstantColors.borderButtonColor,
            ),
            RoundedButton(
              onPressed: () {},
              text: "Apply",
              backgroundColor: ConstantColors.borderButtonColor,
              textColor: ConstantColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getCheckboxList() {
    List<Widget> checkboxList = [];

    if (selectedCategory == 'Business Unit') {
      checkboxList.addAll(
        businessUnits.keys.map((String key) {
          return CheckboxListTile(
            title: Text(key),
            value: businessUnits[key],
            onChanged: (bool? value) {
              setState(() {
                businessUnits[key] = value!;
              });
            },
            activeColor: ConstantColors.borderButtonColor,
          );
        }).toList(),
      );
    } else if (selectedCategory == 'Location') {
      checkboxList.addAll(
        locationUnits.keys.map((String key) {
          return CheckboxListTile(
            title: Text(key),
            value: locationUnits[key],
            onChanged: (bool? value) {
              setState(() {
                locationUnits[key] = value!;
              });
            },
            activeColor: ConstantColors.borderButtonColor,
          );
        }).toList(),
      );
    } else if (selectedCategory == 'Floor') {
      checkboxList.addAll(
        floorUnits.keys.map((String key) {
          return CheckboxListTile(
            title: Text(key),
            value: floorUnits[key],
            onChanged: (bool? value) {
              setState(() {
                floorUnits[key] = value!;
              });
            },
            activeColor: ConstantColors.borderButtonColor,
          );
        }).toList(),
      );
    }

    return checkboxList;
  }
}
