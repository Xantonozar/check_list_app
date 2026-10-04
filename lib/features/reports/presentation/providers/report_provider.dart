import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/report_model.dart';
import '../../data/report_repository.dart';

class ReportState {
  final DailyReport? dailyReport;
  final WeeklyReport? weeklyReport;
  final MonthlyReport? monthlyReport;
  final bool isLoading;

  const ReportState({
    this.dailyReport,
    this.weeklyReport,
    this.monthlyReport,
    this.isLoading = false,
  });

  ReportState copyWith({
    DailyReport? dailyReport,
    WeeklyReport? weeklyReport,
    MonthlyReport? monthlyReport,
    bool? isLoading,
  }) {
    return ReportState(
      dailyReport: dailyReport ?? this.dailyReport,
      weeklyReport: weeklyReport ?? this.weeklyReport,
      monthlyReport: monthlyReport ?? this.monthlyReport,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ReportNotifier extends StateNotifier<ReportState> {
  final ReportRepository _repository;
  final String _userId;

  ReportNotifier(this._repository, this._userId) : super(const ReportState());

  Future<void> loadDailyReport(DateTime date, int totalTasks, int completedTasks) async {
    state = state.copyWith(isLoading: true);
    final report = await _repository.getDailyReport(_userId, date, totalTasks, completedTasks);
    state = state.copyWith(dailyReport: report, isLoading: false);
  }

  Future<void> loadWeeklyReport(List<TaskModel> tasks) async {
    state = state.copyWith(isLoading: true);
    final report = await _repository.getWeeklyReport(_userId, tasks);
    state = state.copyWith(weeklyReport: report, isLoading: false);
  }

  Future<void> loadMonthlyReport(List<TaskModel> tasks) async {
    state = state.copyWith(isLoading: true);
    final report = await _repository.getMonthlyReport(_userId, tasks);
    state = state.copyWith(monthlyReport: report, isLoading: false);
  }
}

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository();
});

final reportProvider = StateNotifierProvider.family<ReportNotifier, ReportState, String>(
  (ref, userId) {
    final repository = ref.watch(reportRepositoryProvider);
    return ReportNotifier(repository, userId);
  },
);
