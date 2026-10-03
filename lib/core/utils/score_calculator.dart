import '../enums/task_priority.dart';
import '../models/task_model.dart';

class ScoreCalculator {
  ScoreCalculator._();

  static double calculateScore(
    List<TaskModel> allTasks,
    Map<String, bool> completedTasks,
  ) {
    if (allTasks.isEmpty) return 0.0;

    int totalWeight = 0;
    int completedWeight = 0;

    for (final task in allTasks) {
      final weight = priorityWeights[task.priority] ?? 0;
      totalWeight += weight;
      if (completedTasks[task.id] == true) {
        completedWeight += weight;
      }
    }

    if (totalWeight == 0) return 0.0;
    return (completedWeight / totalWeight) * 100;
  }

  static double calculateScoreFromWeights(
    int completedWeight,
    int totalWeight,
  ) {
    if (totalWeight == 0) return 0.0;
    return (completedWeight / totalWeight) * 100;
  }
}
