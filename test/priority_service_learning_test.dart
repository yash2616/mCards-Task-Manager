import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';

import 'package:task/features/tasks/domain/services/priority_service.dart';
import 'package:task/features/tasks/domain/services/completion_learning_service.dart';
import 'package:task/features/tasks/domain/entities/task.dart';
import 'package:task/features/tasks/domain/enums/category.dart';

class _MockLearning extends Mock implements CompletionLearningService {}

void main() {
  final sl = GetIt.instance;
  sl.reset();
  final learning = _MockLearning();
  when(() => learning.penaltyMultiplier).thenReturn(1.4);
  sl.registerSingleton<CompletionLearningService>(learning);

  final service = PriorityService();

  test('multiplier increases base score', () {
    final task = Task(id: '1', title: 'Soon', category: Category.others, dueDate: DateTime.now().add(const Duration(days: 8)), updatedAt: DateTime.now());
    final score = service.calculateScore(task);
    expect(score, greaterThan(20));
  });
}
