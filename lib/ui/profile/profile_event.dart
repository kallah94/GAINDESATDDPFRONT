part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class ValidateProfileFieldsEvent extends ProfileEvent {
  GlobalKey<FormState> key;
  ValidateProfileFieldsEvent(this.key);
}

class ProfileEditEvent extends ProfileEvent {
  late User user;
  ProfileEditEvent({required this.user});
}

class CheckFirstRunEvent extends ProfileEvent {}