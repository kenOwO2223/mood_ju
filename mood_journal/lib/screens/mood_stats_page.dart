import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MoodStatsPage extends StatelessWidget {
  const MoodStatsPage({super.key});

  Map<String, int> _getMoodCountsThisWeek(Box box) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final Map<String, int> moodCounts = {};

    for (var entry in box.values) {
      final data = Map<String, dynamic>.from(entry);
      final date = DateTime.tryParse(data['date'] ?? '') ?? now;
      if (date.isAfter(startOfWeek.subtract(const Duration(days: 1)))) {
        final mood = data['mood'] ?? '🙂';
        moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
      }
    }
    return moodCounts;
  }

  @override
  Widget build(BuildContext context) {
    final journalBox = Hive.box('journalBox');
    final moodData = _getMoodCountsThisWeek(journalBox);
    final total = moodData.values.fold(0, (a, b) => a + b);

    final colors = [
      Colors.teal,
      Colors.orange,
      Colors.pink,
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
    ];

    final moodList = moodData.entries.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("本週心情統計")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: moodData.isEmpty
            ? const Center(child: Text("本週尚無紀錄"))
            : Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        sections: List.generate(moodList.length, (i) {
                          final mood = moodList[i].key;
                          final count = moodList[i].value;
                          final percent = (count / total) * 100;

                          return PieChartSectionData(
                            color: colors[i % colors.length],
                            value: count.toDouble(),
                            title: "$mood ${(percent).toStringAsFixed(1)}%",
                            radius: 70,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }),
                        sectionsSpace: 4,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("本週心情分布", style: TextStyle(fontSize: 16)),
                  ...moodList.map((e) => Text("${e.key}：${e.value} 次")),
                ],
              ),
      ),
    );
  }
}
