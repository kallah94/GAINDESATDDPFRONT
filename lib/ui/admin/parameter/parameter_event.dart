part of 'parameter_bloc.dart';
abstract class ParameterEvent {}

class ValidateParameterFieldsEvent extends ParameterEvent {
  GlobalKey<FormState> key;
  ValidateParameterFieldsEvent(this.key);
}

class ParameterDeleteInitEvent extends ParameterEvent {}

class ParameterAddEvent extends ParameterEvent {
  late Parameter parameter;
  ParameterAddEvent({required this.parameter});
}

class ParameterUpdateEvent extends ParameterEvent {
  late Parameter parameter;
  ParameterUpdateEvent({required this.parameter});
}

class ParameterDeleteEvent extends ParameterEvent {
  late String parameterUUID;
  ParameterDeleteEvent({required this.parameterUUID});
}

class CheckFirstRunEvent extends ParameterEvent {}
