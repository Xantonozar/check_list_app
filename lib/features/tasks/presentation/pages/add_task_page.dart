import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/constants/app_strings.dart';
import '../../../../config/constants/suggested_tasks.dart';
import '../../../../core/enums/task_priority.dart';
import '../../../../core/models/task_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/task_provider.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  const AddTaskPage({super.key});

  @override
  ConsumerState<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskPriority _selectedPriority = TaskPriority.high;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final authState = ref.read(authProvider);
      final userId = authState.user?.uid ?? '';
      ref.read(taskProvider(userId).notifier).addTask(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            priority: _selectedPriority,
          );
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('নতুন টাস্ক যোগ করুন'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'টাস্কের নাম',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'টাস্কের নাম দিন';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'বিবরণ',
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.priority,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPriorityChip('উচ্চ', TaskPriority.high),
                  const SizedBox(width: 8),
                  _buildPriorityChip('মাঝারি', TaskPriority.medium),
                  const SizedBox(width: 8),
                  _buildPriorityChip('নিম্ন', TaskPriority.low),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  child: const Text('সংরক্ষণ করুন'),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                AppStrings.suggestedTasks,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildSuggestedTasks(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String label, TaskPriority priority) {
    final theme = Theme.of(context);
    final isSelected = _selectedPriority == priority;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedPriority = priority);
        }
      },
      selectedColor: theme.colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildSuggestedTasks() {
    final allSuggested = SuggestedTasks.getAll();

    return Column(
      children: [
        _buildSuggestedGroup('উচ্চ', allSuggested.where((t) => t.priority == TaskPriority.high).toList()),
        _buildSuggestedGroup('মাঝারি', allSuggested.where((t) => t.priority == TaskPriority.medium).toList()),
        _buildSuggestedGroup('নিম্ন', allSuggested.where((t) => t.priority == TaskPriority.low).toList()),
      ],
    );
  }

  Widget _buildSuggestedGroup(String label, List<TaskModel> tasks) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tasks.map((task) {
            return ActionChip(
              label: Text(task.title),
              onPressed: () {
                _titleController.text = task.title;
                _descriptionController.text = task.description;
                setState(() => _selectedPriority = task.priority);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
