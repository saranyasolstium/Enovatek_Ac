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
    // Determine whether it's an hourly or daily entry
    DateTime date;
    if (json.containsKey('hour')) {
      date = DateTime.parse(json['hour']);
    } else if (json.containsKey('date')) {
      date = DateTime.parse(json['date']);
    } else if (json.containsKey('year_month')) {
      date = DateTime.parse(json['year_month'] + '-01'); 
    } else {
      throw Exception('Date information is missing.');
    }

    return EnergyData(
      date: date,
      totalEnergy: double.parse(json['total_energy'].split(' ')[0]),
      acEnergy: double.parse(json['ac_energy'].split(' ')[0]),
      dcEnergy: double.parse(json['dc_energy'].split(' ')[0]),
    );
  }
}
