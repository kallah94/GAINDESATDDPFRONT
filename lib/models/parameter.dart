class Parameter {
  late final String? uuid;
  late final String name;
  late final String description;
  late final String unite;


  Parameter({
    required this.name,
    required this.description,
    required this.unite,
    this.uuid
  });

  Parameter.empty();

  factory Parameter.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Parameter(
      uuid: parsedJson["uuid"],
      name: parsedJson["name"],
      description: parsedJson["description"],
      unite: parsedJson["unite"]
    );
  }

  Map toJson() => {
    'name': name,
    'description': description,
    'unite': unite
  };

  @override
  String toString() {
    return 'Parameter{name: $name, description: $description, unite: $unite}';
  }
}