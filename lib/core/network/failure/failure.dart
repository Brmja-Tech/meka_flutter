abstract class Failure {
  final String message;

  Failure(this.message);
}

class ValidationFailure extends Failure {
  final List<String> errors;

  ValidationFailure({required String message,required this.errors}) : super(message);
}

class ConnectionFailure extends Failure {
  ConnectionFailure({required String message}) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure({required String message}) : super(message);
}

class RequestTimeOutFailure extends Failure {
  RequestTimeOutFailure({required String message}) : super(message);
}

class SendTimeOutFailure extends Failure {
  SendTimeOutFailure({required String message}) : super(message);
}

class UnknownFailure extends Failure {
  UnknownFailure({required String message}) : super(message);
}

class ServerFailure extends Failure {
  ServerFailure({required String message}) : super(message);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure({required String message}) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure({required String message}) : super(message);
}
