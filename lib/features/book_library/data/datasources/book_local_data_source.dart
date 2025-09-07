import "package:book_library/features/book_library/data/models/book_model.dart";
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";

/// BookLocalDataSource abstract class
abstract class BookLocalDataSource {
  /// Fetch cached books
  Future<List<BookModel>> searchBooks(final String query, final int page);

  /// Save cached books
  Future<void> cacheBooks(
    final String query,
    final int page,
    final List<BookModel> books,
  );
}

/// BookLocalDataSourceImpl class
class BookLocalDataSourceImpl implements BookLocalDataSource {
  /// BookLocalDataSourceImpl constructor
  BookLocalDataSourceImpl();

  static const String _dbName = "books_cache.db";
  static const int _dbVersion = 1;
  static const String _tableName = "books";

  static Database? _database;

  /// return the database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (final Database db, final int version) async {
        await db.execute("""
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            query TEXT,
            page INTEGER,
            cover_id TEXT,
            title TEXT,
            author TEXT,
            first_publish_year INTEGER
          )
        """);
      },
    );
  }

  @override
  Future<List<BookModel>> searchBooks(
    final String query,
    final int page,
  ) async {
    final Database db = await database;

    final List<Map<String, Object?>> maps = await db.query(
      _tableName,
      where: "query = ? AND page = ?",
      whereArgs: <Object?>[query.toLowerCase(), page],
    );

    if (maps.isNotEmpty) {
      return maps
          .map(
            (final Map<String, Object?> map) => BookModel(
              coverId: map["cover_id"] as String? ?? "",
              title: map["title"] as String? ?? "",
              author: map["author"] as String? ?? "",
              firstPublishYear: map["first_publish_year"] as int?,
            ),
          )
          .toList();
    } else {
      return <BookModel>[];
    }
  }

  @override
  Future<void> cacheBooks(
    final String query,
    final int page,
    final List<BookModel> books,
  ) async {
    final Database db = await database;

    // Delete old cache for the same query+page
    await db.delete(
      _tableName,
      where: "query = ? AND page = ?",
      whereArgs: <Object?>[query.toLowerCase(), page],
    );

    for (final BookModel book in books) {
      await db.insert(_tableName, <String, Object?>{
        "query": query.toLowerCase(),
        "page": page,
        "cover_id": book.coverId,
        "title": book.title,
        "author": book.author,
        "first_publish_year": book.firstPublishYear,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}
