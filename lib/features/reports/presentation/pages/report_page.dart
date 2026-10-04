import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/task_priority.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../tasks/presentation/providers/task_provider.dart';
import '../../../tasks/presentation/providers/daily_record_provider.dart';
import '../../data/report_repository.dart';
import '../providers/report_provider.dart';
import '../widgets/pie_chart_widget.dart';
import '../widgets/bar_chart_widget.dart';
import '../widgets/stats_card.dart';

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      _loadData();
    }
  }

  bool _hasData(int index) {
    final authState = ref.read(authProvider);
    final userId = authState.user?.uid ?? '';
    final state = ref.read(reportProvider(userId));
    switch (index) {
      case 0:
        return state.dailyReport != null;
      case 1:
        return state.weeklyReport != null;
      case 2:
        return state.monthlyReport != null;
      default:
        return false;
    }
  }

  void _loadData() {
    final authState = ref.read(authProvider);
    final userId = authState.user?.uid ?? '';
    final taskState = ref.read(taskProvider(userId));
    final dailyRecordState = ref.read(dailyRecordProvider(userId));
    final reportNotifier = ref.read(reportProvider(userId).notifier);

    final completedTasks = dailyRecordState.record?.completedTasks.values.where((v) => v).length ?? 0;

    switch (_tabController.index) {
      case 0:
        reportNotifier.loadDailyReport(DateTime.now(), taskState.tasks.length, completedTasks);
        break;
      case 1:
        reportNotifier.loadWeeklyReport(taskState.tasks.map((t) => TaskModel(id: t.id, title: t.title, priority: t.priority.index)).toList());
        break;
      case 2:
        reportNotifier.loadMonthlyReport(taskState.tasks.map((t) => TaskModel(id: t.id, title: t.title, priority: t.priority.index)).toList());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userId = authState.user?.uid ?? '';
    final reportState = ref.watch(reportProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('রিপোর্ট'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'দৈনিক'),
              Tab(text: 'সাপ্তাহিক'),
              Tab(text: 'মাসিক'),
            ],
          ),
        ),
      ),
      body: reportState.isLoading && !_hasData(_tabController.index)
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildDailyTab(context, reportState),
                _buildWeeklyTab(context, reportState),
                _buildMonthlyTab(context, reportState),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('শীঘ্রই আসছে...')),
            );
          },
          icon: const Icon(Icons.download),
          label: const Text('গুগল শিটে ডাউনলোড করুন'),
        ),
      ),
    );
  }

  Widget _buildDailyTab(BuildContext context, ReportState reportState) {
    final theme = Theme.of(context);
    final report = reportState.dailyReport;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    '${report?.score.toStringAsFixed(1) ?? '0.0'}%',
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'গতকালের স্কোর',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PIE CHART',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  PieChartWidget(
                    completedByPriority: _getCompletedByPriority(),
                    missedByPriority: _getMissedByPriority(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BarChartWidget(
                dailyReports: report != null ? [report] : [],
                title: 'BAR CHART',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTab(BuildContext context, ReportState reportState) {
    final theme = Theme.of(context);
    final report = reportState.weeklyReport;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    '${report?.averageScore.toStringAsFixed(1) ?? '0.0'}%',
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'সাপ্তাহিক গড়',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BarChartWidget(
                dailyReports: report?.dailyReports ?? [],
                title: 'সাপ্তাহিক স্কোর',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTab(BuildContext context, ReportState reportState) {
    final theme = Theme.of(context);
    final report = reportState.monthlyReport;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: 'গড় স্কোর',
                  value: '${report?.averageScore.toStringAsFixed(1) ?? '0.0'}%',
                  icon: Icons.trending_up,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatsCard(
                  title: 'সেরা দিন',
                  value: report?.bestDay != null
                      ? '${report!.bestDay!.score.toStringAsFixed(1)}%'
                      : '0.0%',
                  icon: Icons.star,
                  iconColor: Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: 'খারাপ দিন',
                  value: report?.worstDay != null
                      ? '${report!.worstDay!.score.toStringAsFixed(1)}%'
                      : '0.0%',
                  icon: Icons.trending_down,
                  iconColor: theme.colorScheme.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatsCard(
                  title: 'মোট দিন',
                  value: '${report?.dailyReports.length ?? 0}',
                  icon: Icons.calendar_today,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BarChartWidget(
                dailyReports: report?.dailyReports ?? [],
                title: 'মাসিক ট্রেন্ড',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<TaskPriority, int> _getCompletedByPriority() {
    final authState = ref.read(authProvider);
    final userId = authState.user?.uid ?? '';
    final taskState = ref.read(taskProvider(userId));
    final dailyRecordState = ref.read(dailyRecordProvider(userId));
    final completed = <TaskPriority, int>{};

    for (final task in taskState.tasks) {
      if (dailyRecordState.record?.completedTasks[task.id] == true) {
        completed[task.priority] = (completed[task.priority] ?? 0) + 1;
      }
    }
    return completed;
  }

  Map<TaskPriority, int> _getMissedByPriority() {
    final authState = ref.read(authProvider);
    final userId = authState.user?.uid ?? '';
    final taskState = ref.read(taskProvider(userId));
    final dailyRecordState = ref.read(dailyRecordProvider(userId));
    final missed = <TaskPriority, int>{};

    for (final task in taskState.tasks) {
      if (dailyRecordState.record?.completedTasks[task.id] != true) {
        missed[task.priority] = (missed[task.priority] ?? 0) + 1;
      }
    }
    return missed;
  }
}
