import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'actions.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE actions(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, type TEXT, date TEXT)",
        );
      },
    );
  }

  Future<void> insertAction(String text, String type, String date) async {
    final db = await database;
    await db.insert(
      'actions',
      {'text': text, 'type': type, 'date': date},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchAllActions() async {
    final db = await database;
    final List<Map<String, dynamic>> actions = await db.query('actions');
    print("Stored Actions in DB: $actions");
    return actions;
  }

  Future<void> deleteAction(int id) async {
    final db = await database;
    await db.delete('actions', where: "id = ?", whereArgs: [id]);
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('actions');
  }
}
