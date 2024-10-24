import 'package:intl/intl.dart';

class BillingData {
  final String deviceId;
  final String period;
  final String paidDate;
  final String dueDate;
  final String billDate;

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
    required this.paidDate,
    required this.dueDate,
    required this.billDate,
  });

  factory BillingData.fromJson(Map<String, dynamic> json) {
    return BillingData(
      deviceId: json['device_id'],
      period: json['period'],
      paidDate: json['paid_date'],
      billDate: json['bill_date'],
      dueDate: json['due_date'],
      totalConsumption: double.parse(json['total_consumption']),
      acEnergyConsumed: double.parse(json['ac_energy_consumed']),
      dcEnergyConsumed: double.parse(json['dc_energy_consumed']),
      energySaving: double.parse(json['energy_saving']),
      treesPlanted: double.parse(json['trees_planted']),
      billAmount: json['bill_amount'],
    );
  }

  String getFormattedDate() {
    DateTime parsedDate = DateTime.parse(paidDate);
    String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
    return formattedDate;
  }

  String getFormattedDueDate() {
    DateTime parsedDate = DateTime.parse(dueDate);
    String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
    return formattedDate;
  }

  String getFormattedBillDate() {
    DateTime parsedDate = DateTime.parse(billDate);
    String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
    return formattedDate;
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
    String formattedDate = DateFormat('MMMM').format(parsedDate); // August
    return formattedDate;
  }
}

class SummaryDetail {
  final String totalBillAmount;
  final String totalConsumption;
  final String billStatus;
  final String paymentId;

  SummaryDetail({
    required this.totalBillAmount,
    required this.totalConsumption,
    required this.billStatus,
    required this.paymentId,
  });

  factory SummaryDetail.fromJson(Map<String, dynamic> json) {
    return SummaryDetail(
      totalBillAmount: json['total_bill_amount'],
      totalConsumption: json['total_consumption'],
      billStatus: json['bill_status'],
      paymentId: json['payment_id'],
    );
  }
}
