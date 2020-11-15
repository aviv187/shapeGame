import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _dbName = 'shapeDatabase.db';
  static final _dbVersion = 1;

  static final _tableName = 'myTable';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnScore = 'score';

  DatabaseHelper._privateConstractur();
  static final DatabaseHelper instance = DatabaseHelper._privateConstractur();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_tableName (
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL, 
      $columnScore TEXT NOT NULL)''');
  }

  Future insert(Map<String, dynamic> row) async {
    final Database db = await instance.database;
    await db.insert(_tableName, row);
    List<Map<String, dynamic>> scores =
        await db.query(_tableName, orderBy: 'score DESC');

    if (scores.length > 10) {
      int lastScoreId = scores[10]['_id'];
      await db.delete(_tableName, where: '_id = ?', whereArgs: [lastScoreId]);
    }
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    final Database db = await instance.database;
    return await db.query(_tableName, orderBy: 'score DESC');
  }
}
