import "dart:convert";
import "package:book_library/core/error/exceptions.dart";
import "package:book_library/features/book_library/data/models/book_model.dart";
import "package:http/http.dart" as http;

/// BookRemoteDataSource abstract class
abstract class BookRemoteDataSource {
  /// searchBooks
  Future<List<BookModel>> searchBooks(final String query, final int page);
}

/// BookRemoteDataSourceImpl class
class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  /// BookRemoteDataSourceImpl constructor
  BookRemoteDataSourceImpl({required this.client});

  /// BookRemoteDataSourceImpl client
  final http.Client client;

  @override
  Future<List<BookModel>> searchBooks(
    final String query,
    final int page,
  ) async {
    final http.Response response = await client.get(
      Uri.parse("https://openlibrary.org/search.json?q=$query&page=$page"),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final List<Map<String, dynamic>> docs = (data["docs"] as List<dynamic>)
          .cast<Map<String, dynamic>>();

      // final List<dynamic> docs = data["docs"] as List<dynamic>;
      return docs.map(BookModel.fromJson).toList();
    } else {
      throw ServerException();
    }
  }
}
