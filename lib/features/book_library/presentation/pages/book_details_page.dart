import "package:animated_book_widget/animated_book_widget.dart";
import "package:book_library/features/book_library/domain/entities/book.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

/// BookDetailsPage class
class BookDetailsPage extends StatelessWidget {
  /// BookDetailsPage constructor
  const BookDetailsPage({required this.book, super.key});

  /// BookDetailsPage book
  final Book book;

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Book Details")),
    body: AnimatedBookWidget(
      cover: CachedNetworkImage(
        // height: 50,
        width: double.infinity,
        progressIndicatorBuilder:
            (
              final BuildContext context,
              final String url,
              final DownloadProgress progress,
            ) => Center(
              child: CircularProgressIndicator(value: progress.progress),
            ),
        imageUrl: "https://covers.openlibrary.org/b/id/${book.coverId}-L.jpg",
      ),
      content: Column(
        children: <Widget>[
          const Expanded(child: SizedBox()),
          Text("Title : ${book.title}"),
          Text("Author : ${book.author}"),
          Text("Publish Year : ${book.firstPublishYear}"),
          const Expanded(child: SizedBox()),
        ],
      ),
      size: Size.infinite,
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Book>("book", book));
  }
}
