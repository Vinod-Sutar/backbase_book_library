import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:book_library/features/book_library/domain/entities/book.dart';
import 'package:book_library/features/book_library/domain/repositories/book_repository.dart';
import 'package:book_library/features/book_library/domain/usecases/search_books.dart';
import 'package:book_library/core/error/failures.dart';

@GenerateMocks([BookRepository])
import 'search_books_test.mocks.dart';

void main() {
  late SearchBooksUsecase usecase;
  late MockBookRepository mockBookRepository;

  setUp(() {
    mockBookRepository = MockBookRepository();
    usecase = SearchBooksUsecase(mockBookRepository);
  });

  const tQuery = "flutter";
  const tPage = 1;

  final tBooks = [
    Book(coverId: "1234", title: "Flutter in Action", author: "Eric Windmill", firstPublishYear: 2019),
    Book(coverId: "4567", title: "Pragmatic Flutter", author: "Priyanka Tyagi", firstPublishYear: 2020),
  ];

  test(
    'should get list of books from the repository',
    () async {
      // arrange
      when(mockBookRepository.searchBooks(tQuery, tPage))
          .thenAnswer((_) async => Right(tBooks));

      // act
      final result = await usecase(SearchBooksParams(tQuery, tPage));

      // assert
      expect(result, Right(tBooks));
      verify(mockBookRepository.searchBooks(tQuery, tPage));
      verifyNoMoreInteractions(mockBookRepository);
    },
  );

  test(
    'should return failure when repository fails',
    () async {
      // arrange
      when(mockBookRepository.searchBooks(tQuery, tPage))
          .thenAnswer((_) async => const Left(ServerFailure("Error")));

      // act
      final result = await usecase(SearchBooksParams(tQuery, tPage));

      // assert
      expect(result, const Left(ServerFailure("Error")));
      verify(mockBookRepository.searchBooks(tQuery, tPage));
      verifyNoMoreInteractions(mockBookRepository);
    },
  );
}
