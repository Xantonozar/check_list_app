import '../../../../core/models/task_model.dart';

class TaskState {
  final List<TaskModel> tasks;
  final bool isLoading;
  final String? errorMessage;

  const TaskState({
    this.tasks = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  TaskState copyWith({
    List<TaskModel>? tasks,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  List<TaskModel> get mandatoryTasks =>
      tasks.where((t) => t.priority.name == 'mandatory').toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  List<TaskModel> get highTasks =>
      tasks.where((t) => t.priority.name == 'high').toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  List<TaskModel> get mediumTasks =>
      tasks.where((t) => t.priority.name == 'medium').toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  List<TaskModel> get lowTasks =>
      tasks.where((t) => t.priority.name == 'low').toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
}
