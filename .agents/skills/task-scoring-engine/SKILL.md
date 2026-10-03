---
name: task-scoring-engine
description: >-
  Use this skill when implementing task models, priority weights, the weighted scoring formula, 
  priority-grouped UI rendering, daily completion tracking, and 7 mandatory task seed logic.
---

# Task & Scoring Engine Skill

This skill defines the business logic for daily tasks, priority weighting, and scoring in Muhasabat.

## Priority Enum & Weights

```dart
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
```

## Weighted Score Formula

```dart
class ScoreCalculator {
  static double calculateDailyScore({
    required List<TaskModel> allTasks,
    required Map<String, bool> completedStatus,
  }) {
    if (allTasks.isEmpty) return 0.0;

    int totalPossiblePoints = 0;
    int earnedPoints = 0;

    for (final task in allTasks) {
      final weight = priorityWeights[task.priority] ?? 2;
      totalPossiblePoints += weight;

      if (completedStatus[task.id] == true) {
        earnedPoints += weight;
      }
    }

    if (totalPossiblePoints == 0) return 0.0;
    final percentage = (earnedPoints / totalPossiblePoints) * 100.0;
    return double.parse(percentage.toStringAsFixed(1));
  }
}
```

## Priority Section Grouping in UI

Tasks must NOT show repetitive priority badges. Instead, group them under 4 distinct section headers:
1. **বাধ্যতামূলক (Mandatory)** — 7 pre-seeded tasks, locked, swipe-delete disabled.
2. **উচ্চ (High)** — User-added high-priority tasks.
3. **মাঝারি (Medium)** — User-added medium-priority tasks.
4. **নিম্ন (Low)** — User-added low-priority tasks.

*Note: Empty sections should be hidden from the view.*

## 7 Mandatory Seed Tasks

When a new user registers, seed these 7 immutable tasks into their database profile:
1. **ফজরের সালাত** (`mandatory`)
2. **যোহরের সালাত** (`mandatory`)
3. **আসরের সালাত** (`mandatory`)
4. **মাগরিবের সালাত** (`mandatory`)
5. **ইশার সালাত** (`mandatory`)
6. **কুরআন তিলাওয়াত** (`mandatory`)
7. **সকাল-সন্ধ্যার আযকার** (`mandatory`)
