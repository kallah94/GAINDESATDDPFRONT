class Sensor {
  late final String? uuid;
  late final String? code;
  late final String? name;
  late final String? type;
  late final List<dynamic>? parameters;
  late final String? stationUuid;

  Sensor(
      {this.uuid,
      required this.code,
      required this.name,
      required this.type,
      this.parameters,
      required this.stationUuid});

  Sensor.empty();

  factory Sensor.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Sensor(
        uuid: parsedJson["uuid"] ?? "",
        code: parsedJson["code"] ?? "",
        name: parsedJson["name"] ?? "",
        type: parsedJson["type"] ?? "",
        parameters: parsedJson["parameters"] ?? "",
        stationUuid: parsedJson["stationUuid"] ?? "");
  }

  Map toJson() => {
        'code': code,
        'name': name,
        'type': type,
        'parameters': parameters,
        'stationUuid': stationUuid
      };

  @override
  String toString() {
    return 'Sensor{uuid: $uuid, code: $code, name: $name, type: $name, stationUuid: $stationUuid}';
  }
}
