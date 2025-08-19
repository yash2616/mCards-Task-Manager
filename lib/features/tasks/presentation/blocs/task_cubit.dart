import 'package:bloc/bloc.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository _repository;

  TaskCubit(this._repository) : super(const TaskState());

  Future<void> loadTasks() async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      final tasks = await _repository.getAllTasks();
      emit(state.copyWith(status: TaskStatus.success, tasks: tasks));
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.failure, message: e.toString()));
    }
  }

  Future<void> addTask(Task task, {required bool isOnline}) async {
    await _repository.addTask(task, isOnline: isOnline);
    await loadTasks();
  }

  Future<void> updateTask(Task task, {required bool isOnline}) async {
    await _repository.updateTask(task, isOnline: isOnline);
    await loadTasks();
  }

  Future<void> deleteTask(String id, {required bool isOnline}) async {
    await _repository.deleteTask(id, isOnline: isOnline);
    await loadTasks();
  }
}
