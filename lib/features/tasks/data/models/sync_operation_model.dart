import 'dart:convert';

enum SyncOperationType { create, update, delete }

class SyncOperationModel {
  final int? id;
  final SyncOperationType operation;
  final String taskId;
  final String payload;
  final int timestamp;

  SyncOperationModel({
    this.id,
    required this.operation,
    required this.taskId,
    required this.payload,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'operation': operation.name,
        'task_id': taskId,
        'payload': payload,
        'timestamp': timestamp,
      };

  factory SyncOperationModel.fromMap(Map<String, dynamic> map) =>
      SyncOperationModel(
        id: map['id'] as int?,
        operation: SyncOperationType.values
            .firstWhere((e) => e.name == map['operation']),
        taskId: map['task_id'] as String,
        payload: map['payload'] as String,
        timestamp: map['timestamp'] as int,
      );

  String toJson() => jsonEncode(toMap());

  factory SyncOperationModel.fromJson(String source) =>
      SyncOperationModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
