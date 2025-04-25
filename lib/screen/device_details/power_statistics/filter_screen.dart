import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/screen/all_device/all_device_screen.dart';
import 'package:enavatek_mobile/screen/all_device/devicelocation.dart';
import 'package:enavatek_mobile/screen/device_details/power_statistics.dart';
import 'package:enavatek_mobile/screen/device_details/power_statistics/power_all_device_screen.dart';
import 'package:enavatek_mobile/screen/menu/building/building.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    'solstium': false,
  };

  // Map for Locations
  Map<String, bool> locationUnits = {
    'singapore': false,
  };

  // Map for Floors
  Map<String, bool> roomUnits = {
    'Room 1': false,
  };

  List<Room> rooms = [];
  List<int> roomIds = [];

  void _clearAll() {
    setState(() {
      // Clear all selections
      businessUnits.updateAll((key, value) => false);
      locationUnits.updateAll((key, value) => false);
      roomUnits.updateAll((key, value) => false);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchBusinessUnitList();
    fetchLocationList();
    getRoomList();
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
        locationUnits = {
          for (var unit in data) (unit['location_name'] ?? ''): false
        };
      });
    } else {
      throw Exception('Failed to load business units');
    }
  }

  Future<void> getRoomList() async {
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

        // Populate the roomUnits map with floor names
        setState(() {
          rooms = getAllRooms(buildings);
          roomUnits = {for (var room in rooms) room.name: false};
        });

        // Optional: Print floor names to verify
        for (var room in rooms) {
          print('Floor ID: ${room.roomId}, Name: ${room.name}');
        }
      } else {
        print('Response body does not contain buildings');
      }
    } else {
      print('Response body: ${response.body}');
    }
  }

  int? getRoomIdByName(List<Room> rooms, String roomName) {
    for (var room in rooms) {
      if (room.name == roomName) {
        return room.roomId;
      }
    }
    return null;
  }

  List<int> getRoomIdsByNames(
      List<String> selectedRoomNames, List<Room> rooms) {
    print(selectedRoomNames);
    print(rooms);
    roomIds.clear();
    for (var roomName in selectedRoomNames) {
      int? roomId = getRoomIdByName(rooms, roomName);
      if (roomId != null) {
        roomIds.add(roomId);
      }
    }
    print(roomIds);
    return roomIds;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth >= 600;
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: ConstantColors.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const PowerStatisticsAllScreen(
                        isFilter: false,
                        businessUnits: [],
                        locationUnits: [],
                        roomUnits: [],
                      )),
            );
          },
          child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            child: Image.asset(
              ImgPath.pngArrowBack,
              height: isTablet ? 30 : 22,
              width: isTablet ? 30 : 22,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          'Filter',
          style: GoogleFonts.roboto(
            fontSize: isTablet ? screenWidth * 0.025 : screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: ConstantColors.appColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _clearAll,
            child: Text(
              'Clear all',
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontSize: isTablet ? screenWidth * 0.02 : screenWidth * 0.045,
                decoration: TextDecoration.underline,
              ),
            ),
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
            child: Icon(
              Icons.home,
              color: ConstantColors.iconColr,
              size: isTablet ? 40 : 30,
            ),
          ),
          const SizedBox(
            width: 20,
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
                          fontSize: isTablet ? 22 : 18,
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
                          fontSize: isTablet ? 22 : 18,
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
                        'Room',
                        style: TextStyle(
                          fontSize: isTablet ? 22 : 18,
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
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RoundedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PowerStatisticsAllScreen(
                            isFilter: false,
                            businessUnits: [],
                            locationUnits: [],
                            roomUnits: [],
                          )),
                );
              },
              text: "Close",
              backgroundColor: ConstantColors.whiteColor,
              textColor: ConstantColors.borderButtonColor,
            ),
            RoundedButton(
              onPressed: () {
                // Get selected Business Units
                List<String> selectedBusinessUnits = businessUnits.keys
                    .where((key) => businessUnits[key] == true)
                    .toList();

                // Get selected Locations
                List<String> selectedLocations = locationUnits.keys
                    .where((key) => locationUnits[key] == true)
                    .toList();

                // Get selected Rooms
                List<String> selectedRooms = roomUnits.keys
                    .where((key) => roomUnits[key] == true)
                    .toList();

                roomIds = getRoomIdsByNames(selectedRooms, rooms);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PowerStatisticsAllScreen(
                      isFilter: true,
                      businessUnits: selectedBusinessUnits,
                      locationUnits: selectedLocations,
                      roomUnits: roomIds,
                    ),
                  ),
                );
              },
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    List<Widget> checkboxList = [];

    if (selectedCategory == 'Business Unit') {
      checkboxList.addAll(
        businessUnits.keys.map((String key) {
          return CheckboxListTile(
            title: Text(
              key,
              style: TextStyle(fontSize: isTablet ? 22 : 18),
            ),
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
            title: Text(
              key,
              style: TextStyle(
                fontSize: isTablet ? 22 : 18,
              ),
            ),
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
        roomUnits.keys.map((String key) {
          return CheckboxListTile(
            title: Text(
              key,
              style: TextStyle(fontSize: isTablet ? 22 : 18),
            ),
            value: roomUnits[key],
            onChanged: (bool? value) {
              setState(() {
                roomUnits[key] = value!;
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
