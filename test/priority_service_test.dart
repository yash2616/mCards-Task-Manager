import 'package:flutter_test/flutter_test.dart';
import 'package:task/features/tasks/domain/services/priority_service.dart';
import 'package:task/features/tasks/domain/entities/task.dart';
import 'package:task/features/tasks/domain/enums/priority_level.dart';

void main() {
  final service = PriorityService();
  group('PriorityService', () {
    test('returns critical for overdue tasks', () {
      final task = Task(
        id: '1',
        title: 'Overdue',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      );
      expect(service.getPriority(task), PriorityLevel.critical);
    });

    test('returns high for due today', () {
      final task = Task(
        id: '2',
        title: 'Today',
        dueDate: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(service.getPriority(task), PriorityLevel.critical);
    });

    test('returns medium for due in 5 days', () {
      final task = Task(
        id: '3',
        title: 'Soon',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        updatedAt: DateTime.now(),
      );
      expect(service.getPriority(task), PriorityLevel.medium);
    });
  });
}
