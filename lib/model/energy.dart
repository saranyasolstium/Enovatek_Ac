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
  final double avgSaving;

  EnergyData(
      {required this.date,
      required this.totalEnergy,
      required this.acEnergy,
      required this.dcEnergy,
      required this.acCo2,
      required this.dcCo2,
      required this.acTree,
      required this.dcTree,
      required this.saving,
      required this.avgSaving});

  factory EnergyData.fromJson(Map<String, dynamic> json) {
    DateTime date;

    try {
      if (json.containsKey('interval_start')) {
        // Intraday
        date = DateTime.parse(json['interval_start']);
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
    print('energy2 $dcEnergy');
    double saving = _parseDynamicValue(json['total_energy_saving']);
    double avgSaving;
    if (json.containsKey('avg_energy_saving')) {
      print('saranya ${json['avg_energy_saving']}');

      avgSaving = _parseDynamicValue(json['avg_energy_saving']);
      print(avgSaving);
    } else {
      avgSaving = 0.0;
    }

    // Calculation for CO2 with rounding to two decimal places
    double acCo2 = acEnergy > 0
        ? double.parse((0.4168 * acEnergy).toStringAsFixed(4))
        : 0.0;
    double dcCo2 = dcEnergy > 0
        ? double.parse((0.4168 * dcEnergy).toStringAsFixed(4))
        : 0.0;
    print('dcEnergy $dcEnergy');

    print('dcCo2 $dcCo2');

    // Calculation for CO2 Reduction
    double reduction = (avgSaving * 0.4168);
    print('reduction $reduction');
    double acCo2Reduction = reduction - acCo2;
    double dcCo2Reduction = reduction - dcCo2;

    print('dcCo2Reduction $dcCo2Reduction');

    // Calculation for Trees Planted
    double acTree = acCo2Reduction > 0
        ? double.parse((acCo2Reduction / 25).toStringAsFixed(4))
        : 0.0;
    double dcTree = dcCo2Reduction > 0
        ? double.parse((dcCo2Reduction / 25).toStringAsFixed(4))
        : 0.0;

    print('tree $dcTree');

    return EnergyData(
        date: date,
        totalEnergy: totalEnergy,
        acEnergy: acEnergy,
        dcEnergy: dcEnergy,
        acCo2: acCo2,
        dcCo2: dcCo2,
        acTree: acTree,
        dcTree: dcTree,
        saving: dcEnergy * 3,
        avgSaving: avgSaving);
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

  static double _parseDynamicValue(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.parse(value.replaceAll('-', '').trim());
    } else {
      throw const FormatException('Invalid format for total energy saving');
    }
  }

  String getFormattedTime() {
    return DateFormat('h:mm a').format(date);
  }

  String getFormattedDate() {
    return DateFormat('d MMM').format(date);
  }

  String getFormattedMonth() {
    return DateFormat('MMM').format(date);
  }

  String getFormattedYear() {
    return DateFormat('yyyy').format(date);
  }
}
