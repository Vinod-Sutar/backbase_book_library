import "package:book_library/features/book_library/domain/entities/book.dart";

/// BookModel for a datasource
class BookModel extends Book {
  /// BookModel constructor
  BookModel({
    required super.coverId,
    required super.title,
    required super.author,
    super.firstPublishYear,
  });

  /// BookModel convert from json to BookModel object
  factory BookModel.fromJson(final Map<String, dynamic> json) => BookModel(
    coverId: "${json["cover_i"]}",
    title: (json["title"] as String?) ?? "Unknown Title",

    // author: (json["author"] as String?) ?? "Unknown Author",
    author: (json["author_name"] != null && 
        (json["author_name"] as List<dynamic>).isNotEmpty)
    ? (json["author_name"] as List<dynamic>).first
    : "Unknown Author",
    firstPublishYear: json["first_publish_year"],
  );
}
