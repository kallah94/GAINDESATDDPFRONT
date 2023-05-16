class User {
  late final String? uuid;
  late final bool? status;
  late final String username;
  late final String email;
  late final String password;
  late final String fullName;


  User(this.status, {
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
});

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