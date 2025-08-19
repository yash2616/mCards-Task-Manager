import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/services/priority_service.dart';
import '../blocs/task_cubit.dart';
import '../blocs/task_state.dart';
import '../widgets/priority_indicator.dart';
import '../../../../core/di/di.dart';
import '../pages/add_edit_task_page.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Tasks')),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          switch (state.status) {
            case TaskStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case TaskStatus.failure:
              return Center(child: Text(state.message ?? 'Something went wrong'));
            case TaskStatus.success:
              if (state.tasks.isEmpty) {
                return const Center(child: Text('No tasks yet'));
              }
              final priorityService = sl<PriorityService>();
              return ListView.separated(
                itemCount: state.tasks.length,
                separatorBuilder: (_, __) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  final level = priorityService.getPriority(task);
                  return ListTile(
                    leading: PriorityIndicator(level: level),
                    title: Text(task.title),
                    subtitle: task.dueDate != null
                        ? Text('Due: ${_formatDate(task.dueDate!)}')
                        : null,
                  );
                },
              );
            case TaskStatus.initial:
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditTaskPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
