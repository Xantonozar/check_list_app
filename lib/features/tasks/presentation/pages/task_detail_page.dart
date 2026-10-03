import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/enums/task_priority.dart';
import '../../../../core/models/task_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/task_provider.dart';

class TaskDetailPage extends ConsumerStatefulWidget {
  final String taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  ConsumerState<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userId = authState.user?.uid ?? '';
    final taskState = ref.watch(taskProvider(userId));
    final task = taskState.tasks.where((t) => t.id == widget.taskId).firstOrNull;
    final theme = Theme.of(context);

    if (task == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final isCompleted = ref.read(taskProvider(userId).notifier).isTaskCompleted(widget.taskId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('মুহাসাবাত'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _priorityLabel(task.priority.name),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  task.description,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
            if (task.hadithRef != null) ...[
              const SizedBox(height: 16),
              Text(
                'হাদিস রেফারেন্স',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(task.hadithRef!, style: theme.textTheme.bodyMedium),
                ),
              ),
            ],
            if (task.quranRef != null) ...[
              const SizedBox(height: 16),
              Text(
                'কুরআন রেফারেন্স',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(task.quranRef!, style: theme.textTheme.bodyMedium),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Card(
              child: SwitchListTile(
                title: const Text('সম্পন্ন হয়েছে'),
                value: isCompleted,
                onChanged: (value) {
                  ref.read(taskProvider(userId).notifier).toggleTaskCompletion(widget.taskId);
                },
              ),
            ),
            if (!task.isMandatory) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showEditDialog(context, task, userId),
                      icon: const Icon(Icons.edit),
                      label: const Text('সম্পাদনা'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showDeleteDialog(context, userId),
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('মুছুন', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, TaskModel task, String userId) {
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description);
    TaskPriority selectedPriority = task.priority;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'টাস্ক সম্পাদনা',
                    style: Theme.of(ctx).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'টাস্কের নাম'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'বিবরণ'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildPriorityChip('উচ্চ', TaskPriority.high, selectedPriority, (p) {
                        setSheetState(() => selectedPriority = p);
                      }),
                      const SizedBox(width: 8),
                      _buildPriorityChip('মাঝারি', TaskPriority.medium, selectedPriority, (p) {
                        setSheetState(() => selectedPriority = p);
                      }),
                      const SizedBox(width: 8),
                      _buildPriorityChip('নিম্ন', TaskPriority.low, selectedPriority, (p) {
                        setSheetState(() => selectedPriority = p);
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      final updatedTask = TaskModel(
                        id: task.id,
                        title: titleController.text.trim(),
                        description: descController.text.trim(),
                        priority: selectedPriority,
                        isMandatory: task.isMandatory,
                        hadithRef: task.hadithRef,
                        quranRef: task.quranRef,
                        createdAt: task.createdAt,
                        sortOrder: task.sortOrder,
                      );
                      ref.read(taskProvider(userId).notifier).updateTask(updatedTask);
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('আপডেট করুন'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPriorityChip(String label, TaskPriority priority, TaskPriority selected, Function(TaskPriority) onSelected) {
    final theme = Theme.of(context);
    final isSelected = selected == priority;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(priority),
      selectedColor: theme.colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('টাস্ক মুছুন'),
        content: const Text('আপনি কি নিশ্চিত যে এই টাস্কটি মুছে ফেলতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('বাতিল'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(taskProvider(userId).notifier).deleteTask(widget.taskId);
              Navigator.of(ctx).pop();
              context.go('/');
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('মুছুন'),
          ),
        ],
      ),
    );
  }

  String _priorityLabel(String priority) {
    switch (priority) {
      case 'mandatory':
        return 'Mandatory';
      case 'high':
        return 'High';
      case 'medium':
        return 'Medium';
      case 'low':
        return 'Low';
      default:
        return priority;
    }
  }
}
