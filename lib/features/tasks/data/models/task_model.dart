import 'dart:convert';

import '../../domain/entities/task.dart';
import '../../domain/enums/category.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    super.description,
    super.category = Category.others,
    super.dueDate,
    super.priority = 0,
    super.completed = false,
    required super.updatedAt,
  });

  factory TaskModel.fromEntity(Task task) => TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        category: task.category,
        dueDate: task.dueDate,
        priority: task.priority,
        completed: task.completed,
        updatedAt: task.updatedAt,
      );

  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String?,
        category: Category.values.firstWhere(
            (c) => c.name == (map['category'] as String? ?? 'others'),
            orElse: () => Category.others),
        dueDate: map['due_date'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['due_date'] as int)
            : null,
        priority: map['priority'] as int? ?? 0,
        completed: (map['completed'] as int? ?? 0) == 1,
        updatedAt:
            DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category.name,
        'due_date': dueDate?.millisecondsSinceEpoch,
        'priority': priority,
        'completed': completed ? 1 : 0,
        'updated_at': updatedAt.millisecondsSinceEpoch,
      };

  String toJson() => jsonEncode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
