abstract class Failure {
  const Failure();
  
  String get errorMessage;
}

class ServerFailure extends Failure {
  final String message;
  final int? statusCode;
  
  const ServerFailure({
    required this.message,
    this.statusCode,
  });
  
  @override
  String get errorMessage => message;
}

class NetworkFailure extends Failure {
  final String message;
  
  const NetworkFailure({
    this.message = 'Network connection failed',
  });
  
  @override
  String get errorMessage => message;
}

class CacheFailure extends Failure {
  final String message;
  
  const CacheFailure({
    this.message = 'Cache operation failed',
  });
  
  @override
  String get errorMessage => message;
}

class UnknownFailure extends Failure {
  final String message;
  
  const UnknownFailure({
    this.message = 'An unknown error occurred',
  });
  
  @override
  String get errorMessage => message;
}