import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'irshadat.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE irshadat (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT
          )
          ''',
        );
      },
    );
  }

  Future<void> saveIrshadat(List<Map<String, dynamic>> irshadat) async {
    final db = await database;
    await db.delete('irshadat'); // Clear existing data
    for (var item in irshadat) {
      await db.insert('irshadat', item);
    }
  }

  Future<List<Map<String, dynamic>>> getIrshadat() async {
    final db = await database;
    return db.query('irshadat');
  }
}
