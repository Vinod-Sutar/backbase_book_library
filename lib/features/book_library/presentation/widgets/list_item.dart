import "package:book_library/features/book_library/domain/entities/book.dart";
import "package:book_library/features/book_library/presentation/pages/book_details_page.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

/// BookListItem class
class BookListItem extends StatelessWidget {

  /// BookListItem contructor
  const BookListItem({required this.book, super.key});

  /// BookListItem book
  final Book book;

  @override
  Widget build(final BuildContext context) => ListTile(
    onTap: () async {
      await Navigator.push(
        context,
        MaterialPageRoute<Widget>(
          builder: (final BuildContext context) => BookDetailsPage(book: book),
        ),
      );
    },
    leading: CachedNetworkImage(
      height: 50,
      width: 50,
      progressIndicatorBuilder:
          (
            final BuildContext context,
            final String url,
            final DownloadProgress progress,
          ) => Center(
            child: CircularProgressIndicator(value: progress.progress),
          ),
      imageUrl: "https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg",
    ),
    title: Text(book.title),
    subtitle: Text("${book.author} (${book.firstPublishYear ?? "N/A"})"),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Book>("book", book));
  }
}
