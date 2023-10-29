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
    List<Floor> floorList = (json['floor'] as List<dynamic>)
        .map((floorData) => Floor.fromJson(floorData))
        .toList();

    return Building(
      buildingId: json['buildingId'],
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
    List<Room> roomList = (json['room'] as List<dynamic>)
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

  Room( {
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
      floorId:json['floorId'],
      name: json['name'],
      devices: deviceList,
    );
  }
}

class Device {
  final int deviceId;
  final String deviceName;

  Device({
    required this.deviceId,
    required this.deviceName,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      deviceId: json['deviceId'],
      deviceName: json['deviceName'],
    );
  }
}
