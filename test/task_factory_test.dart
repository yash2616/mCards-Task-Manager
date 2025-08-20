import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';

import 'package:task/features/tasks/domain/factories/task_factory.dart';
import 'package:task/features/tasks/domain/services/completion_learning_service.dart';
import 'package:task/features/tasks/domain/entities/task.dart';

class _MockLearning extends Mock implements CompletionLearningService {}

void main() {
  final sl = GetIt.instance;
  setUp(() {
    sl.reset();
    final learning = _MockLearning();
    // Neutral multiplier so base calculation unchanged.
    when(() => learning.penaltyMultiplier).thenReturn(1.0);
    sl.registerSingleton<CompletionLearningService>(learning);
  });

  test('create returns task with unique id and computed priority', () {
    // Act
    final task = TaskFactory.create(title: 'Test task');

    // Assert
    expect(task.id, isNotEmpty);
    expect(task.priority, greaterThanOrEqualTo(0));
    expect(task, isA<Task>());
  });
}
