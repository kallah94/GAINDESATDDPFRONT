class MissionData {
  late final String? uuid;
  late final String? date;
  late final String? parameter;
  late final String? unit;
  late final double? value;


  MissionData({
    required this.uuid,
    required this.date,
    required this.parameter,
    required this.unit,
    required this.value
  });

  MissionData.empty();

  factory MissionData.fromJson(Map<dynamic, dynamic> parsedJson) {
    return MissionData(
        uuid: parsedJson["uuid"] ?? "",
        date: parsedJson["date"] ?? "",
        parameter: parsedJson["parameter"] ?? "",
        unit: parsedJson["unit"] ?? "",
        value: parsedJson["value"] ?? ""
    );
  }

  @override
  String toString() {
    return 'MissionData{parameter: $parameter, unit: $unit, date: $date}';
  }
}