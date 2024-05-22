class User {
  late final String? uuid;
  late final bool? status;
  late final String username;
  late final String email;
  late final String password;
  late final String fullName;
  late final String partnerUUID;
  late final String categoryUUID;


  User({
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
    required this.status,
    required this.categoryUUID,
    required this.partnerUUID,
    uuid
});

  factory User.fromJson(Map<dynamic, dynamic> parsedJson) {
    return User(
      uuid: parsedJson["uuid"] ?? "",
      status: parsedJson["status"],
      username: parsedJson["username"] ?? "",
      email: parsedJson["email"] ?? "",
      password: parsedJson["password"] ?? "",
      fullName: parsedJson["fullName"] ?? "",
      categoryUUID: parsedJson["categoryUUID"] ?? "",
      partnerUUID: parsedJson["partnerUUID"] ?? ""
    );
  }

  Map toJson() => {
    'email': email,
    'status': status,
    'password': password,
    'username': username,
    'fullName': fullName,
    'categoryUUID': categoryUUID,
    'partnerUUID': partnerUUID
  };

  User.empty();

  @override
  String toString() {
    return 'User{'
        'username: $username,'
        ' email: $email,'
        ' password: $password,'
        ' fullName: $fullName}';
  }

}