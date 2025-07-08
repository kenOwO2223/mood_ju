import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class JournalDetailPage extends StatelessWidget {
  final int entryKey; // Hive 的 key
  final Map<String, dynamic> entry;

  const JournalDetailPage({super.key, required this.entryKey, required this.entry});

  void _deleteEntry(BuildContext context) async {
    final journalBox = Hive.box('journalBox');

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("確認刪除"),
        content: const Text("你確定要刪除這篇日記嗎？此操作無法復原。"),
        actions: [
          TextButton(child: const Text("取消"), onPressed: () => Navigator.pop(context, false)),
          TextButton(child: const Text("刪除"), onPressed: () => Navigator.pop(context, true)),
        ],
      ),
    );

    if (confirm == true) {
      await journalBox.delete(entryKey);
      Navigator.pop(context); // 返回主畫面
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(entry['date'] ?? "") ?? DateTime.now();
    final mood = entry['mood'] ?? '🙂';
    final content = entry['content'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("詳細日記"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteEntry(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mood, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 10),
            Text("${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
