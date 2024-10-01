
enum CustomExceptionType {
  generalError,
  emailAlready
}

class CustomException implements Exception {
  final String message;
  
  CustomException(this.message);
  
  @override
  String toString() => 'CustomException: $message';
}





