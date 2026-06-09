import 'package:sqflite/sqflite.dart';

import 'sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  factory DbHelper() => _instance;

  DbHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'tangan_kebaikan.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE volunteers (
            id TEXT PRIMARY KEY,
            name TEXT,
            phone TEXT,
            skills TEXT,
            status TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE projects (
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            image TEXT
          )
        ''');
      },
    );
  }

  // ==================== OPERASI CRUD (WAJIB ADA) ====================

  // 1. CREATE (Insert Data)
  Future<int> insertVolunteer(
      Map<String, dynamic> row, dynamic instance) async {
    Database db = await instance.database;
    return await db.insert('volunteers', row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // 2. READ (Get Data)
  Future<List<Map<String, dynamic>>> queryAllVolunteers(
      dynamic instance) async {
    Database db = await instance.database;
    return await db.query('volunteers');
  }

  // 3. UPDATE (Update Data)
  Future<int> updateVolunteer(
      Map<String, dynamic> row, dynamic instance) async {
    Database db = await instance.database;
    String id = row['id'];
    return await db.update('volunteers', row, where: 'id = ?', whereArgs: [id]);
  }

  // 4. DELETE (Delete Data)
  Future<int> deleteVolunteer(String id, dynamic instance) async {
    Database db = await instance.database;
    return await db.delete('volunteers', where: 'id = ?', whereArgs: [id]);
  }
}
