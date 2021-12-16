import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todos_sqlite/Model/todo_model.dart';

class SingletonDB {
  //convert normal class to a singleton class
  // === START
  SingletonDB._privateConstructor();
  static final SingletonDB _instance = SingletonDB._privateConstructor();
  factory SingletonDB() => _instance;
  // === END

  static Database? database;

  static String dbTable = "TODO";

  static Future<Database> initDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'todos.db'),
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE $dbTable
          (
            ${TodoField.id} INTEGER PRIMARY KEY,
            ${TodoField.title} TEXT, 
            ${TodoField.description} TEXT
          )
          ''',
        );
      },
      version: 1,
    );

    return database!;
  }

  static Future<Database> getDatabaseConnect() async {
    if (database != null) {
      return database!;
    } else {
      return await initDatabase();
    }
  }

  static Future<List<TodoModel>> showAllData() async {
    final Database db = await getDatabaseConnect();
    final List<Map<String, dynamic>> maps = await db.query('TODO');
    return List.generate(maps.length, (index) {
      return TodoModel(
        id: maps[index][TodoField.id],
        title: maps[index][TodoField.title],
        description: maps[index][TodoField.description],
      );
    });
  }

  static Future<void> insertData(TodoModel todo) async {
    final Database db = await getDatabaseConnect();
    await db.insert(
      dbTable,
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateData(TodoModel todo) async {
    final db = await getDatabaseConnect();
    await db.update(
      dbTable,
      todo.toMap(),
      where: "id = ?",
      whereArgs: [todo.id],
    );
  }

  static Future<void> deleteData(int id) async {
    final db = await getDatabaseConnect();
    await db.delete(
      dbTable,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<int> getCount() async {
    final db = await getDatabaseConnect();
    final result = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT (*) from $dbTable'));
    // print(result);
    return result as int;
  }
}
