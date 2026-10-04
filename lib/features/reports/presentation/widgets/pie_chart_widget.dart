import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/enums/task_priority.dart';

class PieChartWidget extends StatelessWidget {
  final Map<TaskPriority, int> completedByPriority;
  final Map<TaskPriority, int> missedByPriority;

  const PieChartWidget({
    super.key,
    required this.completedByPriority,
    required this.missedByPriority,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalCompleted = completedByPriority.values.fold(0, (a, b) => a + b);
    final totalMissed = missedByPriority.values.fold(0, (a, b) => a + b);
    final total = totalCompleted + totalMissed;

    if (total == 0) {
      return const Center(child: Text('কোনো ডেটা নেই'));
    }

    final sections = <PieChartSectionData>[];

    if (totalCompleted > 0) {
      sections.add(PieChartSectionData(
        value: totalCompleted.toDouble(),
        color: theme.colorScheme.primary,
        title: 'সম্পন্ন',
        radius: 60,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
      ));
    }

    if (totalMissed > 0) {
      sections.add(PieChartSectionData(
        value: totalMissed.toDouble(),
        color: const Color(0xFFE57373),
        title: 'অসম্পন্ন',
        radius: 60,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
      ));
    }

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    );
  }
}
