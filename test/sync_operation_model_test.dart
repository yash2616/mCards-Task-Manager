import 'package:flutter_test/flutter_test.dart';

import 'package:task/features/tasks/data/models/sync_operation_model.dart';
import 'package:task/features/tasks/domain/enums/sync_operation_type.dart';

void main() {
  group('SyncOperationModel', () {
    test('toMap and fromMap are inverse operations', () {
      final original = SyncOperationModel(
        id: 1,
        operation: SyncOperationType.create,
        taskId: 'abc',
        payload: '{"title":"Test"}',
        timestamp: 123456,
      );

      final map = original.toMap();
      final reconstructed = SyncOperationModel.fromMap(map);
      expect(reconstructed.id, original.id);
      expect(reconstructed.operation, original.operation);
      expect(reconstructed.taskId, original.taskId);
      expect(reconstructed.payload, original.payload);
      expect(reconstructed.timestamp, original.timestamp);
    });

    test('toJson and fromJson are inverse operations', () {
      final original = SyncOperationModel(
        id: 2,
        operation: SyncOperationType.update,
        taskId: 'xyz',
        payload: '{"title":"Updated"}',
        timestamp: 987654,
      );

      final json = original.toJson();
      final reconstructed = SyncOperationModel.fromJson(json);
      expect(reconstructed.id, original.id);
      expect(reconstructed.operation, original.operation);
      expect(reconstructed.taskId, original.taskId);
      expect(reconstructed.payload, original.payload);
      expect(reconstructed.timestamp, original.timestamp);
    });
  });
}
