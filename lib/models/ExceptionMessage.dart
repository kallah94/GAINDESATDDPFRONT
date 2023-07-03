
class ExceptionMessage {
  late final int? statusCode;
  late final String? message;


  ExceptionMessage({required this.statusCode, required this.message});

  ExceptionMessage.empty();

  factory ExceptionMessage.fromJson(Map<dynamic, dynamic> parsedJson) {
    return ExceptionMessage(
        statusCode: parsedJson["statusCode"],
        message: parsedJson["message"],
    );
  }

  @override
  String toString() {
    return 'ExceptionMessage{'
        'statusCode: $statusCode,'
        'messages: $message}';
  }
}

class CustomMessage {
  late final int? statusCode;
  late final String? message;

  CustomMessage({required this.statusCode, required this.message});

  CustomMessage.empty();

  factory CustomMessage.fromJson(Map<dynamic, dynamic> parsedJson) {
    return CustomMessage(
        statusCode: parsedJson["statusCode"],
        message: parsedJson["message"]);
  }

  @override
  String toString() {
    return 'CustomMessage{'
        'statusCode: $statusCode,'
        'message: $message}';
  }
}