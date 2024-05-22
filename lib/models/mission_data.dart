class MissionData {
  late final String? uuid;
  late final DateTime? date;
  late final String? parameter;
  late final String? unit;
  late final double? value;
  late final String sensorCode;


  MissionData({
    required this.uuid,
    required this.date,
    required this.parameter,
    required this.unit,
    required this.value,
    required this.sensorCode
  });

  MissionData.empty();

  factory MissionData.fromJson(Map<dynamic, dynamic> parsedJson) {
    return MissionData(
        uuid: parsedJson["uuid"] ?? "",
        date:  DateTime.parse(parsedJson["date"]) ?? DateTime.now(),
        parameter: parsedJson["parameter"] ?? "",
        unit: parsedJson["unit"] ?? "",
        value: parsedJson["value"] ?? "",
        sensorCode: parsedJson["sensorCode"] ?? ""
    );
  }

  @override
  String toString() {
    return 'MissionData{parameter: $parameter, unit: $unit, date: $date}';
  }
}