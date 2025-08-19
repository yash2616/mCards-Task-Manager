import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/services/priority_service.dart';
import '../blocs/task_bloc.dart';
import '../widgets/priority_indicator.dart';
import '../../../../core/di/di.dart';
import '../pages/add_edit_task_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final _searchCtrl = TextEditingController();
  PriorityLevel? _filter;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final priorityService = sl<PriorityService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tasks'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        actions: [
          PopupMenuButton<PriorityLevel?>(
            icon: const Icon(Icons.filter_list),
            initialValue: _filter,
            onSelected: (value) => setState(() => _filter = value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('All Priorities'),
              ),
              ...PriorityLevel.values.map(
                (e) => PopupMenuItem(
                  value: e,
                  child: Text(e.name.capitalize()),
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.status == TaskStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == TaskStatus.failure) {
            return Center(child: Text(state.message ?? 'Something went wrong'));
          }
          final tasks = state.tasks.where((task) {
            final matchesQuery = task.title
                    .toLowerCase()
                    .contains(_searchCtrl.text.toLowerCase()) ||
                (task.description ?? '')
                    .toLowerCase()
                    .contains(_searchCtrl.text.toLowerCase());
            final level = priorityService.getPriority(task);
            final matchesFilter = _filter == null || level == _filter;
            return matchesQuery && matchesFilter;
          }).toList();

          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks match'));
          }

          return ListView.separated(
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final task = tasks[index];
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

extension on String {
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
