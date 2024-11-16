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
      version: 1, // Specify the database version
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

  void addtask(String task) async {
    final db = await database;
    await db.insert(
     _taskTablename,
       Map.from({
        _tasksContentColumn: task,
        _taskStatusColumn: 0,
      }),
    );
  }

 Future<List<Task>> getTasks() async {
  final db = await database;
  final data = await db.query(_taskTablename);

  // Convert the map list to a list of Task objects
  List<Task> tasks = data.map((e) {
    return Task(
      id: e[_tasksIdColumn] as int,
      status: e[_taskStatusColumn] as int,
      content: e[_tasksContentColumn] as String,
    );
  }).toList();

  return tasks;
}

void updateTaskStatus(int id, int status) async {
  final db = await database;
  await db.update(_taskTablename,
    {
      _taskStatusColumn: status,
    },
    where: 'id = ?',
    whereArgs: [
      id,
    ]
  );
}
void deleteTask(int id) async {
  final db = await database;
  await db.delete(
    _taskTablename, 
    where: '$_tasksIdColumn =?',
     whereArgs: [id]);

}

}
