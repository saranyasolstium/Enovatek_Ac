import 'package:intl/intl.dart';
class BillingData {
  final String deviceId;
  final String period;
  final double totalConsumption;
  final double acEnergyConsumed;
  final double dcEnergyConsumed;
  final double energySaving;
  final double treesPlanted;
  final String billAmount;

  BillingData({
    required this.deviceId,
    required this.period,
    required this.totalConsumption,
    required this.acEnergyConsumed,
    required this.dcEnergyConsumed,
    required this.energySaving,
    required this.treesPlanted,
    required this.billAmount,
  });

  factory BillingData.fromJson(Map<String, dynamic> json) {
    return BillingData(
      deviceId: json['device_id'],
      period: json['period'],
      totalConsumption: double.parse(json['total_consumption']),
      acEnergyConsumed: double.parse(json['ac_energy_consumed']),
      dcEnergyConsumed: double.parse(json['dc_energy_consumed']),
      energySaving: double.parse(json['energy_saving']),
      treesPlanted: double.parse(json['trees_planted']),
      billAmount: json['bill_amount'],
    );
  }
 
}
class SummaryBill {
  final String period;
  final double saving;
  final double treesPlanted;
  final double energySaving;

  SummaryBill({
    required this.period,
    required this.saving,
    required this.treesPlanted,
    required this.energySaving,
  });

  factory SummaryBill.fromJson(Map<String, dynamic> json) {
    return SummaryBill(
      period: json['period'],
      saving: double.parse(json['saving']),
      treesPlanted: double.parse(json['trees_planted']),
      energySaving: double.parse(json['energy_saving']),
    );
  }

  String getFormattedPeriod() {
    DateTime parsedDate = DateTime.parse(this.period);
    String formattedDate = DateFormat('MMMM').format(parsedDate);  // August
    return formattedDate;
  }

}