part of 'collected-data_bloc.dart';

abstract class CollectedDataEvent {}

class ValidateCollectedDataDatesFieldsEvent extends CollectedDataEvent {
  GlobalKey<FormState> key;
  ValidateCollectedDataDatesFieldsEvent(this.key);
}

class CollectedDataRequestInitEvent extends CollectedDataEvent {}

class CollectedDataRequestEvent extends CollectedDataEvent {
  late String startDate, endDate;
  CollectedDataRequestEvent(
      {
        required this.startDate,
        required this.endDate
      }
    );
}

class CheckFirstRunEvent extends CollectedDataEvent {}