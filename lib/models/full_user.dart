
class FullUser{
  late final String? uuid;
  late final bool? status;
  late final String username;
  late final String email;
  late final String fullName;
  late String? categoryName;
  late String? partnerName;
  late List<String>? roles;

  FullUser({
    required uuid,
    required this.status,
    required this.roles,
    required this.categoryName,
    required this.partnerName,
    required this.username,
    required this.email,
    required this.fullName,
  });

  factory FullUser.fromJson(Map<dynamic, dynamic> parsedJson) {
    return FullUser(
      uuid: parsedJson['uuid'] ?? "",
      username: parsedJson["username"] ?? "",
      roles: parsedJson["roles"].cast<String>() ?? "",
      email: parsedJson["email"] ?? "",
      status: parsedJson["status"] ?? "",
      categoryName: parsedJson['categoryName'] ?? "",
      partnerName: parsedJson['partnerName'] ?? "",
      fullName: parsedJson['fullName'] ?? ""
    );
  }

  @override
  String toString() {
    return 'FullUser{'
        'username: $username,'
        'email: $email,'
        'fullName: $fullName,'
        'category: $categoryName,'
        'partner: $partnerName,'
        'roles: $roles'
        '}';
  }

}