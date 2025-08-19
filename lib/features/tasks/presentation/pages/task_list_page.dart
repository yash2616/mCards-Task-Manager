import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task.dart';
import '../../domain/services/priority_service.dart';
import '../blocs/task_bloc.dart';
import '../pages/add_edit_task_page.dart';
import '../widgets/animated_task_tile.dart';
import '../widgets/progress_ring.dart';

enum PriorityFilter { all, low, medium, high, critical }

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final _searchCtrl = TextEditingController();
  PriorityFilter _filter = PriorityFilter.all;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          PopupMenuButton<PriorityFilter>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) => setState(() => _filter = value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: PriorityFilter.all,
                child: Text('All Priorities'),
              ),
              const PopupMenuItem(value: PriorityFilter.low, child: Text('Low')),
              const PopupMenuItem(value: PriorityFilter.medium, child: Text('Med')),
              const PopupMenuItem(value: PriorityFilter.high, child: Text('High')),
              const PopupMenuItem(value: PriorityFilter.critical, child: Text('Critical')),
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
            final level = PriorityService().getPriority(task);
            final matchesFilter = _filter == PriorityFilter.all || _filter.name == level.name;
            return matchesQuery && matchesFilter;
          }).toList();

          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks match'));
          }

          if (state.tasks.isNotEmpty) {
            final completed = state.tasks.where((t) => t.completed).length;
            final percent = completed / state.tasks.length;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: ProgressRing(progress: percent),
                ),
                Expanded(child: _buildList(tasks)),
              ],
            );
          }
          return _buildList(tasks);
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

  Widget _buildList(List<Task> tasks) {
    return ListView.separated(
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemBuilder: (context, index) => AnimatedTaskTile(task: tasks[index]),
    );
  }
}
