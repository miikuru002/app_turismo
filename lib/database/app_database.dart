import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const int version = 1;
  static const String dbName = "turismp.db";
  static const String tableName = "packages";

  static Future<Database> open() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, dbName);

    return await openDatabase(
      path,
      version: version,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            image TEXT
          )
        ''');
      },
    );
  }
}
