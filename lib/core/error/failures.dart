
/// Failure class
abstract class Failure {
  
  /// Failure constructor
  const Failure(this.message);

  /// Failure message
  final String message;
}

/// ServerFailure class
class ServerFailure extends Failure {
  
  /// ServerFailure constructor
  const ServerFailure(super.message);
}
