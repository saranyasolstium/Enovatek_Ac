class DeviceRealTimeData {
  String deviceId;
  String uid;
  String rtc;
  String powerState;
  MeterAC meterAC;
  MeterDC meterDC;

  DeviceRealTimeData({
    required this.deviceId,
    required this.uid,
    required this.rtc,
    required this.powerState,
    required this.meterAC,
    required this.meterDC,
  });

  factory DeviceRealTimeData.fromJson(Map<String, dynamic> json) {
    return DeviceRealTimeData(
      deviceId: json['device_id'],
      uid: json['uid'],
      rtc: json['rtc'],
      powerState: json['power_state'],
      meterAC: MeterAC.fromJson(json['meter_ac']),
      meterDC: MeterDC.fromJson(json['meter_dc']),
    );
  }
}

class MeterAC {
  Voltage voltage;
  Current current;
  Power power;
  Frequency frequency;
  double pf;
  Energy energy;

  MeterAC({
    required this.voltage,
    required this.current,
    required this.power,
    required this.frequency,
    required this.pf,
    required this.energy,
  });

  factory MeterAC.fromJson(Map<String, dynamic> json) {
    return MeterAC(
      voltage: Voltage.fromJson(json['voltage']),
      current: Current.fromJson(json['current']),
      power: Power.fromJson(json['power']),
      frequency: Frequency.fromJson(json['frequency']),
      pf: json['pf'] != null ? double.tryParse(json['pf'].toString()) ?? 0.0 : 0.0,
      energy: Energy.fromJson(json['energy']),
    );
  }
}

class Voltage {
  double value;
  String unit;

  Voltage({
    required this.value,
    required this.unit,
  });

  factory Voltage.fromJson(Map<String, dynamic> json) {
    return Voltage(
      value: double.tryParse(json['value'].toString()) ?? 0.0,
      unit: json['unit'],
    );
  }
}

class Current {
  double value;
  String unit;

  Current({
    required this.value,
    required this.unit,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      value: double.tryParse(json['value'].toString()) ?? 0.0,
      unit: json['unit'],
    );
  }
}

class Power {
  double value;
  String unit;

  Power({
    required this.value,
    required this.unit,
  });

  factory Power.fromJson(Map<String, dynamic> json) {
    return Power(
      value: double.tryParse(json['value'].toString()) ?? 0.0,
      unit: json['unit'],
    );
  }
}

class Frequency {
  double value;
  String unit;

  Frequency({
    required this.value,
    required this.unit,
  });

  factory Frequency.fromJson(Map<String, dynamic> json) {
    return Frequency(
      value: double.tryParse(json['value'].toString()) ?? 0.0,
      unit: json['unit'],
    );
  }
}

class Energy {
  double value;
  String unit;

  Energy({
    required this.value,
    required this.unit,
  });

  factory Energy.fromJson(Map<String, dynamic> json) {
    return Energy(
      value: double.tryParse(json['value'].toString()) ?? 0.0,
      unit: json['unit'],
    );
  }
}

class MeterDC {
  Voltage voltage;
  Current current;
  Power power;
  Energy energy;

  MeterDC({
    required this.voltage,
    required this.current,
    required this.power,
    required this.energy,
  });

  factory MeterDC.fromJson(Map<String, dynamic> json) {
    return MeterDC(
      voltage: Voltage.fromJson(json['voltage']),
      current: Current.fromJson(json['current']),
      power: Power.fromJson(json['power']),
      energy: Energy.fromJson(json['energy']),
    );
  }
}
