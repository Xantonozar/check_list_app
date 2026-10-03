enum TaskPriority {
  mandatory,
  high,
  medium,
  low,
}

const Map<TaskPriority, int> priorityWeights = {
  TaskPriority.mandatory: 10,
  TaskPriority.high: 7,
  TaskPriority.medium: 4,
  TaskPriority.low: 2,
};

extension TaskPriorityExtension on TaskPriority {
  String get name {
    switch (this) {
      case TaskPriority.mandatory:
        return 'mandatory';
      case TaskPriority.high:
        return 'high';
      case TaskPriority.medium:
        return 'medium';
      case TaskPriority.low:
        return 'low';
    }
  }

  static TaskPriority fromName(String name) {
    return TaskPriority.values.firstWhere(
      (e) => e.name == name,
      orElse: () => TaskPriority.low,
    );
  }
}
