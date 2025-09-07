import "package:book_library/core/error/failures.dart";
import "package:book_library/features/book_library/domain/entities/book.dart";
import "package:book_library/features/book_library/domain/usecases/search_books.dart";
import "package:book_library/features/book_library/presentation/bloc/book_search_event.dart";
import "package:book_library/features/book_library/presentation/bloc/book_search_state.dart";
import "package:dartz/dartz.dart";
import "package:flutter_bloc/flutter_bloc.dart";

/// BookSearchBloc class
class BookSearchBloc extends Bloc<BookSearchEvent, BookSearchState> {
  /// BookSearchBloc constructor
  BookSearchBloc({required this.searchBooks}) : super(const BookSearchState()) {
    on<SearchBooksEvent>(_onSearchBooks);
    on<FetchMoreBooksEvent>(_onFetchMoreBooks);
    on<RefreshBooksEvent>(_onRefreshBooks);
  }

  /// BookSearchBloc searchBooks
  final SearchBooksUsecase searchBooks;

  Future<void> _onRefreshBooks(
    final RefreshBooksEvent event,
    final Emitter<BookSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        books: <Book>[],
        page: 1,
        hasReachedMax: false,
      ),
    );

    final Either<Failure, List<Book>> result = await searchBooks(
      SearchBooksParams(state.query, 1),
    );

    result.fold(
      (final Failure failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (final List<Book> books) {
        emit(
          state.copyWith(
            isLoading: false,
            books: books,
            hasReachedMax: books.isEmpty,
            page: 1,
          ),
        );
      },
    );
  }

  Future<void> _onSearchBooks(
    final SearchBooksEvent event,
    final Emitter<BookSearchState> emit,
  ) async {

    emit(
      state.copyWith(
        isLoading: true,
        query: event.query,
        books: <Book>[],
        page: 1,
      ),
    );

    final Either<Failure, List<Book>> result = await searchBooks(
      SearchBooksParams(event.query, 1),
    );

    result.fold(
      (final Failure failure) {

        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (final List<Book> books) {
        emit(
          state.copyWith(
            isLoading: false,
            books: books,
            hasReachedMax: books.isEmpty,
            page: 1,
          ),
        );
      },
    );
  }

  Future<void> _onFetchMoreBooks(
    final FetchMoreBooksEvent event,
    final Emitter<BookSearchState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoading) {
      return;
    }

    emit(state.copyWith(isLoading: true));

    final int nextPage = state.page + 1;
    final Either<Failure, List<Book>> result = await searchBooks(
      SearchBooksParams(state.query, nextPage),
    );

    result.fold(
      (final Failure failure) => emit(state.copyWith(isLoading: false)),
      (final List<Book> books) {
        if (books.isEmpty) {
          emit(
            state.copyWith(
              isLoading: false,
              hasReachedMax: true,
              page: nextPage,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              books: List<Book>.of(state.books)..addAll(books),
              page: nextPage,
              hasReachedMax: false,
            ),
          );
        }
      },
    );
  }
}
