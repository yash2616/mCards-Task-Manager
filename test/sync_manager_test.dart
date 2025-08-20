import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:task/features/tasks/data/datasources/sync_queue_datasource.dart';
import 'package:task/features/tasks/data/models/sync_operation_model.dart';
import 'package:task/features/tasks/domain/enums/sync_operation_type.dart';
import 'package:task/features/tasks/sync/sync_manager.dart';

class _MockQueue extends Mock implements SyncQueueDataSource {}

void main() {
  test('flushes queue when connectivity returns', () async {
    final queue = _MockQueue();
    final controller = StreamController<ConnectivityResult>();
    final manager = SyncManager(queue, controller.stream)
      ..init();

    final op = SyncOperationModel(
      id: 1,
      operation: SyncOperationType.create,
      taskId: '1',
      payload: '{}',
      timestamp: 0,
    );

    when(() => queue.peekQueue()).thenAnswer((_) async => [op]);
    when(() => queue.removeById(1)).thenAnswer((_) async {});

    controller.add(ConnectivityResult.wifi);
    await Future.delayed(const Duration(milliseconds: 100));

    verify(() => queue.peekQueue()).called(1);
    verify(() => queue.removeById(1)).called(1);

    manager.dispose();
    await controller.close();
  });
}
