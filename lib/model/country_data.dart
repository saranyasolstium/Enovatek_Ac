class CountryData {
  final int id;
  final String name;
  final String currencyType;
  final String energyRate; // Keep energyRate as a String

  CountryData({
    required this.id,
    required this.name,
    required this.currencyType,
    required this.energyRate,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      id: _parseId(json['id']),
      name: json['name'] ?? '',
      currencyType: _parseCurrencyType(json['currency_type']),
      energyRate: _parseEnergyRate(json['energy_rate']),
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
