import 'package:gaindesat_ddp_client/models/category.dart';

class Permission {
  late final String? id;
  late final String code;
  late final String title;
  late final Category category;

  Permission({
    required this.code,
    required this.title,
    required this.category
  });

  Permission.empty();

  @override
  String toString() {
    return 'Permission{code: $code, title: $title, category: $category}';
  }

}