import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DBProvider {
  Database _database;

  DBProvider._();
  static final DBProvider db = DBProvider._();

  Future<Database> get database async {

    if (_database != null)
      return _database;

    _database = await _createDB();
    return _database;

  }

  _createDB() async{
    // TODO: implement createDB
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, 'user_database.db');
    return await openDatabase(path,
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE USER(id INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT NOT NULL, Mobile TEXT NOT NULL, Landline TEXT, Path TEXT, Favorite INTEGER)",
        );
      },
      version: 1,
    );
  }
}