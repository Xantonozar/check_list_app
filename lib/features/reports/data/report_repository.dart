import '../../../../core/models/report_model.dart';
import '../../../../core/utils/date_utils.dart';
import '../../tasks/data/daily_record_repository.dart';

class ReportRepository {
  final DailyRecordRepository _dailyRecordRepository;

  ReportRepository({DailyRecordRepository? dailyRecordRepository})
      : _dailyRecordRepository =
            dailyRecordRepository ?? DailyRecordRepository();

  Future<DailyReport> getDailyReport(
    String userId,
    DateTime date,
    int totalTasks,
    int completedTasks,
  ) async {
    final record = await _dailyRecordRepository.getRecord(userId, date);
    return DailyReport(
      date: date,
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      score: record?.score ?? 0.0,
    );
  }

  Future<WeeklyReport> getWeeklyReport(
    String userId,
    List<TaskModel> tasks,
  ) async {
    final now = DateTime.now();
    final weekStart = DateUtils.startOfWeek(now);
    final weekEnd = DateUtils.endOfWeek(now);
    final records = await _dailyRecordRepository.getRecordsInRange(
      userId,
      weekStart,
      weekEnd,
    );

    final dailyReports = <DailyReport>[];
    for (var i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final record = records.where((r) => DateUtils.isSameDay(r.date, date)).firstOrNull;
      final completed = record?.completedTasks.values.where((v) => v).length ?? 0;
      dailyReports.add(DailyReport(
        date: date,
        totalTasks: tasks.length,
        completedTasks: completed,
        score: record?.score ?? 0.0,
      ));
    }

    final avg = dailyReports.isEmpty
        ? 0.0
        : dailyReports.map((r) => r.score).reduce((a, b) => a + b) /
            dailyReports.length;

    return WeeklyReport(
      weekStart: weekStart,
      weekEnd: weekEnd,
      dailyReports: dailyReports,
      averageScore: double.parse(avg.toStringAsFixed(1)),
    );
  }

  Future<MonthlyReport> getMonthlyReport(
    String userId,
    List<TaskModel> tasks,
  ) async {
    final now = DateTime.now();
    final monthStart = DateUtils.startOfMonth(now);
    final monthEnd = DateUtils.endOfMonth(now);
    final records = await _dailyRecordRepository.getRecordsInRange(
      userId,
      monthStart,
      monthEnd,
    );

    final dailyReports = <DailyReport>[];
    for (var i = 0; i < 30; i++) {
      final date = monthStart.add(Duration(days: i));
      if (date.isAfter(now)) break;
      final record = records.where((r) => DateUtils.isSameDay(r.date, date)).firstOrNull;
      final completed = record?.completedTasks.values.where((v) => v).length ?? 0;
      dailyReports.add(DailyReport(
        date: date,
        totalTasks: tasks.length,
        completedTasks: completed,
        score: record?.score ?? 0.0,
      ));
    }

    final avg = dailyReports.isEmpty
        ? 0.0
        : dailyReports.map((r) => r.score).reduce((a, b) => a + b) /
            dailyReports.length;

    DailyReport? bestDay;
    DailyReport? worstDay;
    for (final r in dailyReports) {
      if (bestDay == null || r.score > bestDay.score) bestDay = r;
      if (worstDay == null || r.score < worstDay.score) worstDay = r;
    }

    return MonthlyReport(
      year: now.year,
      month: now.month,
      dailyReports: dailyReports,
      averageScore: double.parse(avg.toStringAsFixed(1)),
      bestDay: bestDay,
      worstDay: worstDay,
    );
  }
}

class TaskModel {
  final String id;
  final String title;
  final int priority;

  TaskModel({required this.id, required this.title, required this.priority});
}
