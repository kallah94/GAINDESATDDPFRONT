part of 'station_bloc.dart';

abstract class StationEvent {}

class ValidateStationsFieldsEvent extends StationEvent {
  GlobalKey<FormState> key;
  ValidateStationsFieldsEvent(this.key);
}

class StationsDeleteInitEvent extends StationEvent {}

class StationAddEvent extends StationEvent  {
  late Station station;
  StationAddEvent({required this.station});
}

class StationUpdateEvent extends StationEvent {
  late Station station;
  StationUpdateEvent({required this.station});
}

class StationDeleteEvent extends StationEvent {
  late String stationUUID;
  StationDeleteEvent({required this.stationUUID});
}

class CheckFirstRunEvent extends StationEvent {}