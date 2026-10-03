import '../../core/enums/task_priority.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final bool isMandatory;
  final String? hadithRef;
  final String? quranRef;
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.isMandatory = false,
    this.hadithRef,
    this.quranRef,
    required this.createdAt,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    bool? isMandatory,
    String? hadithRef,
    String? quranRef,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      isMandatory: isMandatory ?? this.isMandatory,
      hadithRef: hadithRef ?? this.hadithRef,
      quranRef: quranRef ?? this.quranRef,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name,
      'isMandatory': isMandatory,
      'hadithRef': hadithRef,
      'quranRef': quranRef,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      priority: TaskPriorityExtension.fromName(map['priority'] as String),
      isMandatory: map['isMandatory'] as bool? ?? false,
      hadithRef: map['hadithRef'] as String?,
      quranRef: map['quranRef'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
