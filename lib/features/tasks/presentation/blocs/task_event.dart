part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  const LoadTasks();
}

class AddTaskEvent extends TaskEvent {
  final Task task;
  final bool isOnline;

  const AddTaskEvent(this.task, {required this.isOnline});

  @override
  List<Object?> get props => [task, isOnline];
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;
  final bool isOnline;

  const UpdateTaskEvent(this.task, {required this.isOnline});

  @override
  List<Object?> get props => [task, isOnline];
}

class DeleteTaskEvent extends TaskEvent {
  final String id;
  final bool isOnline;

  const DeleteTaskEvent(this.id, {required this.isOnline});

  @override
  List<Object?> get props => [id, isOnline];
}
