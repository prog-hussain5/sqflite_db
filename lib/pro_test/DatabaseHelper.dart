// ignore_for_file: avoid_print

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'notes.db';
  static const _databaseVersion = 1;

  static const table = 'notes';
  
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnDescription = 'description';
  static const columnCategory = 'category';
  static const columnPriority = 'priority';

  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Private constructor
  DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnDescription TEXT NOT NULL,
        $columnCategory TEXT NOT NULL,
        $columnPriority TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> update(Map<String, dynamic> row) async {
  print("Updating row with ID: ${row[columnId]}");
  print("New data: $row");
  Database db = await instance.database;
  int id = row[columnId];
  return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
}


  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> searchNotes(String keyword) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnTitle LIKE ?", whereArgs: ['%$keyword%']);
  }
}
