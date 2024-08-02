class EnergyData {
  final DateTime date;
  final double totalEnergy;
  final double acEnergy;
  final double dcEnergy;

  EnergyData({
    required this.date,
    required this.totalEnergy,
    required this.acEnergy,
    required this.dcEnergy,
  });

  factory EnergyData.fromJson(Map<String, dynamic> json) {
    DateTime date;
    double totalEnergy;

    if (json.containsKey('hour')) {
      date = DateTime.parse(json['hour']);

    } else if (json.containsKey('date')) {
      print('ssssss${json['date']}');
      String monthDate= json['date'] + "T00:00:00Z";
      date = DateTime.parse(monthDate);
      print(json['ac_energy']);
      print('saranya $date');
    } else if (json.containsKey('year_month')) {
      date = DateTime.parse(json['year_month']);
            print('saranya $date');

    } else {
      throw Exception('Date information is missing.');
    }

    if (json['total_energy'] is String) {
      totalEnergy = double.parse(json['total_energy'].replaceAll(' kWh', ''));
    } else {
      totalEnergy = json['total_energy'].toDouble();
    }

    double acEnergy = json['ac_energy'] is String
        ? double.parse(json['ac_energy'].replaceAll(' kWh', ''))
        : json['ac_energy'].toDouble();

    double dcEnergy = json['dc_energy'] is String
        ? double.parse(json['dc_energy'].replaceAll(' kWh', ''))
        : json['dc_energy'].toDouble();

    return EnergyData(
      date: date,
      totalEnergy: totalEnergy,
      acEnergy: acEnergy,
      dcEnergy: dcEnergy,
    );
  }
}
