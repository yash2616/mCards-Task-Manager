import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task/features/tasks/domain/entities/task.dart';
import 'package:task/features/tasks/domain/repositories/task_repository.dart';
import 'package:task/features/tasks/presentation/blocs/task_bloc.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class _FakeTask extends Fake implements Task {}

void registerFallbacks() {
  registerFallbackValue(_FakeTask());
}

void main() {
  late MockTaskRepository repository;
  late TaskBloc bloc;

  setUp(() {
    repository = MockTaskRepository();
    bloc = TaskBloc(repository);
    registerFallbacks();
  });

  final sampleTask = Task(
    id: '42',
    title: 'Test',
    updatedAt: DateTime.now(),
  );

  blocTest<TaskBloc, TaskState>(
    'emits [loading, success] when LoadTasks succeeds',
    build: () {
      when(() => repository.getAllTasks()).thenAnswer((_) async => [sampleTask]);
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadTasks()),
    expect: () => [
      const TaskState(status: TaskStatus.loading),
      TaskState(status: TaskStatus.success, tasks: [sampleTask]),
    ],
  );

  blocTest<TaskBloc, TaskState>(
    'emits success list after AddTaskEvent',
    build: () {
      when(() => repository.addTask(any(), isOnline: any(named: 'isOnline'))) .thenAnswer((_) async {});
      when(() => repository.getAllTasks()).thenAnswer((_) async => [sampleTask]);
      return bloc;
    },
    act: (bloc) => bloc.add(AddTaskEvent(sampleTask, isOnline: true)),
    expect: () => [
      // load triggered internally
      const TaskState(status: TaskStatus.loading),
      TaskState(status: TaskStatus.success, tasks: [sampleTask]),
    ],
  );

  blocTest<TaskBloc, TaskState>(
    'emits success list after DeleteTaskEvent',
    build: () {
      when(() => repository.deleteTask(any(), isOnline: any(named: 'isOnline'))) .thenAnswer((_) async {});
      when(() => repository.getAllTasks()).thenAnswer((_) async => []);
      return bloc;
    },
    act: (bloc) => bloc.add(DeleteTaskEvent('42', isOnline: true)),
    expect: () => [
      const TaskState(status: TaskStatus.loading),
      const TaskState(status: TaskStatus.success, tasks: []),
    ],
  );
}
