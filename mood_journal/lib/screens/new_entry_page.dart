import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class NewEntryPage extends StatefulWidget {
  const NewEntryPage({super.key});

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  String selectedMood = "😊";
  final TextEditingController _controller = TextEditingController();
  final Box journalBox = Hive.box('journalBox');

  void _saveEntry() {
    final newEntry = {
      'id': const Uuid().v4(),
      'date': DateTime.now().toIso8601String(),
      'mood': selectedMood,
      'content': _controller.text,
    };
    journalBox.add(newEntry);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("新增心情日記")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 心情選擇
            Wrap(
              spacing: 8,
              children: ["😄", "😐", "😢", "😡", "🥰", "😴"].map((emoji) {
                return ChoiceChip(
                  label: Text(emoji, style: const TextStyle(fontSize: 20)),
                  selected: selectedMood == emoji,
                  onSelected: (_) => setState(() => selectedMood = emoji),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // 日記輸入
            TextField(
              controller: _controller,
              maxLines: 10,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '今天的心情與想法...',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saveEntry,
              icon: const Icon(Icons.save),
              label: const Text("儲存日記"),
            )
          ],
        ),
      ),
    );
  }
}
