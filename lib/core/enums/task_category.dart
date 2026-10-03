enum TaskCategory {
  salat,
  quran,
  dhikr,
  sunnah,
  social,
  personal,
  other,
}

extension TaskCategoryExtension on TaskCategory {
  String get name {
    switch (this) {
      case TaskCategory.salat:
        return 'salat';
      case TaskCategory.quran:
        return 'quran';
      case TaskCategory.dhikr:
        return 'dhikr';
      case TaskCategory.sunnah:
        return 'sunnah';
      case TaskCategory.social:
        return 'social';
      case TaskCategory.personal:
        return 'personal';
      case TaskCategory.other:
        return 'other';
    }
  }

  static TaskCategory fromName(String name) {
    return TaskCategory.values.firstWhere(
      (e) => e.name == name,
      orElse: () => TaskCategory.other,
    );
  }
}
