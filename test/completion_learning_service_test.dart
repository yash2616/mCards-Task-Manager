import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:task/features/tasks/domain/services/completion_learning_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CompletionLearningService', () {
    late CompletionLearningService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      service = CompletionLearningService();
      await service.init();
    });

    test('initial penalty multiplier is 1.0 when no data', () {
      expect(service.penaltyMultiplier, 1.0);
    });

    test('recordCompletion updates multiplier when tasks are completed late', () async {
      // Arrange – task due yesterday, completed today ⇒ 1 day late.
      final due = DateTime.now().subtract(const Duration(days: 1));
      final completed = DateTime.now();
      await service.recordCompletion(dueDate: due, completedAt: completed);

      // The running average lateness is 1 day ⇒ multiplier should be > 1.0.
      expect(service.penaltyMultiplier, greaterThan(1.0));

      // Verify that the value is persisted.
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('avg_late_days'), true);
      expect(prefs.getDouble('avg_late_days')! >= 1.0, true);
    });
  });
}
