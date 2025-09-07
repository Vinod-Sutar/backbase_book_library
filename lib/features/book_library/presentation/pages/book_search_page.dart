import "package:book_library/features/book_library/domain/entities/book.dart";
import "package:book_library/features/book_library/presentation/bloc/book_search_bloc.dart";
import "package:book_library/features/book_library/presentation/bloc/book_search_event.dart";
import "package:book_library/features/book_library/presentation/bloc/book_search_state.dart";
import "package:book_library/features/book_library/presentation/widgets/list_item.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:shimmer/shimmer.dart";

/// BookSearchPage class
class BookSearchPage extends StatefulWidget {
  /// BookSearchPage constructor
  const BookSearchPage({super.key});

  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Book Library Search")),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Search for books...",
              border: OutlineInputBorder(),
            ),
            onSubmitted: (final String value) {
              if (value.isNotEmpty) {
                context.read<BookSearchBloc>().add(SearchBooksEvent(value));
              }
            },
          ),
          const SizedBox(height: 20),
          const Expanded(child: BooksListView()),
        ],
      ),
    ),
  );
}

/// BooksListView class
class BooksListView extends StatefulWidget {
  /// BooksListView constructor
  const BooksListView({super.key});

  @override
  State<BooksListView> createState() => _BooksListViewState();
}

class _BooksListViewState extends State<BooksListView> {
  /// controller
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels >=
    //       _scrollController.position.maxScrollExtent - 200) {
    //     context.read<BookSearchBloc>().add(FetchMoreBooksEvent());
    //   }
    // });
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshBooks() async {
    // Simulate network/API call
    // await Future.delayed(const Duration(seconds: 2));

    context.read<BookSearchBloc>().add(RefreshBooksEvent());
  }

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<BookSearchBloc, BookSearchState>(
        builder: (final BuildContext context, final BookSearchState state) {
          if (state.isLoading && state.books.isEmpty) {
            return const ShimmerLoader();
          } else if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          } else if (state.books.isEmpty) {
            return const Center(
              child: Text("Type and Enter to search the books"),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshBooks,
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.hasReachedMax
                    ? state.books.length
                    : state.books.length + 1, // show loader item
                itemBuilder: (final BuildContext context, final int index) {
                  if (index >= state.books.length) {
                    context.read<BookSearchBloc>().add(FetchMoreBooksEvent());
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final Book book = state.books[index];
                  return BookListItem(book: book);
                },
              ),
            ),
          );
        },
      );
}

/// ShimmerLoader class
class ShimmerLoader extends StatelessWidget {
  /// ShimmerLoader constructor
  const ShimmerLoader({super.key});

  @override
  Widget build(final BuildContext context) => ListView.builder(
    itemCount: 20, // Number of shimmer items
    itemBuilder: (final BuildContext context, final int index) =>
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Image placeholder
                Container(width: 30, height: 40, color: Colors.white),
                const SizedBox(width: 10),
                // Text placeholders
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 16,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(height: 16, width: 150, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}
