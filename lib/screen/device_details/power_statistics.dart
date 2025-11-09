import 'dart:async';
import 'dart:convert';

import 'package:country_flags/country_flags.dart';
import 'package:enavatek_mobile/app_state/app_state.dart';
import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/model/country_data.dart';
import 'package:enavatek_mobile/model/energy.dart';
import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/menu/building/building.dart';
import 'package:enavatek_mobile/screen/menu/live_data.dart';
import 'package:enavatek_mobile/services/push_notification_service.dart';
import 'dart:math' as math;
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/dynamic_font.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/dropdown.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:country_picker/country_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:money2/money2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

class PowerStatisticsScreen extends StatefulWidget {
  final String deviceId;
  final List<String> deviceList;
  final int tabIndex;

  const PowerStatisticsScreen({
    Key? key,
    required this.deviceId,
    required this.deviceList,
    required this.tabIndex,
  }) : super(key: key);

  @override
  PowerStatisticsScreenState createState() => PowerStatisticsScreenState();
}

class PowerStatisticsScreenState extends State<PowerStatisticsScreen>
    with TickerProviderStateMixin {
  String? totalPower = "", acPower = "", dcPower = "";

  Timer? timer;
  List<EnergyData> energyDataList = [];
  List<CountryData> countryList = [];

  String energyType = "intraday";
  String totalTree = "0";
  String totalSavings = "0";
  String totalEnergy = "0";

  String periodType = "day";
  ValueNotifier<bool> energyNotiifer = ValueNotifier(true);
  ValueNotifier<bool> treeNotiifer = ValueNotifier(false);
  ValueNotifier<bool> savingNotiifer = ValueNotifier(false);
  ValueNotifier<int> selectedTabIndex = ValueNotifier<int>(0);
  ValueNotifier<int> countryId = ValueNotifier<int>(6);
  ValueNotifier<String> currencyCodeNotifier = ValueNotifier<String>("SGD");
  ValueNotifier<String> currencySymbolNotifier = ValueNotifier<String>("\$");

  ValueNotifier<String> acEnergyNotif = ValueNotifier<String>("0kWh");
  ValueNotifier<String> dcEnergyNotif = ValueNotifier<String>("0kWh");
  ValueNotifier<String> totalEnergyNotif = ValueNotifier<String>("0kWh");

  ValueNotifier<double> acNotifier = ValueNotifier<double>(0);
  ValueNotifier<double> dcNotifier = ValueNotifier<double>(0);

  List<EnergyData> intradayList = [];

  List<Building> buildings = [];
  List<Device> devices = [];
  final List<String> deviceList = [];
  late AnimationController _animationController;
  late Animation<int> _animation;
  final int _numberOfArrows = 5;

  late AnimationController _blinkController;
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  String currentMonthFull = ""; // "October"

  @override
  void initState() {
    super.initState();

    getCountryCurrency(AppState().selectedCountryNotifier.value);
    getAllDevice();

    fetchCountry(false);

    if (widget.tabIndex == 1) {
      energyNotiifer.value = true;
      savingNotiifer.value = false;
      treeNotiifer.value = false;
      selectedTabIndex.value = 0;
      energyType = "intraday";
    } else if (widget.tabIndex == 2) {
      energyNotiifer.value = false;
      savingNotiifer.value = true;
      treeNotiifer.value = false;
      selectedTabIndex.value = 1;
      energyType = "day";
    } else if (widget.tabIndex == 3) {
      energyNotiifer.value = false;
      savingNotiifer.value = false;
      treeNotiifer.value = true;
      selectedTabIndex.value = 2;
      energyType = "day";
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: false);

    _animation = IntTween(begin: 0, end: _numberOfArrows - 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _blinkController.dispose();

    super.dispose();
  }

  List<Device> getAllDevices(List<Building> buildings) {
    List<Device> allDevices = [];
    for (var building in buildings) {
      for (var floor in building.floors) {
        for (var room in floor.rooms) {
          allDevices.addAll(room.devices);
        }
      }
    }

    return allDevices;
  }

  Future<void> getAllDevice() async {
    await FirebaseApi().initNotifications();

    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? userId = await SharedPreferencesHelper.instance.getUserID();

    Response response =
        await RemoteServices.getAllDeviceByUserId(authToken!, userId!);

    if (response.statusCode == 200) {
      String responseBody = response.body;
      Map<String, dynamic> jsonData = json.decode(responseBody);

      if (jsonData.containsKey("buildings")) {
        List<dynamic> buildingList = jsonData["buildings"];
        buildings =
            buildingList.map((data) => Building.fromJson(data)).toList();
        setState(() {
          devices = getAllDevices(buildings);
          deviceList.clear();
          deviceList.addAll(
            devices
                .where((device) => device.power.toLowerCase() == 'on')
                .map((device) => device.deviceId),
          );
        });
        deviceList.forEach((deviceId) {
          print('Device ID: $deviceId');
        });
        fetchCountry(false);
        powerusages();
        energyMonthusages();
        fetchData('intraday');
      } else {
        print('Response body does not contain buildings');
      }
    } else {
      print('Response body: ${response.body}');
    }
  }

  void updateTooltip() {
    setState(() {});
  }

  int getCountryIdByCurrencyType(String currencyType) {
    for (var country in countryList) {
      if (country.currencyType.toLowerCase() == currencyType.toLowerCase()) {
        print(country.id);
        return country.id;
      }
    }
    // Return default value if no country matches
    print('Currency type $currencyType not found, returning default value 6');
    return 6;
  }

  Future<void> fetchData(String periodType) async {
    try {
      energyDataList = [];
      getCountryCurrency(AppState().selectedCountryNotifier.value);

      int? userId = await SharedPreferencesHelper.instance.getUserID();
      int? countryId =
          getCountryIdByCurrencyType(AppState().selectedCountryNotifier.value);
      String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
      final data = await RemoteServices.fetchEnergyData(
          deviceId: deviceList,
          periodType: periodType.toLowerCase(),
          userId: userId!,
          countryId: countryId,
          authToken: authToken!);
      setState(() {
        energyDataList = data;

        totalTree =
            calculateTotalTreesPlanted(energyDataList).toStringAsFixed(2);
        totalSavings =
            calculateAverageSavings(energyDataList).toStringAsFixed(2);
        totalEnergy =
            calculateTotalEnergySaving(energyDataList).toStringAsFixed(2);
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  Widget monthlyEnergyTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "MTD Solar Energy : ${dcEnergyNotif.value}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          // const SizedBox(height: 12),

          // // Header Row (DC, AC, Total)
          // const Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Expanded(
          //       child: Row(
          //         children: [
          //           Text("Total Energy",
          //               style: TextStyle(
          //                   fontWeight: FontWeight.w600, fontSize: 14)),
          //         ],
          //       ),
          //     ),
          //     Expanded(
          //       child: Row(
          //         children: [
          //           Text("DC Energy",
          //               style: TextStyle(
          //                   fontWeight: FontWeight.w600, fontSize: 14)),
          //         ],
          //       ),
          //     ),
          //     Expanded(
          //       child: Row(
          //         children: [
          //           Text("AC Energy",
          //               style: TextStyle(
          //                   fontWeight: FontWeight.w600, fontSize: 14)),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),

          // const SizedBox(height: 8),

          // // Value Row (1654.2, 1423.4, 3077.6)
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Expanded(
          //       child: Text(totalEnergyNotif.value,
          //           style: const TextStyle(
          //               fontWeight: FontWeight.w700, fontSize: 15)),
          //     ),
          //     Expanded(
          //       child: Text(dcEnergyNotif.value,
          //           style: const TextStyle(
          //               fontWeight: FontWeight.w700, fontSize: 15)),
          //     ),
          //     Expanded(
          //       child: Text(acEnergyNotif.value,
          //           style: const TextStyle(
          //               fontWeight: FontWeight.w700, fontSize: 15)),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget buildGraph({
    required List<EnergyData> data,
    required BuildContext context,
    required double minY,
    required double maxY,
    required double interval,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Container(
      height: 350.dynamic,
      width: isTablet ? 1200.dynamic : 950.dynamic,
      child: SfCartesianChart(
        margin: const EdgeInsets.fromLTRB(30, 8, 8, 8),
        primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.H(),
          intervalType: DateTimeIntervalType.hours,
          interval: 1,
        ),
        primaryYAxis: NumericAxis(
          isVisible: false,
          minimum: minY,
          maximum: maxY,
          interval: interval,
          labelFormat: '{value}',
          title: AxisTitle(
            text: 'Energy Consumed (kWh)',
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: isTablet ? screenWidth * 0.018 : screenWidth * 0.030,
            ),
            alignment: ChartAlignment.center,
          ),
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          shared: true,
          tooltipPosition: TooltipPosition.auto,
        ),
        series: <CartesianSeries>[
          ColumnSeries<EnergyData, DateTime>(
            dataSource: data,
            xValueMapper: (EnergyData d, _) => d.getFormattedTimeAsDateTime(),
            yValueMapper: (EnergyData d, _) => d.acEnergyConsumed,
            name: 'AC Power',
            color: Colors.red,
            enableTooltip: true,
          ),
          ColumnSeries<EnergyData, DateTime>(
            dataSource: data,
            xValueMapper: (EnergyData d, _) => d.getFormattedTimeAsDateTime(),
            yValueMapper: (EnergyData d, _) => d.dcEnergyConsumed,
            name: 'DC Power',
            color: Colors.green,
            enableTooltip: true,
          ),
        ],
      ),
    );
  }

  Widget buildGraphy({
    required List<EnergyData> data,
    required BuildContext context,
    required double minY,
    required double maxY,
    required double interval,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Container(
      height: 350.dynamic,
      width: 80.dynamic,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        margin: EdgeInsets.zero,
        primaryXAxis: const DateTimeAxis(isVisible: false),
        primaryYAxis: NumericAxis(
          minimum: minY,
          maximum: maxY,
          interval: interval,
          labelFormat: '{value}',
          title: AxisTitle(
            text: 'Energy Consumed (kWh)',
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: isTablet ? screenWidth * 0.018 : screenWidth * 0.030,
            ),
          ),
        ),
        series: <CartesianSeries>[],
      ),
    );
  }

  Future<void> fetchCountry(bool status) async {
    try {
      String? authToken = await SharedPreferencesHelper.instance.getAuthToken();

      final data = await RemoteServices.fetchCountryList(token: authToken!);
      setState(() {
        countryList = data;
        fetchData(energyType);
        // if (status) {
        //   countrySelection();
        // }
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  String? getCurrencySymbol(String currencyCode) {
    try {
      final currency = Currencies().find(currencyCode);
      return currency?.symbol;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> getCountryCurrency(String countryCode) async {
    final response = await http
        .get(Uri.parse('https://restcountries.com/v3.1/alpha/$countryCode'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.isNotEmpty && data[0].containsKey('currencies')) {
        final currencies = data[0]['currencies'];

        currencies.forEach((code, details) {
          final name = details['name'];
          final symbol = details['symbol'];
          currencyCodeNotifier.value = code;
          setState(() {
            currencySymbolNotifier.value = getCurrencySymbol(code)!;
          });
          print('Currency Code: $code');
          print('Currency Name: $name');
          print('Currency Symbol1: ${currencySymbolNotifier.value}');
        });
      } else {
        print('Currency information not found');
      }
    } else {
      print('Failed to load country data');
    }
  }

  Future<void> energyMonthusages() async {
    currentMonthFull = months[DateTime.now().month - 1]; // "October"
    print("currentMonthFull $currentMonthFull");

    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? userId = await SharedPreferencesHelper.instance.getUserID();
    print('hjashhas ${deviceList.length}');
    final response = await RemoteServices.powerusages(
        authToken!, deviceList, "month", currentMonthFull, "all", userId!);
    print('response ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (!mounted) return;

      setState(() {
        // Extract numeric values for energy
        String totalEnergyStr = responseData['total_energy'] ?? "0 kWh";
        print(totalEnergyStr);
        String acEnergyStr = responseData['ac_energy'] ?? "0 kWh";
        print(acEnergyStr);
        String dcEnergyStr = responseData['dc_energy'] ?? "0 kWh";
        print(dcEnergyStr);

        acEnergyNotif.value = acEnergyStr;
        dcEnergyNotif.value = dcEnergyStr;

        totalEnergyNotif.value = totalEnergyStr;
      });
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('message') &&
          responseData['message'] == 'No record(s) found') {}
    }
  }

  Future<void> powerusages() async {
    DateTime currentDate = DateTime.now();
    String formattedDate =
        "${currentDate.day}-${currentDate.month}-${currentDate.year}";

    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();
    int? userId = await SharedPreferencesHelper.instance.getUserID();

    final response = await RemoteServices.powerusages(
        authToken!, deviceList, "day", formattedDate, "all", userId!);
    print('jdjjjs ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (!mounted) return;
      setState(() {
        totalPower = responseData['total_power'];
        print("saranya $totalPower");
        acPower = responseData['ac_power'];
        print("saranya $acPower");
        dcPower = responseData['dc_power'];
        print("saranya $dcPower");
        String acPowerValueStr = acPower!.replaceAll(RegExp(r'[^0-9.]'), '');
        String dcPowerValueStr = dcPower!.replaceAll(RegExp(r'[^0-9.]'), '');
        acNotifier.value = double.parse(acPowerValueStr);
        dcNotifier.value = double.parse(dcPowerValueStr);
      });
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('message') &&
          responseData['message'] == 'No record(s) found') {
        setState(() {
          totalPower = "0W";
          acPower = "0W";
          dcPower = "0W";
        });
      }
    }
  }

  double _ceilToStep(double x, double step) => (x / step).ceil() * step;

  double _scaledStep(double v) {
    final exp = (math.log(v) / math.ln10).floor();
    final k = math.max(0, exp - 1);
    return 5 * math.pow(10.0, k).toDouble();
  }

  double computeMaxY(double rawMax) {
    if (rawMax <= 0) return 1.0;
    if (rawMax < 0.1) return 0.1;

    final doubled = rawMax * 2.0;
    final step = _scaledStep(doubled);
    return _ceilToStep(doubled, step);
  }

  /// 4 ticks
  double computeInterval(double maxY) => maxY / 5.0;

  calculateTotalTreesPlanted(List<EnergyData> energyDataList) {
    double totalDcTree = 0.0;

    for (var data in energyDataList) {
      totalDcTree += data.treesPlanted;
    }
    setState(() {
      totalTree = totalDcTree.toString();
    });
    return totalDcTree;
  }

  double calculateAverageSavings(List<EnergyData> energyDataList) {
    if (energyDataList.isEmpty) {
      return 0.0;
    }
    double totalSaving =
        energyDataList.fold(0.0, (sum, data) => sum + data.energySaving);
    return totalSaving / energyDataList.length;
  }

  double calculateTotalEnergySaving(List<EnergyData> energyDataList) {
    if (energyDataList.isEmpty) {
      return 0.0;
    }

    double acMax = energyDataList.fold<double>(
        0.0,
        (max, data) =>
            data.acEnergyConsumed > max ? data.acEnergyConsumed : max);
    double dcMax = energyDataList.fold<double>(
        0.0,
        (max, data) =>
            data.dcEnergyConsumed > max ? data.dcEnergyConsumed : max);

    print(acMax);
    print(dcMax);

    double totalEnergy = acMax + dcMax;
    print(totalEnergy);

    if (totalEnergy == 0) {
      return 0.0;
    }

    double savingPercentage = (dcMax / totalEnergy) * 100;
    print(savingPercentage);

    return savingPercentage;
  }

  Future<void> countrySelection() async {
    // Keep the exact value (no uppercasing) so it matches list item values
    String radioValue = AppState().selectedCountryNotifier.value;

    return showDialog(
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            // Exclude any "Custom" option from the list entirely
            final List<CountryData> options = countryList.where((c) {
              final name = c.name.toLowerCase();
              final code = c.currencyType.toLowerCase();
              return name != 'custom' && code != 'custom';
            }).toList();

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
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Country',
                            style: GoogleFonts.roboto(
                              fontSize: 16.dynamic,
                              fontWeight: FontWeight.bold,
                              color: ConstantColors.appColor,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.dynamic),
                              child: const Icon(Icons.close),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.dynamic, bottom: 10.dynamic),
                        child: Divider(
                            thickness: 1.dynamic, color: Colors.black12),
                      ),

                      // Country Selection (whole row tappable)
                      ...options.map((country) {
                        final String value = country.currencyType;
                        return RadioListTile<String>(
                          value: value,
                          groupValue: radioValue,
                          onChanged: (v) => setState(() => radioValue = v!),
                          activeColor: ConstantColors.borderButtonColor,
                          selected: radioValue == value,
                          selectedTileColor: ConstantColors.borderButtonColor
                              .withOpacity(0.08),
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Row(
                            children: [
                              CountryFlag.fromCountryCode(
                                value.isNotEmpty ? value : "sg",
                                shape: const Circle(),
                                height: 25.dynamic,
                                width: 25.dynamic,
                              ),
                              SizedBox(width: 20.dynamic),
                              Expanded(
                                child: Text(
                                  country.name,
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.dynamic,
                                    color: ConstantColors.appColor,
                                    fontWeight: radioValue == value
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      SizedBox(height: 10.dynamic),

                      // Apply only (Custom removed)
                      RoundedButton(
                        text: "Apply",
                        backgroundColor: ConstantColors.borderButtonColor,
                        textColor: ConstantColors.whiteColor,
                        onPressed: () {
                          setState(() {
                            AppState().selectedCountryNotifier.value =
                                radioValue;
                            energyNotiifer.value = true;
                            savingNotiifer.value = false;
                            treeNotiifer.value = false;
                            selectedTabIndex.value = 0;
                            energyType = "intraday";
                          });
                          fetchData('intraday');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<void> exportCSV(
      String content, String fileName, BuildContext context) async {
    try {
      // Use a share-friendly folder
      final Directory dir = await getTemporaryDirectory();
      final String filePath = p.join(dir.path, fileName);

      final file = File(filePath);
      await file.writeAsString(content);

      // Open native share sheet (WhatsApp, Drive, Gmail, etc.)
      await Share.shareXFiles(
        [XFile(file.path, name: fileName, mimeType: 'text/csv')],
        subject: 'Power consumption data',
        text: 'Power consumption data ($fileName)',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saved & opened share sheet: $filePath')),
        );
      }
    } catch (e) {
      debugPrint('Export/share error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to export/share CSV')),
        );
      }
    }
  }

  Future<void> exportPowerConsumptionData() async {
    try {
      int? userId = await SharedPreferencesHelper.instance.getUserID();
      String? authToken = await SharedPreferencesHelper.instance.getAuthToken();

      var response = await RemoteServices().export(
          deviceId: widget.deviceList,
          periodType: energyType,
          userId: userId!,
          authToken: authToken!);

      if (response.statusCode == 200) {
        final csvContent = response.body;
        final fileName =
            'power_consumption_data_${DateFormat('dd_MM_yyyy').format(DateTime.now())}.csv';

        exportCSV(csvContent, fileName, context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to download CSV ')),
        );
      }
    } catch (e) {
      print('Error exporting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: ConstantColors.liveBgColor,
      bottomNavigationBar: const Footer(),
      appBar: AppBar(
        backgroundColor: ConstantColors.darkBackgroundColor,
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
                      SizedBox(width: isTablet ? 20.dynamic : 10.dynamic),
                      Text(
                        'Power Statistics',
                        style: GoogleFonts.roboto(
                          fontSize: isTablet
                              ? screenWidth * 0.025
                              : screenWidth * 0.045,
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
              // fetchCountry(true);
              countrySelection();
            },
            child: ValueListenableBuilder<String>(
              valueListenable: AppState().selectedCountryNotifier,
              builder: (context, value, child) {
                return CountryFlag.fromCountryCode(
                  value,
                  shape: const Circle(),
                  height: isTablet ? 40.dynamic : 30.dynamic,
                  width: isTablet ? 40.dynamic : 30.dynamic,
                );
              },
            ),
          ),
          const Icon(Icons.arrow_drop_down_sharp),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LiveDataScreen(),
                ),
              );
            },
            child: Image.asset(
              ImgPath.liveData,
              height: isTablet ? 60.dynamic : 30.dynamic,
              width: isTablet ? 60.dynamic : 30.dynamic,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, menuRoute);
            },
            child: Image.asset(
              ImgPath.pngMenu,
              height: isTablet ? 60.dynamic : 30.dynamic,
              width: isTablet ? 60.dynamic : 30.dynamic,
              color: ConstantColors.borderButtonColor,
            ),
          ),
          SizedBox(
            width: isTablet ? 30 : 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: ConstantColors.darkBackgroundColor,
              child: Column(
                children: [
                  SizedBox(
                    height: isTablet ? 40.dynamic : 10.dynamic,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              ImgPath.pngSolarPlane,
                              width: isTablet ? 250.dynamic : 40.dynamic,
                              height: 50.dynamic,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        ValueListenableBuilder<double>(
                          valueListenable: dcNotifier,
                          builder: (context, dcValue, child) {
                            return dcValue < 50
                                ? Row(
                                    children: List.generate(
                                    _numberOfArrows,
                                    (index) => AnimatedBuilder(
                                      animation: _animation,
                                      builder: (context, child) {
                                        bool isLit = index == _animation.value;
                                        bool shouldAnimate =
                                            dcValue > 0 && dcValue <= 50;
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 1),
                                          child: AnimatedOpacity(
                                            opacity: (dcValue == 0 ||
                                                    dcValue > 50 ||
                                                    !shouldAnimate)
                                                ? 0.7
                                                : (isLit ? 1.0 : 0.6),
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: Image.asset(
                                              dcValue > (index * 10)
                                                  ? ImgPath.leftArrow1
                                                  : ImgPath.leftArrow2,
                                              color: dcValue > (index * 10)
                                                  ? Colors.green
                                                  : Colors.green.shade300,
                                              height: isTablet ? 40 : 15,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ))
                                : Row(
                                    children: List.generate(
                                      _numberOfArrows,
                                      (index) => AnimatedBuilder(
                                        animation: _blinkController,
                                        builder: (context, child) {
                                          return AnimatedOpacity(
                                            opacity: _blinkController.value,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1),
                                              child: Image.asset(
                                                ImgPath.leftArrow1,
                                                height: isTablet ? 40 : 15,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                          },
                        ),
                        SizedBox(width: 20.dynamic),
                        Image.asset(
                          ImgPath.totalPower,
                          width: isTablet ? 250.dynamic : 40.dynamic,
                          height: 50.dynamic,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 20.dynamic),
                        ValueListenableBuilder<double>(
                          valueListenable: acNotifier,
                          builder: (context, acValue, child) {
                            return Row(
                              children: List.generate(_numberOfArrows, (index) {
                                return acValue >= 50
                                    ? AnimatedBuilder(
                                        animation: _blinkController,
                                        builder: (context, child) {
                                          String imagePath;

                                          if (index == 0) {
                                            imagePath = acValue > 40
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                          } else if (index == 1) {
                                            imagePath = acValue > 30
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                          } else if (index == 2) {
                                            imagePath = acValue > 20
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                          } else if (index == 3) {
                                            imagePath = acValue > 10
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                          } else {
                                            imagePath = acValue > 0
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                          }

                                          return AnimatedOpacity(
                                            opacity: _blinkController.value,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1),
                                              child: Image.asset(
                                                imagePath,
                                                height: isTablet ? 40 : 15,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : AnimatedBuilder(
                                        animation: _animation,
                                        builder: (context, child) {
                                          bool isLit =
                                              (_numberOfArrows - 1) - index ==
                                                  _animation.value;

                                          bool shouldAnimate =
                                              acValue > 0 && acValue <= 50;
                                          Color color;

                                          String imagePath;
                                          if (index == 0) {
                                            imagePath = acValue > 40
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                            color = acValue > 40
                                                ? Colors.red
                                                : Colors.red.shade300;
                                          } else if (index == 1) {
                                            imagePath = acValue > 30
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                            color = acValue > 30
                                                ? Colors.red
                                                : Colors.red.shade300;
                                          } else if (index == 2) {
                                            imagePath = acValue > 20
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                            color = acValue > 20
                                                ? Colors.red
                                                : Colors.red.shade300;
                                          } else if (index == 3) {
                                            imagePath = acValue > 10
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                            color = acValue > 10
                                                ? Colors.red
                                                : Colors.red.shade300;
                                          } else {
                                            imagePath = acValue > 0
                                                ? ImgPath.rightArrow5
                                                : ImgPath.rightArrow4;
                                            color = acValue > 0
                                                ? Colors.red
                                                : Colors.red.shade300;
                                          }

                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 1),
                                            child: AnimatedOpacity(
                                              opacity: (acValue == 0 ||
                                                      acValue > 50 ||
                                                      !shouldAnimate)
                                                  ? 0.7
                                                  : (isLit ? 1.0 : 0.6),
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              child: Image.asset(
                                                ImgPath.rightArrow5,
                                                height: isTablet ? 40 : 15,
                                                color: color,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                              }),
                            );
                          },
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              ImgPath.pngTower,
                              width: isTablet ? 250.dynamic : 50.dynamic,
                              height: 40.dynamic,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.dynamic),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'DC Power',
                              style: GoogleFonts.roboto(
                                fontSize: isTablet
                                    ? screenWidth * 0.022
                                    : screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.black,
                              ),
                            ),
                            SizedBox(height: 10.dynamic),
                            Text(
                              dcPower!,
                              style: GoogleFonts.roboto(
                                fontSize: isTablet
                                    ? screenWidth * 0.022
                                    : screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.appColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Total Power',
                              style: GoogleFonts.roboto(
                                fontSize: isTablet
                                    ? screenWidth * 0.022
                                    : screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.iconColr,
                              ),
                            ),
                            SizedBox(height: 10.dynamic),
                            Text(
                              totalPower!,
                              style: GoogleFonts.roboto(
                                fontSize: isTablet
                                    ? screenWidth * 0.022
                                    : screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.iconColr,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'AC Power',
                              style: GoogleFonts.roboto(
                                fontSize: isTablet
                                    ? screenWidth * 0.022
                                    : screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.appColor,
                              ),
                            ),
                            SizedBox(height: 10.dynamic),
                            Text(
                              acPower!,
                              style: GoogleFonts.roboto(
                                fontSize: isTablet
                                    ? screenWidth * 0.022
                                    : screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.appColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.dynamic),
                ],
              ),
            ),
            monthlyEnergyTable(),
            ValueListenableBuilder<int>(
              valueListenable: selectedTabIndex,
              builder: (context, value, child) {
                return Container(
                  color: ConstantColors.liveBgColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 100.dynamic : 15.dynamic,
                    vertical: 10.dynamic,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // --- Energy Saving ---
                        Container(
                          decoration: BoxDecoration(
                            color: value == 0
                                ? ConstantColors.borderButtonColor
                                    .withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: value == 0
                                  ? ConstantColors.borderButtonColor
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              selectedTabIndex.value = 0;
                              energyNotiifer.value = true;
                              treeNotiifer.value = false;
                              savingNotiifer.value = false;
                              setState(() => energyType = "intraday");
                              fetchData("intraday");
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(height: 10.dynamic),
                                Image.asset(
                                  ImgPath.energyIcon,
                                  width: isTablet ? 50.dynamic : 30.dynamic,
                                  height: isTablet ? 50.dynamic : 30.dynamic,
                                  fit: BoxFit.contain,
                                  color: value == 0
                                      ? ConstantColors.borderButtonColor
                                      : ConstantColors.appColor,
                                ),
                                SizedBox(height: 10.dynamic),
                                Text(
                                  'Energy Saving',
                                  style: GoogleFonts.roboto(
                                    fontSize: isTablet
                                        ? screenWidth * 0.02
                                        : screenWidth * 0.032,
                                    fontWeight: FontWeight.bold,
                                    color: ConstantColors.black,
                                  ),
                                ),
                                SizedBox(height: 10.dynamic),
                              ],
                            ),
                          ),
                        ),

                        // --- Currency ---
                        Container(
                          decoration: BoxDecoration(
                            color: value == 1
                                ? ConstantColors.borderButtonColor
                                    .withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: value == 1
                                  ? ConstantColors.borderButtonColor
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              selectedTabIndex.value = 1;
                              energyNotiifer.value = false;
                              treeNotiifer.value = false;
                              savingNotiifer.value = true;
                              setState(() => energyType = "day");
                              fetchData("day");
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 10.dynamic),
                                Text(
                                  currencySymbolNotifier.value == "\$"
                                      ? 'S${currencySymbolNotifier.value}'
                                      : currencySymbolNotifier.value,
                                  style: GoogleFonts.roboto(
                                    fontSize: isTablet ? 40 : 30,
                                    fontWeight: FontWeight.bold,
                                    color: value == 1
                                        ? ConstantColors.borderButtonColor
                                        : ConstantColors.appColor,
                                  ),
                                ),
                                Text(
                                  'Currency',
                                  style: GoogleFonts.roboto(
                                    fontSize: isTablet
                                        ? screenWidth * 0.022
                                        : screenWidth * 0.032,
                                    fontWeight: FontWeight.bold,
                                    color: ConstantColors.black,
                                  ),
                                ),
                                SizedBox(height: 10.dynamic),
                              ],
                            ),
                          ),
                        ),

                        // --- Tree Planted ---
                        Container(
                          decoration: BoxDecoration(
                            color: value == 2
                                ? ConstantColors.borderButtonColor
                                    .withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: value == 2
                                  ? ConstantColors.borderButtonColor
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              selectedTabIndex.value = 2;
                              energyNotiifer.value = false;
                              treeNotiifer.value = true;
                              savingNotiifer.value = false;
                              setState(() => energyType = "day");
                              fetchData("day");
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 10.dynamic),
                                Image.asset(
                                  ImgPath.treeIcon,
                                  width: isTablet ? 50.dynamic : 30.dynamic,
                                  height: isTablet ? 50.dynamic : 30.dynamic,
                                  fit: BoxFit.contain,
                                  color: value == 2
                                      ? ConstantColors.borderButtonColor
                                      : ConstantColors.appColor,
                                ),
                                SizedBox(height: 10.dynamic),
                                Text(
                                  'Tree Planted',
                                  style: GoogleFonts.roboto(
                                    fontSize: isTablet
                                        ? screenWidth * 0.022
                                        : screenWidth * 0.032,
                                    fontWeight: FontWeight.bold,
                                    color: ConstantColors.black,
                                  ),
                                ),
                                SizedBox(height: 10.dynamic),
                              ],
                            ),
                          ),
                        ),
                      ]
                          .map((w) => Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: w,
                              )))
                          .toList(),
                    ),
                  ),
                );
              },
            ),
            ValueListenableBuilder(
                valueListenable: energyNotiifer,
                builder: (context, value, child) {
                  return Visibility(
                    visible: energyNotiifer.value,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 100.dynamic : 20.dynamic,
                              vertical: 10.dynamic),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10.dynamic,
                                    ),
                                    Text(
                                      'Total Energy Saving',
                                      style: GoogleFonts.roboto(
                                        fontSize: isTablet
                                            ? screenWidth * 0.022
                                            : screenWidth * 0.032,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.dynamic,
                                    ),
                                    Text(
                                      '$totalEnergy %',
                                      style: GoogleFonts.roboto(
                                        fontSize: isTablet
                                            ? screenWidth * 0.025
                                            : screenWidth * 0.05,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          color: Colors.red,
                                          width: isTablet
                                              ? 30.dynamic
                                              : 20.dynamic,
                                          height:
                                              isTablet ? 8.dynamic : 6.dynamic,
                                        ),
                                        SizedBox(
                                          width: 10.dynamic,
                                        ),
                                        Text(
                                          'AC',
                                          style: GoogleFonts.roboto(
                                            fontSize: isTablet
                                                ? screenWidth * 0.022
                                                : screenWidth * 0.032,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.15,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          color: Colors.green,
                                          width: isTablet
                                              ? 30.dynamic
                                              : 20.dynamic,
                                          height:
                                              isTablet ? 8.dynamic : 6.dynamic,
                                        ),
                                        SizedBox(
                                          width: 10.dynamic,
                                        ),
                                        Text(
                                          'DC',
                                          style: GoogleFonts.roboto(
                                            fontSize: isTablet
                                                ? screenWidth * 0.022
                                                : screenWidth * 0.032,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: isTablet ? 200.dynamic : 120.dynamic,
                                  child: CustomDropdownButton(
                                    value: "Intraday",
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Intraday',
                                        child: Text('Intraday'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Day',
                                        child: Text('Day'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Week',
                                        child: Text('Week'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Month',
                                        child: Text('Month'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Year',
                                        child: Text('Year'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      print(' selected: $value');
                                      if (value == "Intraday") {
                                        setState(() {
                                          energyType = "intraday";
                                        });
                                        fetchData("intraday");
                                      } else if (value == "Day") {
                                        setState(() {
                                          energyType = "day";
                                        });
                                        fetchData("day");
                                      } else if (value == "Week") {
                                        setState(() {
                                          energyType = "week";
                                        });
                                        fetchData("week");
                                      } else if (value == "Month") {
                                        setState(() {
                                          energyType = "month";
                                        });
                                        fetchData("month");
                                      } else {
                                        setState(() {
                                          energyType = "year";
                                        });
                                        fetchData("year");
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ValueListenableBuilder(
                valueListenable: savingNotiifer,
                builder: (context, value, child) {
                  return Visibility(
                    visible: savingNotiifer.value,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 100.dynamic : 20.dynamic,
                              vertical: 10.dynamic),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10.dynamic,
                                    ),
                                    Text(
                                      'Total saving in ${currencyCodeNotifier.value}',
                                      style: GoogleFonts.roboto(
                                        fontSize: isTablet
                                            ? screenWidth * 0.025
                                            : screenWidth * 0.032,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.dynamic,
                                    ),
                                    Text(
                                      totalSavings,
                                      style: GoogleFonts.roboto(
                                        fontSize: isTablet
                                            ? screenWidth * 0.03
                                            : screenWidth * 0.05,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          color: Colors.red,
                                          width: isTablet
                                              ? 30.dynamic
                                              : 20.dynamic,
                                          height:
                                              isTablet ? 8.dynamic : 6.dynamic,
                                        ),
                                        SizedBox(
                                          width: 10.dynamic,
                                        ),
                                        Text(
                                          'AC',
                                          style: GoogleFonts.roboto(
                                            fontSize: isTablet
                                                ? screenWidth * 0.022
                                                : screenWidth * 0.032,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.15,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          color: Colors.green,
                                          width: isTablet
                                              ? 30.dynamic
                                              : 20.dynamic,
                                          height:
                                              isTablet ? 8.dynamic : 6.dynamic,
                                        ),
                                        SizedBox(
                                          width: 10.dynamic,
                                        ),
                                        Text(
                                          'DC',
                                          style: GoogleFonts.roboto(
                                            fontSize: isTablet
                                                ? screenWidth * 0.022
                                                : screenWidth * 0.032,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: isTablet ? 200.dynamic : 120.dynamic,
                                  child: CustomDropdownButton(
                                    value: "Day",
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Day',
                                        child: Text('Day'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Week',
                                        child: Text('Week'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Month',
                                        child: Text('Month'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Year',
                                        child: Text('Year'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      print(' selected: $value');
                                      if (value == "Day") {
                                        setState(() {
                                          energyType = "day";
                                        });
                                        fetchData("day");
                                      } else if (value == "Week") {
                                        setState(() {
                                          energyType = "week";
                                        });
                                        fetchData("week");
                                      } else if (value == "Month") {
                                        setState(() {
                                          energyType = "month";
                                        });
                                        fetchData("month");
                                      } else {
                                        setState(() {
                                          energyType = "year";
                                        });
                                        fetchData("year");
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ValueListenableBuilder(
                valueListenable: treeNotiifer,
                builder: (context, value, child) {
                  return Visibility(
                    visible: treeNotiifer.value,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 100.dynamic : 20.dynamic,
                              vertical: 10.dynamic),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Tree Planted',
                                      style: GoogleFonts.roboto(
                                        fontSize: isTablet
                                            ? screenWidth * 0.025
                                            : screenWidth * 0.032,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.dynamic,
                                    ),
                                    Text(
                                      totalTree,
                                      style: GoogleFonts.roboto(
                                        fontSize: isTablet
                                            ? screenWidth * 0.03
                                            : screenWidth * 0.05,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.appColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10.dynamic,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          color: ConstantColors.greenColor,
                                          width: isTablet
                                              ? 20.dynamic
                                              : 15.dynamic,
                                          height:
                                              isTablet ? 8.dynamic : 6.dynamic,
                                        ),
                                        SizedBox(
                                          width: 5.dynamic,
                                        ),
                                        Text(
                                          'Tree Planted',
                                          style: GoogleFonts.roboto(
                                            fontSize: isTablet
                                                ? screenWidth * 0.025
                                                : screenWidth * 0.032,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.dynamic,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          color:
                                              ConstantColors.borderButtonColor,
                                          width: isTablet
                                              ? 20.dynamic
                                              : 15.dynamic,
                                          height:
                                              isTablet ? 8.dynamic : 6.dynamic,
                                        ),
                                        SizedBox(
                                          width: 10.dynamic,
                                        ),
                                        Text(
                                          'S\$ Savings',
                                          style: GoogleFonts.roboto(
                                            fontSize: isTablet
                                                ? screenWidth * 0.025
                                                : screenWidth * 0.032,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.dynamic,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          color: ConstantColors.appColor,
                                          width: isTablet
                                              ? 20.dynamic
                                              : 15.dynamic,
                                          height:
                                              isTablet ? 8.dynamic : 6.dynamic,
                                        ),
                                        SizedBox(
                                          width: 10.dynamic,
                                        ),
                                        Text(
                                          'CO2',
                                          style: GoogleFonts.roboto(
                                            fontSize: isTablet
                                                ? screenWidth * 0.025
                                                : screenWidth * 0.032,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 15.dynamic,
                                ),
                                SizedBox(
                                  width: isTablet ? 200.dynamic : 100.dynamic,
                                  child: CustomDropdownButton(
                                    value: "Day",
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Day',
                                        child: Text('Day'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Week',
                                        child: Text('Week'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Month',
                                        child: Text('Month'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Year',
                                        child: Text('Year'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      print(' selected: $value');
                                      if (value == "Day") {
                                        setState(() {
                                          energyType = "day";
                                        });
                                        fetchData("day");
                                      } else if (value == "Week") {
                                        setState(() {
                                          energyType = "week";
                                        });
                                        fetchData("week");
                                      } else if (value == "Month") {
                                        setState(() {
                                          energyType = "month";
                                        });
                                        fetchData("month");
                                      } else {
                                        setState(() {
                                          energyType = "year";
                                        });
                                        fetchData("year");
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      exportPowerConsumptionData();
                    },
                    child: Image.asset(
                      ImgPath.export,
                      height: 25.dynamic,
                      width: 25.dynamic,
                      color: ConstantColors.iconColr,
                    )),
                const SizedBox(width: 20),
              ],
            ),
            SizedBox(
              height: 20.dynamic,
            ),
            ValueListenableBuilder(
              valueListenable: energyNotiifer,
              builder: (context, value, child) {
                final allValues = [
                  ...energyDataList.map((d) => d.acEnergyConsumed),
                  ...energyDataList.map((d) => d.dcEnergyConsumed),
                ];
                final minY = allValues.isNotEmpty
                    ? allValues.reduce((a, b) => a < b ? a : b)
                    : 0.0;
                final rawMax = allValues.isNotEmpty
                    ? allValues.reduce((a, b) => a > b ? a : b)
                    : 0.1;
                // print('hhsdhdhdh $rawMax');
                // final maxY = rawMax > 0.1 ? rawMax.ceilToDouble() : 0.1;
                // print('maxY $maxY');

                // final interval =
                //     rawMax > 0.1 ? (maxY / 5).ceilToDouble() : 0.02;
                // print('interval $interval');

                final maxY = computeMaxY(rawMax); // e.g. 11 -> 12, 0.43 -> 0.6
                final interval =
                    computeInterval(maxY); // e.g. 12 -> 3, 0.6 -> 0.15

                print('rawMax $rawMax');
                print('maxY $maxY');
                print('interval $interval');

                final double? chartHeight =
                    energyType == "intraday" ? null : 320.dynamic;
                final double? chartHeighty =
                    energyType == "intraday" ? 340.dynamic : 307.dynamic;
                return Visibility(
                  visible: energyNotiifer.value,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 25, left: 5),
                          height: chartHeighty,
                          child: buildGraphy(
                            data: energyDataList,
                            context: context,
                            minY: minY,
                            maxY: maxY,
                            interval: interval,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: energyType == "intraday"
                              ? Column(
                                  children: [
                                    buildGraph(
                                      data: energyDataList,
                                      context: context,
                                      minY: minY,
                                      maxY: maxY,
                                      interval: interval,
                                    ),
                                  ],
                                )
                              : Container(
                                  height: chartHeight,
                                  width: energyType == "day"
                                      ? 1400.dynamic
                                      : energyType == "month"
                                          ? 600.dynamic
                                          : energyType == "year"
                                              ? 380.dynamic
                                              : 400.dynamic,
                                  child: SfCartesianChart(
                                    primaryXAxis:
                                        const CategoryAxis(interval: 1),
                                    primaryYAxis: NumericAxis(
                                      minimum: minY,
                                      maximum: maxY,
                                      interval: interval,
                                      isVisible:
                                          false, // hidden inside main graph
                                    ),
                                    tooltipBehavior: TooltipBehavior(
                                      enable: true,
                                      shared: true,
                                      tooltipPosition: TooltipPosition.auto,
                                    ),
                                    series: <CartesianSeries>[
                                      ColumnSeries<EnergyData, String>(
                                        dataSource: energyDataList,
                                        xValueMapper: (EnergyData d, _) {
                                          if (energyType == "intraday") {
                                            return d.getFormattedTime();
                                          } else if (energyType == "day" ||
                                              energyType == "week") {
                                            return d.getFormattedDate();
                                          } else if (energyType == "month") {
                                            return d.getFormattedMonth();
                                          } else if (energyType == "year") {
                                            return d.getFormattedYear();
                                          }
                                          return "";
                                        },
                                        yValueMapper: (EnergyData d, _) =>
                                            d.acEnergyConsumed,
                                        name: 'AC Power',
                                        color: Colors.red,
                                      ),
                                      ColumnSeries<EnergyData, String>(
                                        dataSource: energyDataList,
                                        xValueMapper: (EnergyData d, _) {
                                          if (energyType == "intraday") {
                                            return d.getFormattedTime();
                                          } else if (energyType == "day" ||
                                              energyType == "week") {
                                            return d.getFormattedDate();
                                          } else if (energyType == "month") {
                                            return d.getFormattedMonth();
                                          } else if (energyType == "year") {
                                            return d.getFormattedYear();
                                          }
                                          return "";
                                        },
                                        yValueMapper: (EnergyData d, _) =>
                                            d.dcEnergyConsumed,
                                        name: 'DC Power',
                                        color: Colors.green,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: savingNotiifer,
              builder: (context, value, child) {
                return Visibility(
                    visible: savingNotiifer.value,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        height: 350.dynamic,
                        width: energyType == "day"
                            ? 1800.dynamic
                            : energyType == "month"
                                ? 600.dynamic
                                : 400.dynamic,
                        child: SfCartesianChart(
                          primaryXAxis: const CategoryAxis(),
                          primaryYAxis: NumericAxis(
                            labelFormat: '{value}',
                            title: AxisTitle(
                              text: 'Saving in doller',
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: isTablet
                                    ? screenWidth * 0.025
                                    : screenWidth * 0.032,
                              ),
                            ),
                          ),
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            shared: true,
                            tooltipPosition: TooltipPosition.auto,
                          ),
                          series: <CartesianSeries>[
                            ColumnSeries<EnergyData, String>(
                              dataSource: energyDataList,
                              enableTooltip: true,
                              xValueMapper: (EnergyData data, _) {
                                if (energyType == "day" ||
                                    energyType == "week") {
                                  return data.getFormattedDate();
                                } else if (energyType == "month") {
                                  return data.getFormattedMonth();
                                } else if (energyType == "year") {
                                  return data.getFormattedYear();
                                } else {
                                  return "";
                                }
                              },
                              yValueMapper: (EnergyData data, _) =>
                                  data.energySavingAc,
                              name: 'AC Saving',
                              color: Colors.red,
                            ),
                            ColumnSeries<EnergyData, String>(
                              dataSource: energyDataList,
                              enableTooltip: true,
                              xValueMapper: (EnergyData data, _) {
                                if (energyType == "day" ||
                                    energyType == "week") {
                                  return data.getFormattedDate();
                                } else if (energyType == "month") {
                                  return data.getFormattedMonth();
                                } else if (energyType == "year") {
                                  return data.getFormattedYear();
                                } else {
                                  return "";
                                }
                              },
                              yValueMapper: (EnergyData data, _) =>
                                  data.energySaving,
                              name: 'DC Saving',
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            ),
            ValueListenableBuilder(
              valueListenable: treeNotiifer,
              builder: (context, value, child) {
                return Visibility(
                    visible: treeNotiifer.value,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        height: 350.dynamic,
                        width: energyType == "day"
                            ? 2000.dynamic
                            : energyType == "month"
                                ? 800.dynamic
                                : 400.dynamic,
                        child: SfCartesianChart(
                          primaryXAxis: const CategoryAxis(),
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            shared: true,
                            tooltipPosition: TooltipPosition.auto,
                          ),
                          series: <CartesianSeries>[
                            ColumnSeries<EnergyData, String>(
                              dataSource: energyDataList,
                              xValueMapper: (EnergyData data, _) {
                                if (energyType == "intraday") {
                                  return data.getFormattedTime();
                                } else if (energyType == "day" ||
                                    energyType == "week") {
                                  return data.getFormattedDate();
                                } else if (energyType == "month") {
                                  return data.getFormattedMonth();
                                } else if (energyType == "year") {
                                  return data.getFormattedYear();
                                } else {
                                  return "";
                                }
                              },
                              yValueMapper: (EnergyData data, _) =>
                                  data.energySaving,
                              name: 'Saving',
                              color: ConstantColors.borderButtonColor,
                            ),
                            ColumnSeries<EnergyData, String>(
                              dataSource: energyDataList,
                              xValueMapper: (EnergyData data, _) {
                                if (energyType == "intraday") {
                                  return data.getFormattedTime();
                                } else if (energyType == "day" ||
                                    energyType == "week") {
                                  return data.getFormattedDate();
                                } else if (energyType == "month") {
                                  return data.getFormattedMonth();
                                } else if (energyType == "year") {
                                  return data.getFormattedYear();
                                } else {
                                  return "";
                                }
                              },
                              yValueMapper: (EnergyData data, _) =>
                                  data.dcCo2Reduction,
                              name: 'Co2',
                              color: ConstantColors.appColor,
                            ),
                            ColumnSeries<EnergyData, String>(
                              dataSource: energyDataList,
                              xValueMapper: (EnergyData data, _) {
                                if (energyType == "intraday") {
                                  return data.getFormattedTime();
                                } else if (energyType == "day" ||
                                    energyType == "week") {
                                  return data.getFormattedDate();
                                } else if (energyType == "month") {
                                  return data.getFormattedMonth();
                                } else if (energyType == "year") {
                                  return data.getFormattedYear();
                                } else {
                                  return "";
                                }
                              },
                              yValueMapper: (EnergyData data, _) =>
                                  data.treesPlanted,
                              name: 'Tree Planted',
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            ),
            SizedBox(
              height: 20.dynamic,
            ),
          ],
        ),
      ),
    );
  }
}
