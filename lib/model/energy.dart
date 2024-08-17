import 'package:intl/intl.dart';

class EnergyData {
  final DateTime date;
  final double totalEnergy;
  final double acEnergy;
  final double dcEnergy;
  final double acCo2;
  final double dcCo2;
  final double acTree;
  final double dcTree;
  final double saving;

  EnergyData(
      {required this.date,
      required this.totalEnergy,
      required this.acEnergy,
      required this.dcEnergy,
      required this.acCo2,
      required this.dcCo2,
      required this.acTree,
      required this.dcTree,
      required this.saving});

  factory EnergyData.fromJson(Map<String, dynamic> json) {
    DateTime date;

    try {
      if (json.containsKey('hour')) {
        // Intraday
        date = DateTime.parse(json['hour']);
      } else if (json.containsKey('date')) {
        // Day
        date = DateTime.parse(json['date']);
      } else if (json.containsKey('week')) {
        // Week
        date = DateTime.parse(json['week']);
      } else if (json.containsKey('month')) {
        // Month
        date = DateTime.parse(json['month']);
      } else if (json.containsKey('year')) {
        // Year
        date = DateTime.parse(json['year']);
      } else {
        throw Exception('Date information is missing.');
      }
    } catch (e) {
      print('Error parsing date: $e');
      print(
          'Date string: ${json.containsKey('hour') ? json['hour'] : json['date']}');
      rethrow;
    }

    double totalEnergy = _parseEnergyValue(json['total_energy']);
    double acEnergy = _parseEnergyValue(json['ac_energy']);
    double dcEnergy = _parseEnergyValue(json['dc_energy']);
    double saving = _parseEnergyValue(json['total_energy_saving']);

    // Calculation for CO2 with rounding to two decimal places
    double acCo2 = acEnergy > 0
        ? double.parse((0.4168 * acEnergy).toStringAsFixed(2))
        : 0.0;
    print(acCo2);
    double dcCo2 = dcEnergy > 0
        ? double.parse((0.4168 * dcEnergy).toStringAsFixed(2))
        : 0.0;

    // Calculation for CO2 Reduction
    double reduction = (7.81 * 0.4168);
    double acCo2Reduction = acCo2 > 0 ? reduction - acCo2 : 0.0;
    double dcCo2Reduction = dcCo2 > 0 ? reduction - dcCo2 : 0.0;

    // Calculation for Trees Planted
    double acTree = acCo2Reduction > 0
        ? double.parse((acCo2Reduction / 25).toStringAsFixed(2))
        : 0.0;
    print('tree $acTree');
    double dcTree = dcCo2Reduction > 0
        ? double.parse((dcCo2Reduction / 25).toStringAsFixed(2))
        : 0.0;

    return EnergyData(
      date: date,
      totalEnergy: totalEnergy,
      acEnergy: acEnergy,
      dcEnergy: dcEnergy,
      acCo2: acCo2,
      dcCo2: dcCo2,
      acTree: acTree,
      dcTree: dcTree,
      saving:saving, 
    );
  }

  static double _parseEnergyValue(dynamic energy) {
    if (energy is String) {
      return double.parse(energy.replaceAll(' kWh', '').trim());
    } else if (energy is double) {
      return energy;
    } else {
      throw const FormatException('Invalid energy format');
    }
  }

  String getFormattedTime() {
    return DateFormat.H().format(date);
  }

  String getFormattedDate() {
    return DateFormat('d MMM').format(date); // Converts to format like '12 Aug'
  }

  String getFormattedMonth() {
    return DateFormat('MMM').format(date); // Converts to format like 'Jul'
  }

  String getFormattedYear() {
    return DateFormat('yyyy').format(date); // Converts to format like '2024'
  }
}
