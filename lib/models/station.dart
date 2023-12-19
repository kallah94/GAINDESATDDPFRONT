class Station {
  late final String? uuid;
  late final String? code;
  late final String? name;
  late final String? partnerUUID;
  late final double? longitude;
  late final double? latitude;
  late final double? elevation;

  Station({
      uuid,
      required this.code,
      required this.name,
      required this.partnerUUID,
      required this.longitude,
      required this.latitude,
      required this.elevation,
  });

  Station.empty();

  factory Station.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Station(
      uuid: parsedJson["uuid"] ?? "",
      code: parsedJson["code"] ?? "",
      name: parsedJson["name"] ?? "",
      partnerUUID: parsedJson["partnerUUID"],
      longitude: parsedJson["longitude"] ?? "",
      latitude: parsedJson["latitude"] ?? "",
      elevation: parsedJson["elevation"] ?? ""
    );
  }
}