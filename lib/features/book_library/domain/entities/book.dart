

/// Book class
class Book {

  /// Book constructor
  Book({
    required this.coverId,
    required this.title,
    required this.author,
    this.firstPublishYear,
  });

  /// Book coverId
  final String coverId;

  /// Book title
  final String title;

  /// Book author
  final String author;

  /// Book firstPublishYear
  final int? firstPublishYear;
}
