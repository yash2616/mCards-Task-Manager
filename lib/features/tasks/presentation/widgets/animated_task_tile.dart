import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../tasks/domain/entities/task.dart';
import '../blocs/task_bloc.dart';
import '../../domain/services/priority_service.dart';
import 'priority_indicator.dart';
import '../../domain/services/completion_learning_service.dart';
import '../../../../core/di/di.dart';

class AnimatedTaskTile extends StatelessWidget {
  final Task task;
  const AnimatedTaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final priorityService = sl<PriorityService>();
    final level = priorityService.getPriority(task);

    return Dismissible(
      key: ValueKey(task.id),
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: const Icon(Icons.check, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (dir) async {
        if (dir == DismissDirection.startToEnd) {
          // Toggle completion
          final updated = task.copyWith(
            completed: !task.completed,
            updatedAt: DateTime.now(),
          );
          sl<CompletionLearningService>().recordCompletion(dueDate: task.dueDate, completedAt: DateTime.now());
          context.read<TaskBloc>().add(UpdateTaskEvent(updated, isOnline: true));
          return false; // don't remove
        } else {
          // Delete
          context.read<TaskBloc>().add(DeleteTaskEvent(task.id, isOnline: true));
          return true; // remove
        }
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: task.completed ? 0.5 : 1,
        child: ListTile(
          leading: PriorityIndicator(level: level),
          minLeadingWidth: 70,
          title: Text(
            task.title,
            style: TextStyle(
              decoration:
                  task.completed ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          subtitle: task.dueDate != null
              ? Text('Due: ${_formatDate(task.dueDate!)}')
              : null,
          trailing: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
            child: task.completed
                ? const Icon(Icons.check_circle, key: ValueKey('done'), color: Colors.green)
                : const Icon(Icons.circle_outlined, key: ValueKey('todo')),
          ),
          onTap: () {
            final updated = task.copyWith(
              completed: !task.completed,
              updatedAt: DateTime.now(),
            );
            sl<CompletionLearningService>().recordCompletion(dueDate: task.dueDate, completedAt: DateTime.now());
            context.read<TaskBloc>().add(UpdateTaskEvent(updated, isOnline: true));
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
