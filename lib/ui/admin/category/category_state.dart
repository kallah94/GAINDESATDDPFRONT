part of 'category_bloc.dart';

enum CategoryState {
  firstRun, validCategoryFields,
  failureFillCategoryFields,
  addSuccess, addError,
  updateSuccess, updateError,
  deleteInit, deleteSuccess, deleteError
}

class CategoryManagementState {
  final CategoryState categoryState;
  final String? message;

  const CategoryManagementState._(this.categoryState, {this.message});

  const CategoryManagementState.onboarding(): this._(CategoryState.firstRun);

  const CategoryManagementState.deleteInit(): this._(CategoryState.deleteInit);

  const CategoryManagementState.validCategoryFields(): this._(CategoryState.validCategoryFields);

  const CategoryManagementState.failureFillCategoryFields(String? message)
    : this._(CategoryState.failureFillCategoryFields, message: message ?? "Please fill required fields");

  const CategoryManagementState.addSuccess(String? message)
    : this._(CategoryState.addSuccess, message: message ?? " Add Successfully");

  const CategoryManagementState.addError(String? message)
    : this._(CategoryState.addError, message: message ?? "Error when adding new category");

  const CategoryManagementState.updateSuccess(String? message)
      : this._(CategoryState.updateSuccess, message: message ?? "Update Success");

  const CategoryManagementState.updateError(String? message)
    : this._(CategoryState.updateError, message: message ?? "Error when updating");

  const CategoryManagementState.deleteSuccess(String? message)
    : this._(CategoryState.deleteSuccess, message: message ?? "Category deleted successfully");

  const CategoryManagementState.deleteError(String? message)
    : this._(CategoryState.deleteError, message: message ?? "Error when deleting category");
}