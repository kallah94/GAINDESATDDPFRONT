class ExceptionMessage {
  late final int? statusCode;
  late final String? message;


  ExceptionMessage({required this.statusCode, required this.message});

  ExceptionMessage.empty();

  factory ExceptionMessage.fromJson(Map<String, dynamic> parsedJson) {
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