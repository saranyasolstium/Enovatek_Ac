class Building {
  final int buildingId;
  final String name;
  final List<Floor> floors;

  Building({
    required this.buildingId,
    required this.name,
    required this.floors,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    List<Floor> floorList = (json['floors'] as List<dynamic>)
        .map((floorData) => Floor.fromJson(floorData))
        .toList();

    return Building(
      buildingId: json['building_id'],
      name: json['name'],
      floors: floorList,
    );
  }
}

class Floor {
  final int floorId;
  final int buildingId;
  final String name;
  final List<Room> rooms;

  Floor({
    required this.floorId,
    required this.buildingId,
    required this.name,
    required this.rooms,
  });

  factory Floor.fromJson(Map<String, dynamic> json) {
    List<Room> roomList = (json['rooms'] as List<dynamic>)
        .map((roomData) => Room.fromJson(roomData))
        .toList();

    return Floor(
      floorId: json['floorId'],
      buildingId: json['buildingId'],
      name: json['name'],
      rooms: roomList,
    );
  }
}

class Room {
  final int roomId;
  final int floorId;
  final String name;
  final List<Device> devices;

  Room({
    required this.roomId,
    required this.floorId,
    required this.name,
    required this.devices,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    List<Device> deviceList = (json['devices'] as List<dynamic>)
        .map((deviceData) => Device.fromJson(deviceData))
        .toList();

    return Room(
      roomId: json['roomId'],
      floorId: json['floorId'],
      name: json['name'],
      devices: deviceList,
    );
  }
}

class Device {
  final String deviceId;
  final String deviceName;
  final String displayName;
  final int roomId;
  final String power;
  final String mode;
  final String fanSpeed;
  final String roomTemp;
  final String humidity;
  final String airQuality;
  final String maintainenceReq;
  final String filterCleaningReq;
  final String noiseLevel;

  Device({
    required this.deviceId,
    required this.deviceName,
    required this.displayName,
    required this.roomId,
    required this.power,
    required this.mode,
    required this.fanSpeed,
    required this.roomTemp,
    required this.humidity,
    required this.airQuality,
    required this.maintainenceReq,
    required this.filterCleaningReq,
    required this.noiseLevel,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      deviceId: json['deviceId'],
      deviceName: json['deviceName'] ?? '',
      displayName: json['displayName'] ?? '',
      roomId: json['roomId'],
      power: json['power'] ?? 'off',
      mode: json['mode'] ?? '-',
      fanSpeed: json['fanSpeed'] ?? '',
      roomTemp: json['roomTemp'] ?? 'off',
      humidity: json['humidity'] ?? '',
      airQuality: json['airQuality'] ?? '',
      maintainenceReq: json['maintainenceReq'] ?? '',
      filterCleaningReq: json['filterCleaningReq'] ?? '',
      noiseLevel: json['noiseLevel'] ?? '',
    );
  }
}

