import 'package:uuid/uuid.dart';

import '../entities/task.dart';
import '../enums/category.dart';
import '../services/priority_service.dart';

class TaskFactory {
  TaskFactory._();
  static final _uuid = const Uuid();
  static final _priorityService = PriorityService();

  static Task create({
    required String title,
    String? description,
    Category category = Category.others,
    DateTime? dueDate,
  }) {
    final now = DateTime.now();
    final tempTask = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      category: category,
      dueDate: dueDate,
      updatedAt: now,
    );
    final scored = tempTask.copyWith(
      priority: _priorityService.calculateScore(tempTask),
    );
    return scored;
  }
}
