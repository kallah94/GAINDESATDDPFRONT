part of 'partner_bloc.dart';


abstract class PartnerEvent {}

class ValidatePartnerFieldsEvent extends PartnerEvent {
  GlobalKey<FormState> key;
  ValidatePartnerFieldsEvent(this.key);
}

class PartnerAddEvent extends PartnerEvent {
  late Partner partner;
  PartnerAddEvent({required this.partner});
}

class PartnerUpdateEvent extends PartnerEvent {
  late Partner partner;
  PartnerUpdateEvent({required this.partner});
}

class PartnerDeleteEvent extends PartnerEvent {
  late String partnerUUID;
  PartnerDeleteEvent({required this.partnerUUID});
}


class CheckFirstRunEvent extends PartnerEvent {}