
import 'package:gaindesat_ddp_client/models/permission.dart';
import 'package:gaindesat_ddp_client/models/user.dart';

class Category {
  late final String? id;
  late final String code;
  late final String catName;
  late final Set<User>? users;
  late final Set<Permission>? permissions;

  Category({
    required this.code,
    required this.catName
  });

  Category.empty();

  @override
  String toString() {
    return 'Category{code: $code, catName: $catName}';
  }

}