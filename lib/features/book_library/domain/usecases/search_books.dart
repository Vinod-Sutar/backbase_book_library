import "package:book_library/core/error/failures.dart";
import "package:book_library/core/usecases/usecase.dart";
import "package:book_library/features/book_library/domain/entities/book.dart";
import "package:book_library/features/book_library/domain/repositories/book_repository.dart";
import "package:dartz/dartz.dart";

/// SearchBooks usecase
class SearchBooksUsecase implements UseCase<List<Book>, SearchBooksParams> {
  /// BookRepository constructor
  SearchBooksUsecase(this.repository);

  /// BookRepository as a repository
  final BookRepository repository;

  @override
  Future<Either<Failure, List<Book>>> call(final SearchBooksParams params) =>
      repository.searchBooks(params.query, params.page);
}

/// SearchBooksParams class
class SearchBooksParams {
  /// SearchBooksParams constructor
  SearchBooksParams(this.query, this.page);

  /// SearchBooksParams query
  final String query;

  /// SearchBooksParams page
  final int page;
}
