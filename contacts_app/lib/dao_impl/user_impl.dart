
import 'package:contactsapp/dao_interface/user_dao.dart';
import 'package:contactsapp/model/user.dart';
import 'package:contactsapp/sqlite_provider/database.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class UserDaoImpl implements UserDao {
  final DBProvider _db = DBProvider.db;

  @override
  Future<void> deleteUser(int id) async{
    final Database db = await _db.database;

    await db.delete(
      'USER',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  @override
  Future<List<User>> getUserList() async {
    final Database db = await _db.database;
    final List<Map<String, dynamic>> maps = await db.query('USER');

    // Convert the List<Map<String, dynamic> into a List<User>.
    return List.generate(maps.length, (i) {
      return User.fromId(
        id: maps[i]['id'],
        name: maps[i]['Name'],
        mobile: maps[i]['Mobile'],
        landLine: maps[i]['Landline'],
        path: maps[i]['Path'],
        fav: maps[i]['Favorite'],
      );
    });
  }

  @override
  Future<void> insertUser(User user) async {
    final Database db = await _db.database;
    try {
      await db.insert(
        'USER',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }catch(ex) {
      throw ex;
    }
  }

  @override
  Future<void> updateUser(User user) async{
    final Database db = await _db.database;
    await db.update(
      'USER',
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
    );
  }

  @override
  Future<List<User>> getFavList() async{
    int favId = 1;
    final Database db = await _db.database;
    final List<Map<String, dynamic>> maps = await db.
                                                    query('USER',
                                                      where: "Favorite = ?",
                                                      whereArgs: [favId],
                                                    );

    print('listgen size = ${maps.length}');
    // Convert the List<Map<String, dynamic> into a List<User>.
    return List.generate(maps.length, (i) {
      return User.fromId(
        id: maps[i]['id'],
        name: maps[i]['Name'],
        mobile: maps[i]['Mobile'],
        landLine: maps[i]['Landline'],
        path: maps[i]['Path'],
        fav: maps[i]['Favorite'],
      );
    });
  }
}