import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper.dart';
import '../models/task_model.dart';

class TaskLocalDataSource {
  final DatabaseHelper _dbHelper;
  TaskLocalDataSource(this._dbHelper);

  Future<Database> get _db async => _dbHelper.database;

  Future<List<TaskModel>> getAllTasks() async {
    final rows = await (await _db).query('tasks');
    return rows.map(TaskModel.fromMap).toList();
  }

  Future<void> insertTask(TaskModel task) async {
    await (await _db).insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(TaskModel task) async {
    await (await _db).update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(String id) async {
    await (await _db).delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
