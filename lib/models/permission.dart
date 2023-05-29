
class Permission {
  late final String? uuid;
  late final String code;
  late final String title;

  Permission({
    required this.uuid,
    required this.code,
    required this.title,
  });

  Permission.empty();

  factory Permission.fromJson(Map<dynamic, dynamic> parseJson) {
    return Permission(
      uuid: parseJson["uuid"] ?? "",
      code: parseJson["code"] ?? "",
      title: parseJson["title"] ?? "",
    );
  }
  @override
  String toString() {
    return 'Permission{code: $code, title: $title}';
  }

}