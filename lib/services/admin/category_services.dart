import 'package:gaindesat_ddp_client/models/ExceptionMessage.dart';
import 'package:gaindesat_ddp_client/services/admin/generic_service.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';

import '../../models/category_model.dart';

class CategoryService {
  Future<List<ReduceCategory>> fetchCategories() async {
    dynamic response = await GenericService().fetchAllData(allCategoriesUrl);
    if (response is ExceptionMessage) {
      return [ReduceCategory.empty()];
    }
    List<ReduceCategory> categories = response.map<ReduceCategory>((json) => ReduceCategory.fromJson(json)).toList();
    return categories;
  }

  Future<Object> create(CategoryModel category) async {
    dynamic response = await GenericService()
        .createItem<CategoryModel>(category, allCategoriesUrl);
    if (response is ExceptionMessage) {
      return response;
    }
    return CategoryModel.fromJson(response);
  }

  Future<Object?> update(CategoryModel category) async {
    dynamic response = await GenericService()
        .updateItem(category, allCategoriesUrl, category.uuid!);
    if (response is ExceptionMessage) {
      return response;
    }
    return CategoryModel.fromJson(response);
  }

  Future<Object> delete(String categoryUUID) async {
    return await GenericService().delete<CategoryModel>(categoryUUID, allCategoriesUrl);
  }
}