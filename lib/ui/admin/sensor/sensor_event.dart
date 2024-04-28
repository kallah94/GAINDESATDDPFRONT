part of 'sensor_bloc.dart';

abstract class SensorEvent {}

class ValidateSensorFieldsEvent extends SensorEvent {
  GlobalKey<FormState> key;
  ValidateSensorFieldsEvent(this.key);
}

class SensorDeleteInitEvent extends SensorEvent {}

class SensorAddEvent extends SensorEvent {
  late Sensor sensor;
  SensorAddEvent({required this.sensor});
}

class SensorUpdateEvent extends SensorEvent {
  late Sensor sensor;
  SensorUpdateEvent({required this.sensor});
}

class SensorDeleteEvent extends SensorEvent {
  late String sensorUUID;
  SensorDeleteEvent({required this.sensorUUID});
}

class CheckFirstRunEvent extends SensorEvent {}