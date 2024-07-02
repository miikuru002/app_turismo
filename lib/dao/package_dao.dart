import 'package:app_turismo/database/app_database.dart';
import 'package:app_turismo/models/package.dart';
import 'package:sqflite/sqflite.dart';

class PackageDao {
  Future<List<Package>> getFavoritePackages() async {
    final db = await AppDatabase.open();
    final maps = await db.query(AppDatabase.tableName);

    return maps.map((map) => Package.fromMap(map)).toList();
  }

  Future<void> insert(Package package) async {
    final db = await AppDatabase.open();
    await db.insert(AppDatabase.tableName, package.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> delete(String id) async {
    final db = await AppDatabase.open();
    await db.delete(AppDatabase.tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isFavorite(String id) async {
    final db = await AppDatabase.open();
    final maps =
        await db.query(AppDatabase.tableName, where: 'id = ?', whereArgs: [id]);

    return maps.isNotEmpty;
  }
}
