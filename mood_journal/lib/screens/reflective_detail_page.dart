import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ReflectiveDetailPage extends StatelessWidget {
  final Map<String, dynamic> entry;
  final int entryKey;

  const ReflectiveDetailPage({super.key, required this.entry, required this.entryKey});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(entry['date']) ?? DateTime.now();
    final style = const TextStyle(fontSize: 16, height: 1.5);

    void deleteEntry() async {
      final box = Hive.box('reflectiveBox');
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("確認刪除"),
          content: const Text("確定要刪除這篇反思日記嗎？"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("取消")),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("刪除")),
          ],
        ),
      );
      if (confirmed == true) {
        await box.delete(entryKey);
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("日記詳情"),
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: deleteEntry),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("🗓️ 日期：${date.year}-${date.month}-${date.day}", style: style),
              const Divider(),
              Text("1️⃣ 今天發生了什麼事？", style: style.copyWith(fontWeight: FontWeight.bold)),
              Text(entry['event'] ?? '', style: style),
              const SizedBox(height: 12),
              Text("2️⃣ 當下的想法是什麼？", style: style.copyWith(fontWeight: FontWeight.bold)),
              Text(entry['thought'] ?? '', style: style),
              const SizedBox(height: 12),
              Text("3️⃣ 感覺是什麼？（${entry['feeling']}，強度 ${entry['intensity']}）", style: style),
              const SizedBox(height: 12),
              Text("4️⃣ 做了什麼反應？", style: style.copyWith(fontWeight: FontWeight.bold)),
              Text(entry['reaction'] ?? '', style: style),
              const SizedBox(height: 12),
              Text("5️⃣ 換個角度想：", style: style.copyWith(fontWeight: FontWeight.bold)),
              Text(entry['reframe'] ?? '', style: style),
            ],
          ),
        ),
      ),
    );
  }
}
