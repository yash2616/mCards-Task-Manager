import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task/features/tasks/domain/entities/task.dart';
import 'package:task/features/tasks/domain/repositories/task_repository.dart';
import 'package:task/features/tasks/presentation/blocs/task_bloc.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository repository;
  late TaskBloc bloc;

  setUp(() {
    repository = MockTaskRepository();
    bloc = TaskBloc(repository);
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
}
