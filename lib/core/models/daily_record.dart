class DailyRecord {
  final String userId;
  final DateTime date;
  final Map<String, bool> completedTasks;
  final double score;

  const DailyRecord({
    required this.userId,
    required this.date,
    required this.completedTasks,
    required this.score,
  });

  DailyRecord copyWith({
    String? userId,
    DateTime? date,
    Map<String, bool>? completedTasks,
    double? score,
  }) {
    return DailyRecord(
      userId: userId ?? this.userId,
      date: date ?? this.date,
      completedTasks: completedTasks ?? this.completedTasks,
      score: score ?? this.score,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': _dateToKey(date),
      'completedTasks': completedTasks,
      'score': score,
    };
  }

  factory DailyRecord.fromMap(Map<String, dynamic> map) {
    return DailyRecord(
      userId: map['userId'] as String,
      date: _dateFromKey(map['date'] as String),
      completedTasks: Map<String, bool>.from(map['completedTasks'] as Map),
      score: (map['score'] as num).toDouble(),
    );
  }

  static String _dateToKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static DateTime _dateFromKey(String key) {
    final parts = key.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
}
