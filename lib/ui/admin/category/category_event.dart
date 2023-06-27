part of 'category_bloc.dart';

abstract class CategoryEvent {}

class ValidateCategoryFieldsEvent extends CategoryEvent {
  GlobalKey<FormState> key;
  ValidateCategoryFieldsEvent(this.key);
}

class CategoryDeleteInitEvent extends CategoryEvent {}

class CategoryAddEvent extends CategoryEvent {
  late CategoryModel category;
  CategoryAddEvent({required this.category});
}

class CategoryUpdateEvent extends CategoryEvent {
  late CategoryModel category;
  CategoryUpdateEvent({required this.category});
}

class CategoryDeleteEvent extends CategoryEvent {
  late String categoryUUID;
  CategoryDeleteEvent({required this.categoryUUID});
}

class CheckFirstRunEvent extends CategoryEvent {}