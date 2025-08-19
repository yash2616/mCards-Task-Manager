import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper.dart';
import '../models/sync_operation_model.dart';

class SyncQueueDataSource {
  final DatabaseHelper _dbHelper;
  SyncQueueDataSource(this._dbHelper);

  Future<Database> get _db async => _dbHelper.database;

  Future<void> enqueue(SyncOperationModel op) async {
    await (await _db).insert('sync_queue', op.toMap());
  }

  Future<List<SyncOperationModel>> peekQueue() async {
    final rows = await (await _db).query('sync_queue', orderBy: 'id ASC');
    return rows.map(SyncOperationModel.fromMap).toList();
  }

  Future<void> removeById(int id) async {
    await (await _db).delete('sync_queue', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clear() async {
    await (await _db).delete('sync_queue');
  }
}
