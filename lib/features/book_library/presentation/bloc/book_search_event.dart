import "package:equatable/equatable.dart";

/// BookSearchEvent class
abstract class BookSearchEvent extends Equatable {
/// BookSearchEvent constructor
  const BookSearchEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// SearchBooksEvent class
class SearchBooksEvent extends BookSearchEvent {
/// SearchBooksEvent constructor
  const SearchBooksEvent(this.query);
/// SearchBooksEvent query
  final String query;

  @override
  List<Object?> get props => <Object?>[query];
}

/// FetchMoreBooksEvent 
class FetchMoreBooksEvent extends BookSearchEvent {}

/// RefreshBooksEvent 
class RefreshBooksEvent extends BookSearchEvent {}
