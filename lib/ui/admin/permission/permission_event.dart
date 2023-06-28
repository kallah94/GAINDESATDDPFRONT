part of 'permission_bloc.dart';

abstract class PermissionEvent {}

class ValidatePermissionFieldsEvent extends PermissionEvent {
  GlobalKey<FormState> key;
  ValidatePermissionFieldsEvent(this.key);
}

class PermissionDeleteInitEvent extends PermissionEvent {}

class PermissionAddEvent extends PermissionEvent {
  late Permission  permission;
  PermissionAddEvent({required this.permission});
}

class PermissionUpdateEvent extends PermissionEvent {
  late Permission permission;
  PermissionUpdateEvent({required this.permission});
}

class PermissionDeleteEvent extends PermissionEvent {
  late String permissionUUID;
  PermissionDeleteEvent({required this.permissionUUID});
}

class CheckFirstRunEvent extends PermissionEvent {}