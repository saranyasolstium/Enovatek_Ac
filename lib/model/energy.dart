import 'package:intl/intl.dart';

class EnergyData {
  final double totalEnergy;
  final double acEnergyConsumed;
  final double dcEnergyConsumed;
  final double energySaving;
  final double totalCo2Emission;
  final double dcCo2Reduction;
  final double treesPlanted;
  final DateTime period;

  EnergyData({
    required this.totalEnergy,
    required this.acEnergyConsumed,
    required this.dcEnergyConsumed,
    required this.energySaving,
    required this.totalCo2Emission,
    required this.dcCo2Reduction,
    required this.treesPlanted,
    required this.period,
  });

  factory EnergyData.fromJson(Map<String, dynamic> json) {
    try {
      double totalEnergy = (json['total_energy'] as num).toDouble();
      double acEnergyConsumed = (json['ac_energy_consumed'] as num).toDouble();
      double dcEnergyConsumed = (json['dc_energy_consumed'] as num).toDouble();

      // Ensure energySaving is correctly converted to double
      double energySaving = (json['energy_saving'] is num)
          ? (json['energy_saving'] as num).toDouble()
          : double.tryParse(json['energy_saving'].toString()) ?? 0.0;

      print('Parsed Energy Saving: $energySaving');

      double totalCo2Emission = (json['total_co2_emission'] as num).toDouble();
      double dcCo2Reduction = (json['dc_co2_reduction'] as num).toDouble();
      double treesPlanted = (json['trees_planted'] as num).toDouble();
      DateTime period = DateTime.parse(json['period'] as String);
      print(period);
      return EnergyData(
        totalEnergy: totalEnergy < 0 ? 0 : totalEnergy,
        acEnergyConsumed: acEnergyConsumed < 0 ? 0 : acEnergyConsumed,
        dcEnergyConsumed: dcEnergyConsumed < 0 ? 0 : dcEnergyConsumed,
        energySaving: energySaving < 0 ? 0 : energySaving,
        totalCo2Emission: totalCo2Emission < 0 ? 0 : totalCo2Emission,
        dcCo2Reduction: dcCo2Reduction < 0 ? 0 : dcCo2Reduction,
        treesPlanted: treesPlanted < 0 ? 0 : treesPlanted,
        period: period,
      );
    } catch (e) {
      print('Error parsing JSON: $e');
      rethrow;
    }
  }
  DateTime getFormattedTimeAsDateTime() {
    // Return DateTime with only hours, minutes and seconds as zero
    return DateTime(
      period.year,
      period.month,
      period.day,
      period.hour,
    );
  }

  String getFormattedTime() {
    // Use DateFormat to return time in 'HH' format (e.g., '14' for 2 PM)
    return DateFormat('HH').format(period);
  }

  String getFormattedDate() {
    return DateFormat('d MMM').format(period);
  }

  String getFormattedMonth() {
    return DateFormat('MMM').format(period);
  }

  String getFormattedYear() {
    return DateFormat('yyyy').format(period);
  }
}
