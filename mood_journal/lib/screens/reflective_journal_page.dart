import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class ReflectiveJournalPage extends StatefulWidget {
  const ReflectiveJournalPage({super.key});

  @override
  State<ReflectiveJournalPage> createState() => _ReflectiveJournalPageState();
}

class _ReflectiveJournalPageState extends State<ReflectiveJournalPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // 資料欄位
  String event = '';
  String thought = '';
  String feeling = '';
  int intensity = 5;
  String reaction = '';
  String reframe = '';

  final Box reflectiveBox = Hive.box('reflectiveBox');

  void _nextPage() {
    if (_currentPage < 4) {
      setState(() => _currentPage += 1);
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _saveEntry();
    }
  }

  void _saveEntry() {
    final entry = {
      'id': const Uuid().v4(),
      'date': DateTime.now().toIso8601String(),
      'event': event,
      'thought': thought,
      'feeling': feeling,
      'intensity': intensity,
      'reaction': reaction,
      'reframe': reframe,
    };
    reflectiveBox.add(entry);
    Navigator.pop(context);
  }

  Widget _buildPage(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("步驟 ${_currentPage + 1}/5", style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(child: content),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _nextPage, child: Text(_currentPage < 4 ? "下一步" : "完成"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("五步驟反思日記")),
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildPage("今天發生了什麼事？", TextField(
            onChanged: (v) => event = v,
            maxLines: 6,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          )),
          _buildPage("你當下的想法是什麼？", TextField(
            onChanged: (v) => thought = v,
            maxLines: 6,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          )),
          _buildPage("你感覺如何？", Column(
            children: [
              DropdownButton<String>(
                value: feeling.isEmpty ? null : feeling,
                hint: const Text("選擇一個情緒"),
                onChanged: (v) => setState(() => feeling = v ?? ''),
                items: ["焦慮", "憤怒", "悲傷", "無助", "挫折", "平靜", "開心"]
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
              ),
              const SizedBox(height: 20),
              Text("情緒強度：$intensity"),
              Slider(
                value: intensity.toDouble(),
                min: 0,
                max: 10,
                divisions: 10,
                onChanged: (v) => setState(() => intensity = v.toInt()),
              )
            ],
          )),
          _buildPage("你當時的行為或反應是？", TextField(
            onChanged: (v) => reaction = v,
            maxLines: 6,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          )),
          _buildPage("換個角度想，你還能怎麼看待這件事？", TextField(
            onChanged: (v) => reframe = v,
            maxLines: 6,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          )),
        ],
      ),
    );
  }
}
