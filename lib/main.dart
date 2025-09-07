import "package:book_library/features/book_library/data/datasources/book_local_data_source.dart";
import "package:book_library/features/book_library/data/datasources/book_remote_data_source.dart";
import "package:book_library/features/book_library/data/repositories/book_repository_impl.dart";
import "package:book_library/features/book_library/domain/usecases/search_books.dart";
import "package:book_library/features/book_library/presentation/bloc/book_search_bloc.dart";
import "package:book_library/features/book_library/presentation/pages/book_search_page.dart";
import "package:connectivity_plus/connectivity_plus.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:http/http.dart" as http;

void main() {
  final http.Client client = http.Client();
  final BookRemoteDataSourceImpl remoteDataSource = BookRemoteDataSourceImpl(
    client: client,
  );
  final BookLocalDataSourceImpl localDataSource = BookLocalDataSourceImpl();
  final BookRepositoryImpl repository = BookRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    connectivity: Connectivity(),
  );

  final SearchBooksUsecase searchBooks = SearchBooksUsecase(repository);

  runApp(BookLibraryApp(searchBooks: searchBooks));
}

/// BookLibraryApp class
class BookLibraryApp extends StatelessWidget {
  /// BookLibraryApp constructor
  const BookLibraryApp({required this.searchBooks, super.key});

  /// BookLibraryApp searchBooks
  final SearchBooksUsecase searchBooks;

  @override
  Widget build(final BuildContext context) => MaterialApp(
    title: "Flutter Demo",
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    ),
    home: BlocProvider<BookSearchBloc>(
      create: (_) => BookSearchBloc(searchBooks: searchBooks),
      child: const BookSearchPage(),
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<SearchBooksUsecase>("searchBooks", searchBooks),
    );
  }
}
