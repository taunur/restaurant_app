import 'package:restaurant_app/data/models/restaurant_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseRestoHelper {
  static DatabaseRestoHelper? _instance;
  static Database? _database;

  DatabaseRestoHelper._internal() {
    _instance = this;
  }

  factory DatabaseRestoHelper() => _instance ?? DatabaseRestoHelper._internal();

  static const String _tblBookmark = 'bookmarks';

  /// Sesuaikan tabel database dengan data
  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restoapp.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblBookmark (
             id TEXT PRIMARY KEY,
             name TEXT,
             description TEXT,
             pictureId TEXT,
             city TEXT,
             rating DOUBLE
           )     
        ''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  /// metode-metode untuk menjalankan querydatabase
  Future<void> insertBookmarkResto(Restaurant restaurant) async {
    final db = await database;
    await db!.insert(_tblBookmark, restaurant.toJson());
  }

  /// Mendapatkan seluruh data bookmark yang tersimpan
  Future<List<Restaurant>> getBookmarksResto() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblBookmark);

    return results.map((res) => Restaurant.fromJson(res)).toList();
  }

  /// Mencari bookmark yang disimpan berdasarkan id
  Future<Map> getBookmarkById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblBookmark,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  /// hapus bookmark
  Future<void> removeBookmark(String id) async {
    final db = await database;

    await db!.delete(
      _tblBookmark,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
