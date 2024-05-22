
class UserDetails {
  late final String? uuid;
  late final String? username;
  late final String? email;
  late final String? accessToken;
  late final String? partnerUuid;
  late final List<String>? roles;

  UserDetails({
    required this.uuid,
    required this.username,
    required this.email,
    required this.roles,
    required this.partnerUuid,
    required this.accessToken

  });

  UserDetails.empty();

  factory UserDetails.fromJson(Map<dynamic, dynamic> parsedJson) {
    return  UserDetails(
        uuid: parsedJson["uuid"] ?? "",
        username: parsedJson["username"] ?? "",
        roles: parsedJson["roles"].cast<String>() ?? "",
        email: parsedJson["email"] ?? "",
        partnerUuid: parsedJson["partnerUUID"],
        accessToken: parsedJson["accessToken"] ?? ""
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "uuid": uuid,
        "username": username,
        "email": email,
        "partnerUuid": partnerUuid,
        "roles": roles,
        "accessToken": accessToken
      };

  @override
  String toString() {
    return 'UserDetails{'
        'uuid: $uuid,'
        ' username: $username,'
        ' email: $email,'
        ' roles: $roles,'
        ' partnerUuid: $partnerUuid,'
        ' accessToken: $accessToken,'
        '}';
  }
}