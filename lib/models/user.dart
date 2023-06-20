class User {
  late final String? uuid;
  late final bool? status;
  late final String username;
  late final String email;
  late final String password;
  late final String fullName;


  User({
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
    this.status
});

  factory User.fromJson(Map<dynamic, dynamic> parsedJson) {
    return User(
      status: parsedJson["status"],
      username: parsedJson["username"] ?? "",
      email: parsedJson["email"] ?? "",
      password: "",
      fullName: parsedJson["fullName"] ?? ""
    );
  }

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