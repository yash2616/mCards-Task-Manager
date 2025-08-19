import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../data/datasources/sync_queue_datasource.dart';
import '../data/models/sync_operation_model.dart';
import '../data/datasources/task_local_datasource.dart';

class SyncManager {
  final SyncQueueDataSource _queue;
  final TaskLocalDataSource _local;
  late final StreamSubscription _sub;
  SyncManager(this._queue, this._local);

  void init() {
    _sub = Connectivity().onConnectivityChanged.listen((status) {
      if (status != ConnectivityResult.none) {
        _flush();
      }
    });
  }

  Future<void> _flush() async {
    final ops = await _queue.peekQueue();
    for (final op in ops) {
      switch (op.operation) {
        case SyncOperationType.create:
        case SyncOperationType.update:
          // In real app, send to backend. Here, we just mark as synced.
          await _queue.removeById(op.id!);
          break;
        case SyncOperationType.delete:
          await _queue.removeById(op.id!);
          break;
      }
    }
  }

  void dispose() {
    _sub.cancel();
  }
}
