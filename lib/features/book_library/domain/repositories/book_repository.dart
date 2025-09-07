import "package:book_library/core/error/failures.dart";
import "package:book_library/features/book_library/domain/entities/book.dart";
import "package:dartz/dartz.dart";

/// BookRepository will be used to fetch the book from the API
abstract class BookRepository {
  /// searchBooks method will either return list of books or error
  Future<Either<Failure, List<Book>>> searchBooks(
    final String query,
    final int page,
  );
}
