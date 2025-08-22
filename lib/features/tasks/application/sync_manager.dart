import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:task/features/tasks/domain/enums/sync_operation_type.dart';

import '../data/datasources/sync_queue_datasource.dart';

class SyncManager {
  final SyncQueueDataSource _queue;
  late final StreamSubscription _sub;
  final Stream<ConnectivityResult> _stream;
  SyncManager(this._queue, [Stream<ConnectivityResult>? connectivityStream])
      : _stream = connectivityStream ?? Connectivity().onConnectivityChanged;

  void init() {
    _sub = _stream.listen((status) {
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
