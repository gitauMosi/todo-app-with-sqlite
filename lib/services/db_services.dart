import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DatabaseServices {
  static Database? _db;
  static final DatabaseServices instance = DatabaseServices._constructor();

  final String _taskTablename = "tasks";
  final String _tasksIdColumn = "id";
  final String _tasksContentColumn = "content";
  final String _taskStatusColumn = "status";

  DatabaseServices._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE IF NOT EXISTS $_taskTablename (
            $_tasksIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
            $_tasksContentColumn TEXT NOT NULL,
            $_taskStatusColumn INTEGER NOT NULL
          );
        ''');
      },
    );
    return database;
  }

  Future<int> addTask(String task) async {
    try {
      final db = await database;
      return await db.insert(
        _taskTablename,
        {
          _tasksContentColumn: task,
          _taskStatusColumn: 0,
        },
      );
    } catch (e) {
      print('Error adding task: $e');
      return -1; // Return an invalid ID
    }
  }

  Future<List<Task>> getTasks() async {
    try {
      final db = await database;
      final data = await db.query(_taskTablename);
      return data.map((e) => Task(
        id: e[_tasksIdColumn] as int,
        status: e[_taskStatusColumn] as int,
        content: e[_tasksContentColumn] as String,
      )).toList();
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  Future<void> updateTaskStatus(int id, int status) async {
    try {
      final db = await database;
      await db.update(
        _taskTablename,
        {_taskStatusColumn: status},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error updating task status: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final db = await database;
      await db.delete(
        _taskTablename,
        where: '$_tasksIdColumn = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting task: $e');
    }
  }
}
