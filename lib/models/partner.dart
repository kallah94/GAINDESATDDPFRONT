import 'package:gaindesat_ddp_client/models/user.dart';

import 'mission_data.dart';

class Partner {
  late final String? id;
  late final String code;
  late final String partName;
  late final Set<User>? users;
  late final Set<MissionData>? missionData;

  Partner({
    required this.code,
    required this.partName
  });

  Partner.empty();

  @override
  String toString() {
    return 'Partner{code: $code, partName: $partName}';
  }
}

class ReducePartner {
  late final String? uuid;
  late final String? code;
  late final String? name;
  late final int? userCount;

  ReducePartner({
    required this.uuid,
    required this.code,
    required this.name,
    required this.userCount
  });

  ReducePartner.empty();

  factory ReducePartner.fromJson(Map<dynamic, dynamic> parsedJson) {
    return ReducePartner(
      uuid: parsedJson["uuid"] ?? "",
      code: parsedJson["code"] ?? "",
      name: parsedJson["name"] ?? "",
      userCount: parsedJson["userCount"] ?? ""
    );
  }

  @override
  String toString() {
    return 'ReducePartner{uuid: $uuid, code: $code, partName: $name, userCount: $userCount}';
  }
}