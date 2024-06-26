class Permission {
  late final String? uuid;
  late final String code;
  late final String title;
  late final String categoryUUID;

  Permission({
    this.uuid,
    required this.code,
    required this.title,
    required this.categoryUUID
  });

  Permission.empty();

  factory Permission.fromJson(Map<dynamic, dynamic> parseJson) {
    return Permission(
      uuid: parseJson["uuid"] ?? "z",
      code: parseJson["code"] ?? "",
      title: parseJson["title"] ?? "",
      categoryUUID: parseJson["categoryUUID"] ?? ""
    );
  }

  Map toJson() => {
    'uuid': uuid,
    'code': code,
    'title': title,
    'categoryUUID': categoryUUID
  };

  @override
  String toString() {
    return 'Permission{uuid: $uuid, code: $code, title: $title, categoryUUID: $categoryUUID}';
  }

}

class ReducePermission {
  late final String uuid;
  late final String code;
  late final String title;
  late final String categoryName;

  ReducePermission({
    required this.uuid,
    required this.code,
    required this.title,
    required this.categoryName
});
  ReducePermission.empty();

  factory ReducePermission.fromJson(Map<String, dynamic> parsedJson) {
    return ReducePermission(
      uuid: parsedJson["uuid"],
      code: parsedJson["code"],
      title: parsedJson["title"],
      categoryName: parsedJson["categoryName"]
    );
  }

  Map toJson() => {
    'code': code,
    'title': title,
    'categoryName': categoryName
  };

  @override
  String toString() {
    return 'ReducePermission{code: $code, title: $title, categoryName: $categoryName}';
  }

}