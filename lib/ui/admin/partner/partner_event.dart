part of 'partner_bloc.dart';


abstract class PartnerEvent {}

class ValidatePartnerFieldsEvent extends PartnerEvent {
  GlobalKey<FormState> key;
  ValidatePartnerFieldsEvent(this.key);
}

class PartnerAddOrUpdateEvent extends PartnerEvent {
  late Partner partner;
  PartnerAddOrUpdateEvent({required this.partner});
}
