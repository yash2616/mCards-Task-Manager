part of 'task_bloc.dart';

enum TaskStatus { initial, loading, success, failure }

class TaskState extends Equatable {
  final TaskStatus status;
  final List<Task> tasks;
  final String? message;

  const TaskState({
    this.status = TaskStatus.initial,
    this.tasks = const [],
    this.message,
  });

  TaskState copyWith({
    TaskStatus? status,
    List<Task>? tasks,
    String? message,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, tasks, message];
}
