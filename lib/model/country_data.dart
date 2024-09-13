class CountryData {
  final int id;
  final String name;
  final String currencyType;
  final double energyRate;
  final double temperature;
  final double factor;

  CountryData({
    required this.id,
    required this.name,
    required this.currencyType,
    required this.energyRate,
    required this.temperature,
    required this.factor,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      id: _parseId(json['id']),
      name: json['name'] ?? '',
      currencyType: json['currency_type'] ?? "sg",
      energyRate: json['energy_rate'],
      temperature: json['temperature'],
      factor: json['factor'],
    );
  }

  static int _parseId(dynamic id) {
    if (id is String) {
      // Try to parse the string to an integer
      return int.parse(id);
    } else if (id is int) {
      return id;
    } else {
      throw const FormatException('Invalid ID format');
    }
  }

  static String _parseCurrencyType(dynamic currencyType) {
    if (currencyType is String) {
      // Remove unwanted characters like (, ), and '
      return currencyType.replaceAll(RegExp(r"[(),']"), '').trim();
    } else {
      throw const FormatException('Invalid currency type format');
    }
  }

  static String _parseEnergyRate(dynamic energyRate) {
    if (energyRate is String) {
      // Remove unwanted characters like (, ), and '
      return energyRate.replaceAll(RegExp(r"[(),']"), '').trim();
    } else {
      throw const FormatException('Invalid energy rate format');
    }
  }
}
