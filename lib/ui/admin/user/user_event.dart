part of 'user_bloc.dart';


abstract class UserEvent {}


class ValidateUserFieldsEvent extends UserEvent {
  GlobalKey<FormState> key;
  ValidateUserFieldsEvent(this.key);
}

class UserDeleteInitEvent extends UserEvent {}

class UserAddEvent extends UserEvent {
  late FullUser fullUser;
  UserAddEvent({required this.fullUser});
}

class UserUpdateEvent extends UserEvent {
  late FullUser fullUser;
  UserUpdateEvent({required this.fullUser});
}

class UserDeleteEvent extends UserEvent {
  late String fullUserUUID;
  UserDeleteEvent({required this.fullUserUUID});
}

class CheckFirstRunEvent extends UserEvent {}