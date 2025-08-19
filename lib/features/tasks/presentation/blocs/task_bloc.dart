import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _repository;
  TaskBloc(this._repository) : super(const TaskState()) {
    on<LoadTasks>(_onLoad);
    on<AddTaskEvent>(_onAdd);
    on<UpdateTaskEvent>(_onUpdate);
    on<DeleteTaskEvent>(_onDelete);
  }

  Future<void> _onLoad(LoadTasks event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      final tasks = await _repository.getAllTasks();
      emit(state.copyWith(status: TaskStatus.success, tasks: tasks));
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.failure, message: e.toString()));
    }
  }

  Future<void> _onAdd(AddTaskEvent event, Emitter<TaskState> emit) async {
    await _repository.addTask(event.task, isOnline: event.isOnline);
    add(const LoadTasks());
  }

  Future<void> _onUpdate(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    await _repository.updateTask(event.task, isOnline: event.isOnline);
    add(const LoadTasks());
  }

  Future<void> _onDelete(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    await _repository.deleteTask(event.id, isOnline: event.isOnline);
    add(const LoadTasks());
  }
}
