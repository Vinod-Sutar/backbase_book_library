import "package:book_library/core/error/exceptions.dart";
import "package:book_library/core/error/failures.dart";
import "package:book_library/features/book_library/data/datasources/book_local_data_source.dart";
import "package:book_library/features/book_library/data/datasources/book_remote_data_source.dart";
import "package:book_library/features/book_library/data/models/book_model.dart";
import "package:book_library/features/book_library/domain/entities/book.dart";
import "package:book_library/features/book_library/domain/repositories/book_repository.dart";
import "package:connectivity_plus/connectivity_plus.dart";
import "package:dartz/dartz.dart";

/// BookRepository Implementation
class BookRepositoryImpl implements BookRepository {
  /// BookRemoteDataSource constructor
  BookRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  /// BookRemoteDataSource
  final BookRemoteDataSource remoteDataSource;

  /// BookLocalDataSource
  final BookLocalDataSource localDataSource;

  /// Connectivity
  final Connectivity connectivity;

  @override
  Future<Either<Failure, List<Book>>> searchBooks(
    final String query,
    final int page,
  ) async {
    try {
      final List<ConnectivityResult> connection = await connectivity
          .checkConnectivity();

      // If offline → return cached results
      if (connection.first == ConnectivityResult.none) {
        final List<BookModel> cachedBooks = await localDataSource.searchBooks(
          query,
          page,
        );


        if (cachedBooks.isNotEmpty) {
          return Right<Failure, List<Book>>(cachedBooks);
        } else {
          return const Left<Failure, List<Book>>(
            ServerFailure("No internet and no cached data available"),
          );
        }
      }

      final List<BookModel> books = await remoteDataSource.searchBooks(
        query,
        page,
      );

      // Cache results locally
      await localDataSource.cacheBooks(query, page, books);

      return Right<Failure, List<Book>>(books);
    } on ServerException {
      return const Left<Failure, List<Book>>(
        ServerFailure("Failed to fetch books"),
      );
    }
  }
}
