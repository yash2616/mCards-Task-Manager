import 'package:flutter_test/flutter_test.dart';

import 'package:task/features/tasks/presentation/blocs/task_bloc.dart';
import 'package:task/features/tasks/domain/entities/task.dart';

void main() {
  test('AddTaskEvent equality based on props', () {
    final task1 = Task(id: 'a', title: 't', updatedAt: DateTime(2025));
    final task2 = Task(id: 'a', title: 't', updatedAt: DateTime(2025));

    final e1 = AddTaskEvent(task1, isOnline: true);
    final e2 = AddTaskEvent(task2, isOnline: true);

    expect(e1, e2);
    // Different online flag should not be equal.
    final e3 = AddTaskEvent(task1, isOnline: false);
    expect(e1 == e3, isFalse);
  });

  test('DeleteTaskEvent equality based on id/flag', () {
    const e1 = DeleteTaskEvent('x', isOnline: false);
    const e2 = DeleteTaskEvent('x', isOnline: false);
    const e3 = DeleteTaskEvent('x', isOnline: true);

    expect(e1, e2);
    expect(e1 == e3, isFalse);
  });
}
