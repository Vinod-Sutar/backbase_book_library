import "package:book_library/features/book_library/domain/entities/book.dart";
import "package:equatable/equatable.dart";

/// BookSearchState class
class BookSearchState extends Equatable {
  /// BookSearchState constructor
  const BookSearchState({
    this.books = const <Book>[],
    this.hasReachedMax = false,
    this.isLoading = false,
    this.query = "",
    this.page = 1,
    this.errorMessage,
  });

  /// BookSearchState books
  final List<Book> books;

  /// BookSearchState hasReachedMax
  final bool hasReachedMax;

  /// BookSearchState isLoading
  final bool isLoading;

  /// BookSearchState query
  final String query;

  /// BookSearchState page
  final int page;

  /// BookSearchState errorMessage
  final String? errorMessage;

  /// BookSearchState copyWith
  BookSearchState copyWith({
    final List<Book>? books,
    final bool? hasReachedMax,
    final bool? isLoading,
    final String? query,
    final int? page,
    final String? errorMessage,
  }) => BookSearchState(
    books: books ?? this.books,
    hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    isLoading: isLoading ?? this.isLoading,
    query: query ?? this.query,
    page: page ?? this.page,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => <Object?>[
    books,
    hasReachedMax,
    isLoading,
    query,
    page,
    errorMessage,
  ];
}
