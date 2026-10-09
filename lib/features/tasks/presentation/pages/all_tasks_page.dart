import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../config/constants/app_strings.dart';
import '../../../../core/models/task_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../providers/daily_record_provider.dart';

class AllTasksPage extends ConsumerStatefulWidget {
  const AllTasksPage({super.key});

  @override
  ConsumerState<AllTasksPage> createState() => _AllTasksPageState();
}

class _AllTasksPageState extends ConsumerState<AllTasksPage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userId = authState.user?.uid ?? '';
    final taskState = ref.watch(taskProvider(userId));
    final dailyRecordState = ref.watch(dailyRecordProvider(userId));
    final dailyRecordNotifier = ref.read(dailyRecordProvider(userId).notifier);
    final theme = Theme.of(context);

    final today = DateFormat('d MMMM, yyyy', 'bn').format(DateTime.now());
    final progress = dailyRecordState.record?.score ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        centerTitle: true,
      ),
      body: taskState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.greeting,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    today,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildProgressRing(context, progress),
                  const SizedBox(height: 24),
                  if (taskState.mandatoryTasks.isNotEmpty)
                    _buildSection(
                      context,
                      'বাধ্যতামূলক',
                      taskState.mandatoryTasks,
                      dailyRecordNotifier,
                      taskState.tasks,
                      isMandatory: true,
                    ),
                  if (taskState.highTasks.isNotEmpty)
                    _buildSection(context, 'উচ্চ', taskState.highTasks, dailyRecordNotifier, taskState.tasks),
                  if (taskState.mediumTasks.isNotEmpty)
                    _buildSection(context, 'মাঝারি', taskState.mediumTasks, dailyRecordNotifier, taskState.tasks),
                  if (taskState.lowTasks.isNotEmpty)
                    _buildSection(context, 'নিম্ন', taskState.lowTasks, dailyRecordNotifier, taskState.tasks),
                  if (taskState.tasks.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 48),
                        child: Text(
                          AppStrings.noTasks,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add-task'),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: AppStrings.reports,
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'সেটিংস',
          ),
        ],
        onDestinationSelected: (index) {
          if (index == 1) context.go('/reports');
          if (index == 2) context.go('/settings');
        },
      ),
    );
  }

  Widget _buildProgressRing(BuildContext context, double progress) {
    final theme = Theme.of(context);
    return Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                value: progress / 100,
                strokeWidth: 10,
                backgroundColor: theme.colorScheme.primaryContainer,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${progress.toInt()}%',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  'আজ',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<TaskModel> tasks,
    DailyRecordNotifier dailyRecordNotifier,
    List<TaskModel> allTasks, {
    bool isMandatory = false,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isMandatory) ...[
              const SizedBox(width: 8),
              Icon(Icons.lock, size: 18, color: theme.colorScheme.onSurfaceVariant),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: tasks.map((task) {
              final isCompleted = dailyRecordNotifier.isTaskCompleted(task.id);
              return ListTile(
                leading: Checkbox(
                  value: isCompleted,
                  onChanged: (value) async {
                    await dailyRecordNotifier.toggleTask(task.id, allTasks);
                  },
                ),
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  opacity: isCompleted ? 0.5 : 1.0,
                  child: Text(
                    task.title,
                    style: TextStyle(
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ).animate(target: isCompleted ? 1 : 0)
                  .blurXY(begin: 0, end: 2, duration: 300.ms)
                  .then()
                  .shimmer(duration: 200.ms, color: Colors.white24),
                onTap: () => context.go('/task/${task.id}'),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
