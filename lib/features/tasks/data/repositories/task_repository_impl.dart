import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../datasources/sync_queue_datasource.dart';
import '../models/task_model.dart';
import '../models/sync_operation_model.dart';
import '../../domain/enums/sync_operation_type.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;
  final SyncQueueDataSource syncQueueDataSource;

  TaskRepositoryImpl({
    required this.localDataSource,
    required this.syncQueueDataSource,
  });

  @override
  Future<List<Task>> getAllTasks() async {
    return localDataSource.getAllTasks();
  }

  @override
  Future<void> addTask(Task task, {required bool isOnline}) async {
    final model = TaskModel.fromEntity(task);
    await localDataSource.insertTask(model);
    if (!isOnline) {
      await syncQueueDataSource.enqueue(SyncOperationModel(
        operation: SyncOperationType.create,
        taskId: model.id,
        payload: model.toJson(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    }
  }

  @override
  Future<void> updateTask(Task task, {required bool isOnline}) async {
    final model = TaskModel.fromEntity(task);
    await localDataSource.updateTask(model);
    if (!isOnline) {
      await syncQueueDataSource.enqueue(SyncOperationModel(
        operation: SyncOperationType.update,
        taskId: model.id,
        payload: model.toJson(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    }
  }

  @override
  Future<void> deleteTask(String id, {required bool isOnline}) async {
    await localDataSource.deleteTask(id);
    if (!isOnline) {
      await syncQueueDataSource.enqueue(SyncOperationModel(
        operation: SyncOperationType.delete,
        taskId: id,
        payload: '',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    }
  }
}
