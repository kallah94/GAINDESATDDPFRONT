
import 'package:gaindesat_ddp_client/models/permission.dart';
import 'package:gaindesat_ddp_client/models/user.dart';

class CategoryModel {
  late final String? uuid;
  late final String code;
  late final String catName;
  late final Set<User>? users;
  late final Set<Permission>? permissions;

  CategoryModel({
    required this.code,
    required this.catName,
    this.uuid
  });

  CategoryModel.empty();

  factory CategoryModel.fromJson(Map<dynamic, dynamic> parsedJson) {
    return CategoryModel(
        uuid: parsedJson["uuid"],
        code: parsedJson["code"],
        catName: parsedJson["catName"]
    );
  }

  Map toJson() => {
    'code': code,
    'catName': catName
  };

  @override
  String toString() {
    return 'Category{code: $code, catName: $catName}';
  }
}

class ReduceCategory {
  late final String? uuid;
  late final String code;
  late final String catName;
  late final int userCount;

  ReduceCategory({
    required this.uuid,
    required this.code,
    required this.catName,
    required this.userCount
  });

  ReduceCategory.empty();

  factory ReduceCategory.fromJson(Map<dynamic, dynamic> parsedJson) {
    return ReduceCategory(
        uuid: parsedJson["uuid"],
        code: parsedJson["code"],
        catName: parsedJson["catName"],
        userCount: parsedJson["userCount"]
    );
  }

  @override
  String toString() {
    return 'ReduceCategory{uuid: $uuid, code: $code, catName: $catName, userCount: $userCount}';
  }
}