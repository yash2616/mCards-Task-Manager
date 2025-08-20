import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:task/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:task/features/tasks/data/datasources/sync_queue_datasource.dart';
import 'package:task/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:task/features/tasks/domain/entities/task.dart';
import 'package:task/features/tasks/domain/enums/category.dart';
import 'package:task/features/tasks/domain/enums/sync_operation_type.dart';
import 'package:task/features/tasks/data/models/sync_operation_model.dart';
import 'package:task/features/tasks/data/models/task_model.dart';

class _MockLocal extends Mock implements TaskLocalDataSource {}
class _MockQueue extends Mock implements SyncQueueDataSource {}

void main() {
  late _MockLocal local;
  late _MockQueue queue;
  late TaskRepositoryImpl repo;
  final sampleTask = Task(
    id: '1',
    title: 'Repo Test',
    category: Category.others,
    updatedAt: DateTime(2025),
  );

  setUp(() {
    local = _MockLocal();
    queue = _MockQueue();
    repo = TaskRepositoryImpl(localDataSource: local, syncQueueDataSource: queue);
  });

  setUpAll(() {
    registerFallbackValue(TaskModel.fromEntity(sampleTask));
    registerFallbackValue(SyncOperationModel(
      operation: SyncOperationType.create,
      taskId: 'dummy',
      payload: '{}',
      timestamp: 0,
    ));
  });

  group('addTask', () {
    test('online: only local insert', () async {
      when(() => local.insertTask(any())).thenAnswer((_) async {});
      await repo.addTask(sampleTask, isOnline: true);
      verify(() => local.insertTask(any())).called(1);
      verifyNever(() => queue.enqueue(any()));
    });

    test('offline: inserts local and queues', () async {
      when(() => local.insertTask(any())).thenAnswer((_) async {});
      when(() => queue.enqueue(any())).thenAnswer((_) async {});
      await repo.addTask(sampleTask, isOnline: false);
      verify(() => local.insertTask(any())).called(1);
      verify(() => queue.enqueue(any(that: predicate<SyncOperationModel>((op) => op.operation == SyncOperationType.create)))).called(1);
    });
  });

  group('getAllTasks', () {
    test('returns tasks from local datasource', () async {
      when(() => local.getAllTasks()).thenAnswer((_) async => []);
      final result = await repo.getAllTasks();
      expect(result, isEmpty);
    });
  });
}
