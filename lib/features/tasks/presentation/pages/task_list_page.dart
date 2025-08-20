import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task.dart';
import '../../domain/services/priority_service.dart';
import '../blocs/task_bloc.dart';
import '../pages/add_edit_task_page.dart';
import '../widgets/animated_task_tile.dart';
import '../widgets/progress_ring.dart';
import '../../domain/enums/priority_filter.dart';
import '../../domain/enums/date_filter.dart';
import '../../../../core/theme/theme_cubit.dart';
import 'dart:async';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;
  PriorityFilter _filter = PriorityFilter.all;
  DateFilter _dateFilter = DateFilter.all;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
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
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  onChanged: (_) {
                    _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 300), () => setState(() {}));
                  },
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Clear filters',
            icon: const Icon(Icons.filter_alt_off),
            onPressed: () {
              setState(() {
                _filter = PriorityFilter.all;
                _dateFilter = DateFilter.all;
                _searchCtrl.clear();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeCubit>().toggle(),
          ),
          // Date filter button with indicator
          Stack(
            clipBehavior: Clip.none,
            children: [
              PopupMenuButton<DateFilter>(
                icon: const Icon(Icons.event),
                initialValue: _dateFilter,
                onSelected: (value) => setState(() => _dateFilter = value),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: DateFilter.all, child: Text('All Dates')),
                  PopupMenuItem(value: DateFilter.overdue, child: Text('Overdue')),
                  PopupMenuItem(value: DateFilter.today, child: Text('Today')),
                  PopupMenuItem(value: DateFilter.week, child: Text('This Week')),
                ],
              ),
              if (_dateFilter != DateFilter.all)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),

          // Priority filter button with indicator
          Stack(
            clipBehavior: Clip.none,
            children: [
              PopupMenuButton<PriorityFilter>(
                icon: const Icon(Icons.filter_list),
                initialValue: _filter,
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
              if (_filter != PriorityFilter.all)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
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
            final level = PriorityService().getPriority(task);
            final matchesPriority = _filter == PriorityFilter.all || _filter.name == level.name;

            final now = DateTime.now();
            bool matchesDate;
            switch (_dateFilter) {
              case DateFilter.all:
                matchesDate = true;
                break;
              case DateFilter.overdue:
                matchesDate = task.dueDate != null && task.dueDate!.isBefore(now);
                break;
              case DateFilter.today:
                matchesDate = task.dueDate != null &&
                    task.dueDate!.year == now.year &&
                    task.dueDate!.month == now.month &&
                    task.dueDate!.day == now.day;
                break;
              case DateFilter.week:
                matchesDate = task.dueDate != null &&
                    task.dueDate!.isAfter(now.subtract(Duration(days: now.weekday - 1))) &&
                    task.dueDate!.isBefore(now.add(Duration(days: 7 - now.weekday)));
                break;
            }

            return matchesQuery && matchesPriority && matchesDate;
          }).toList();

          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks found'));
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
