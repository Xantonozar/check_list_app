class DailyReport {
  final DateTime date;
  final int totalTasks;
  final int completedTasks;
  final double score;

  const DailyReport({
    required this.date,
    required this.totalTasks,
    required this.completedTasks,
    required this.score,
  });
}

class WeeklyReport {
  final DateTime weekStart;
  final DateTime weekEnd;
  final List<DailyReport> dailyReports;
  final double averageScore;

  const WeeklyReport({
    required this.weekStart,
    required this.weekEnd,
    required this.dailyReports,
    required this.averageScore,
  });
}

class MonthlyReport {
  final int year;
  final int month;
  final List<DailyReport> dailyReports;
  final double averageScore;
  final DailyReport? bestDay;
  final DailyReport? worstDay;

  const MonthlyReport({
    required this.year,
    required this.month,
    required this.dailyReports,
    required this.averageScore,
    this.bestDay,
    this.worstDay,
  });
}
