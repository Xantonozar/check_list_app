import '../../core/enums/task_priority.dart';
import '../../core/models/task_model.dart';

class SuggestedTasks {
  SuggestedTasks._();

  static List<TaskModel> getHighPriorityTasks() {
    final now = DateTime.now();
    return [
      TaskModel(
        id: 'suggested_quran',
        title: 'কুরআন তিলাওয়াত',
        description: 'প্রতিদিন কমপক্ষে ১ পৃষ্ঠা কুরআন পড়া',
        priority: TaskPriority.high,
        createdAt: now,
      ),
      TaskModel(
        id: 'suggested_morning_azkar',
        title: 'সকালের আযকার',
        description: "সকালের যিকির ও দু'আ পড়া",
        priority: TaskPriority.high,
        createdAt: now,
      ),
      TaskModel(
        id: 'suggested_evening_azkar',
        title: 'সন্ধ্যার আযকার',
        description: "সন্ধ্যার যিকির ও দু'আ পড়া",
        priority: TaskPriority.high,
        createdAt: now,
      ),
    ];
  }

  static List<TaskModel> getMediumPriorityTasks() {
    final now = DateTime.now();
    return [
      TaskModel(
        id: 'suggested_tahajjud',
        title: 'তাহাজ্জুদ',
        description: 'রাতের নফল সালাত আদায় করা',
        priority: TaskPriority.medium,
        createdAt: now,
      ),
      TaskModel(
        id: 'suggested_istighfar',
        title: 'ইস্তিগফার',
        description: 'দৈনিক ১০০ বার ইস্তিগফার করা',
        priority: TaskPriority.medium,
        createdAt: now,
      ),
      TaskModel(
        id: 'suggested_durud',
        title: 'দুরুদ পাঠ',
        description: 'নবী (সা.) এর উপর দুরুদ পড়া',
        priority: TaskPriority.medium,
        createdAt: now,
      ),
      TaskModel(
        id: 'suggested_sadaqah',
        title: 'সাদাকাহ',
        description: 'দৈনিক কিছু সাদাকাহ করা',
        priority: TaskPriority.medium,
        createdAt: now,
      ),
    ];
  }

  static List<TaskModel> getLowPriorityTasks() {
    final now = DateTime.now();
    return [
      TaskModel(
        id: 'suggested_islamic_book',
        title: 'ইসলামিক বই পড়া',
        description: 'প্রতিদিন কমপক্ষে ১৫ মিনিট',
        priority: TaskPriority.low,
        createdAt: now,
      ),
      TaskModel(
        id: 'suggested_family_time',
        title: 'পরিবারকে সময় দেওয়া',
        description: 'পরিবারের সাথে মানসম্মত সময় কাটানো',
        priority: TaskPriority.low,
        createdAt: now,
      ),
      TaskModel(
        id: 'suggested_exercise',
        title: 'শারীরিক ব্যায়াম',
        description: 'সুস্থ শরীরের জন্য ব্যায়াম করা',
        priority: TaskPriority.low,
        createdAt: now,
      ),
    ];
  }

  static List<TaskModel> getAll() {
    return [
      ...getHighPriorityTasks(),
      ...getMediumPriorityTasks(),
      ...getLowPriorityTasks(),
    ];
  }
}
