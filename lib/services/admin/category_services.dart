import 'package:gaindesat_ddp_client/services/admin/generic_service.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';

import '../../models/category_model.dart';

class CategoryService {
  Future<CategoryModel?> create() async { return null;}

  Future<List<ReduceCategory>> fetchCategories() async {
   return GenericService()
       .fetchAllData<ReduceCategory>(
       ReduceCategory.empty(),
       allCategoriesUrl
   );}
}