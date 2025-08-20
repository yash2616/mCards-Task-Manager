import 'package:equatable/equatable.dart';
import '../enums/category.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  final Category category;
  final DateTime? dueDate;
  final int priority;
  final bool completed;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    this.category = Category.others,
    this.dueDate,
    this.priority = 0,
    this.completed = false,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        dueDate,
        priority,
        completed,
        updatedAt,
      ];

  Task copyWith({
    String? id,
    String? title,
    String? description,
    Category? category,
    DateTime? dueDate,
    int? priority,
    bool? completed,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
