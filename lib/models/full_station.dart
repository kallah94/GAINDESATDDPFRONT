class FullStation{
  late final String? uuid;
  late final String? code;
  late final String? name;
  late final String? partnerUUID;
  late final double? longitude;
  late final double? latitude;
  late final double? elevation;
  //late final double? numberOfSensors;

  FullStation({
    required this.uuid,
    required this.code,
    required this.name,
    required this.partnerUUID,
    required this.longitude,
    required this.latitude,
    required this.elevation,
   // required this.numberOfSensors
  });

  FullStation.empty();

  factory FullStation.fromJson(Map<dynamic, dynamic> parsedJson) {
    return FullStation(
        uuid: parsedJson["uuid"] ?? "",
        code: parsedJson["code"] ?? "",
        name: parsedJson["name"] ?? "",
        partnerUUID: parsedJson["partnerUUID"] ?? "",
        longitude: parsedJson["longitude"] ?? "",
        latitude: parsedJson["latitude"] ?? "",
        elevation: parsedJson["elevation"] ?? "",
        //numberOfSensors: parsedJson["numberOfSensors"] ?? ""
    );
  }

  Map toJson() => {
    'uuid': uuid,
    'code': code,
    'name': name,
    'partnerUUID': partnerUUID,
    'longitude': longitude,
    'latitude': latitude,
    'elevation': elevation
  };

  @override
  String toString() {
    return 'Station{uuid: $uuid, code: $code,name: $name, longitude: $longitude, latitude: $latitude, elevation: $elevation, partnerUUID: $partnerUUID}';
  }
}