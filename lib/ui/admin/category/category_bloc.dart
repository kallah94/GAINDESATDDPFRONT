import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:gaindesat_ddp_client/services/admin/category_services.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/category_model.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryManagementState> {
  late SharedPreferences prefs;
  late bool finishedOnBoarding;

  CategoryBloc() : super(const CategoryManagementState.onboarding()) {
    on<CheckFirstRunEvent>((event, emit) async {
      prefs = await SharedPreferences.getInstance();
      finishedOnBoarding = prefs.getBool(finishedOnBoardingConst) ?? false;
      if (!finishedOnBoarding) {
        emit(const CategoryManagementState.onboarding());
      }
    });

    on<ValidateCategoryFieldsEvent>((event, emit) {
      if (event.key.currentState?.validate() ?? false) {
        event.key.currentState!.save();
        emit(const CategoryManagementState.validCategoryFields());
      } else {
        emit(const CategoryManagementState.failureFillCategoryFields("fill required fields"));
      }
    });

    on<CategoryAddEvent>((event, emit) async {
      dynamic result = await CategoryService().create(event.category);
      if (result !=null && result is CategoryModel) {
        emit(CategoryManagementState.addSuccess("Partner added successfully: : ${result.uuid}"));
      } else {
        emit(CategoryManagementState.addError("Error"));
      }
    });

    on<CategoryUpdateEvent>((event, emit) async {
      dynamic result = await CategoryService().update(event.category);
      if (result != null && result is CategoryModel) {
        emit(CategoryManagementState.updateSuccess("Success"));
      } else {
        emit(CategoryManagementState.updateError("Error"));
      }
    });

    on<CategoryDeleteInitEvent>((event, emit) =>
        emit(const CategoryManagementState.deleteInit()));

    on<CategoryDeleteEvent>((event, emit) async {
      dynamic result = await CategoryService().delete(event.categoryUUID);
      if (result != null && result is CategoryModel) {
        emit(CategoryManagementState.deleteSuccess("Success"));
      } else {
        emit(CategoryManagementState.deleteError("Error"));
      }
    });
  }
}