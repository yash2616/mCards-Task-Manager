import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:task/features/tasks/data/datasources/sync_queue_datasource.dart';
import 'package:task/core/database/database_helper.dart';
import 'package:task/features/tasks/data/models/sync_operation_model.dart';
import 'package:task/features/tasks/domain/enums/sync_operation_type.dart';

void main() {
  sqfliteFfiInit();
  late Database db;
  late SyncQueueDataSource ds;

  setUp(() async {
    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    // Minimal schema for sync_queue table
    await db.execute('''
CREATE TABLE sync_queue(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  operation TEXT NOT NULL,
  task_id TEXT NOT NULL,
  payload TEXT,
  timestamp INTEGER
)''');

    final helper = _FakeHelper(db);
    ds = SyncQueueDataSource(helper);
  });

  tearDown(() async {
    await db.close();
  });

  test('enqueue and peekQueue return inserted operation', () async {
    final op = SyncOperationModel(
      operation: SyncOperationType.create,
      taskId: '1',
      payload: '{"title":"A"}',
      timestamp: 1,
    );
    await ds.enqueue(op);

    final peeked = await ds.peekQueue();
    expect(peeked.length, 1);
    expect(peeked.first.taskId, '1');
    expect(peeked.first.operation, SyncOperationType.create);
  });

  test('removeById deletes operation', () async {
    final op = SyncOperationModel(
      operation: SyncOperationType.delete,
      taskId: '2',
      payload: '{}',
      timestamp: 2,
    );
    await ds.enqueue(op);
    var all = await ds.peekQueue();
    final id = all.first.id!; // will be autoincremented

    await ds.removeById(id);
    all = await ds.peekQueue();
    expect(all, isEmpty);
  });

  test('clear empties the queue', () async {
    final op1 = SyncOperationModel(
      operation: SyncOperationType.update,
      taskId: 'x',
      payload: '{}',
      timestamp: 3,
    );
    final op2 = SyncOperationModel(
      operation: SyncOperationType.update,
      taskId: 'y',
      payload: '{}',
      timestamp: 4,
    );
    await ds.enqueue(op1);
    await ds.enqueue(op2);

    await ds.clear();
    final remaining = await ds.peekQueue();
    expect(remaining, isEmpty);
  });
}

class _FakeHelper implements DatabaseHelper {
  final Database _db;
  _FakeHelper(this._db);

  @override
  Future<Database> get database async => _db;
}
