import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

final tasksDatabaseServiceProvider = Provider<TaskDatabaseService>((ref) {
  return TaskDatabaseService();
});

class TaskDatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, isComplete INTEGER)',
        );
      },
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Task> insertTaskAsync(Task task) async {
    final db = await database;

    final id = await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    final insertedTaskMap = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    return Task.fromMap(insertedTaskMap.first);
  }

  Future<Task> getTaskByIdAsync(int id) async {
    final db = await database;

    final taskMap = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    return Task.fromMap(taskMap.first);
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db
        .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> deleteTask(Task task) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> clearRecords() async {
    final db = await database;
    await db.delete('tasks');
  }
}
