import '../../core/enums/task_priority.dart';
import '../../core/models/task_model.dart';

class MandatoryTasks {
  MandatoryTasks._();

  static List<TaskModel> getDefaultTasks() {
    final now = DateTime.now();
    return [
      TaskModel(
        id: 'mandatory_fajr',
        title: 'ফজরের সালাত',
        description: 'ফজরের ফরজ সালাত আদায় করা',
        priority: TaskPriority.mandatory,
        isMandatory: true,
        createdAt: now,
      ),
      TaskModel(
        id: 'mandatory_dhuhr',
        title: 'যোহরের সালাত',
        description: 'যোহরের ফরজ সালাত আদায় করা',
        priority: TaskPriority.mandatory,
        isMandatory: true,
        createdAt: now,
      ),
      TaskModel(
        id: 'mandatory_asr',
        title: 'আসরের সালাত',
        description: 'আসরের ফরজ সালাত আদায় করা',
        priority: TaskPriority.mandatory,
        isMandatory: true,
        createdAt: now,
      ),
      TaskModel(
        id: 'mandatory_maghrib',
        title: 'মাগরিবের সালাত',
        description: 'মাগরিবের ফরজ সালাত আদায় করা',
        priority: TaskPriority.mandatory,
        isMandatory: true,
        createdAt: now,
      ),
      TaskModel(
        id: 'mandatory_isha',
        title: 'ইশার সালাত',
        description: 'ইশার ফরজ সালাত আদায় করা',
        priority: TaskPriority.mandatory,
        isMandatory: true,
        createdAt: now,
      ),
      TaskModel(
        id: 'mandatory_quran',
        title: 'কুরআন তিলাওয়াত',
        description: 'প্রতিদিন কমপক্ষে ১ পৃষ্ঠা কুরআন পড়া',
        priority: TaskPriority.mandatory,
        isMandatory: true,
        createdAt: now,
      ),
      TaskModel(
        id: 'mandatory_azkar',
        title: 'সকাল-সন্ধ্যার আযকার',
        description: "সকাল ও সন্ধ্যার যিকির ও দু'আ পড়া",
        priority: TaskPriority.mandatory,
        isMandatory: true,
        createdAt: now,
      ),
    ];
  }
}
