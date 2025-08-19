import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getAllTasks();

  Future<void> addTask(Task task, {required bool isOnline});

  Future<void> updateTask(Task task, {required bool isOnline});

  Future<void> deleteTask(String id, {required bool isOnline});
}
