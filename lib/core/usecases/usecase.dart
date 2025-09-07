import "package:book_library/core/error/failures.dart";
import "package:dartz/dartz.dart";


/// UseCase
// ignore: one_member_abstracts
abstract class UseCase<Type, Params> {

  /// call method
  Future<Either<Failure, Type>> call(final Params params);
}
