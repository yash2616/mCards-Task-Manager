import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/task.dart';
import '../../domain/services/priority_service.dart';
import '../blocs/task_bloc.dart';
import '../../../../core/di/di.dart';

class AddEditTaskPage extends StatefulWidget {
  const AddEditTaskPage({super.key});

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(_dueDate == null
                        ? 'No due date'
                        : 'Due: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialDate: _dueDate ?? DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _dueDate = picked);
                      }
                    },
                    child: const Text('Pick date'),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final uuid = const Uuid().v4();
    final now = DateTime.now();
    final priorityService = sl<PriorityService>();
    final task = Task(
      id: uuid,
      title: _titleCtrl.text,
      description: _descCtrl.text.isEmpty ? null : _descCtrl.text,
      dueDate: _dueDate,
      priority: priorityService.calculateScore(
        Task(
          id: uuid,
          title: _titleCtrl.text,
          description: _descCtrl.text,
          dueDate: _dueDate,
          updatedAt: now,
        ),
      ),
      updatedAt: now,
    );
    context.read<TaskBloc>().add(AddTaskEvent(task, isOnline: true));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }
}
