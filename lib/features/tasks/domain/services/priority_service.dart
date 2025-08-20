import 'package:task/features/tasks/domain/enums/priority_level.dart';
import 'package:task/features/tasks/domain/entities/task.dart';
import 'completion_learning_service.dart';
import '../../../../core/di/di.dart';

class PriorityService {
  final CompletionLearningService learningService;

  PriorityService() : learningService = sl<CompletionLearningService>();

  PriorityService.withLearning(this.learningService);

  /// Returns an integer score (higher = more urgent) based on due date proximity
  /// and completion history (future enhancement).
  int calculateScore(Task task) {
    if (task.dueDate == null) return 0;

    final now = DateTime.now();
    final difference = task.dueDate!.difference(now).inDays;

    // Simple heuristic:
    // Overdue: +100
    // Due today: +80
    // Due within 3 days: +60
    // Due within 7 days: +40
    // Otherwise: +20
    if (difference < 0) return 100;
    if (difference == 0) return 80;
    if (difference <= 3) return 60;
    if (difference <= 7) return 40;
    var base = 20;

    // apply multiplier based on historical lateness
    base = (base * learningService.penaltyMultiplier).round();
    return base;
  }

  PriorityLevel getPriority(Task task) {
    final score = calculateScore(task);
    if (score >= 80) return PriorityLevel.critical;
    if (score >= 60) return PriorityLevel.high;
    if (score >= 40) return PriorityLevel.medium;
    return PriorityLevel.low;
  }
}
