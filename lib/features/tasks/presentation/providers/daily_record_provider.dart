import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/daily_record.dart';
import '../../../../core/models/task_model.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/score_calculator.dart';
import '../../data/daily_record_repository.dart';

class DailyRecordState {
  final DailyRecord? record;
  final bool isLoading;

  const DailyRecordState({this.record, this.isLoading = false});

  DailyRecordState copyWith({DailyRecord? record, bool? isLoading}) {
    return DailyRecordState(
      record: record ?? this.record,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DailyRecordNotifier extends StateNotifier<DailyRecordState> {
  final DailyRecordRepository _repository;
  final String _userId;
  DateTime _currentDate = DateUtils.startOfDay(DateTime.now());

  DailyRecordNotifier(this._repository, this._userId)
      : super(const DailyRecordState()) {
    _loadToday();
  }

  DateTime get currentDate => _currentDate;

  void _loadToday() {
    _currentDate = DateUtils.startOfDay(DateTime.now());
    _repository.watchRecord(_userId, _currentDate).listen((record) {
      state = state.copyWith(record: record, isLoading: false);
    });
  }

  Future<void> toggleTask(String taskId, List<TaskModel> allTasks) async {
    final today = DateUtils.startOfDay(DateTime.now());
    final currentRecord = await _repository.getRecord(_userId, today);
    final completedTasks = Map<String, bool>.from(
      currentRecord?.completedTasks ?? {},
    );

    completedTasks[taskId] = !(completedTasks[taskId] ?? false);

    final score = ScoreCalculator.calculateScore(allTasks, completedTasks);
    final record = DailyRecord(
      userId: _userId,
      date: today,
      completedTasks: completedTasks,
      score: score,
    );

    state = state.copyWith(record: record);
    await _repository.saveRecord(_userId, record);
  }

  bool isTaskCompleted(String taskId) {
    return state.record?.completedTasks[taskId] ?? false;
  }

  double get todayScore {
    return state.record?.score ?? 0.0;
  }
}

final dailyRecordRepositoryProvider = Provider<DailyRecordRepository>((ref) {
  return DailyRecordRepository();
});

final dailyRecordProvider = StateNotifierProvider.family<
    DailyRecordNotifier, DailyRecordState, String>(
  (ref, userId) {
    final repository = ref.watch(dailyRecordRepositoryProvider);
    return DailyRecordNotifier(repository, userId);
  },
);
