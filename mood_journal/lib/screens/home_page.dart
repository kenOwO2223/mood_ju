import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mood_journal/screens/new_entry_page.dart';
import 'package:mood_journal/screens/journal_detail_page.dart';
import 'package:mood_journal/screens/mood_stats_page.dart';
import 'package:mood_journal/screens/reflective_journal_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Box journalBox = Hive.box('journalBox');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("心情日記"), actions: [
        IconButton(
          icon: const Icon(Icons.pie_chart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MoodStatsPage()),
            );
          },
        ),
      ],
      
      ),
      body: ValueListenableBuilder(
        valueListenable: journalBox.listenable(),
        builder: (context, box, _) {
          final entries = box.values.toList().reversed.toList();
          if (entries.isEmpty) {
            return const Center(child: Text("尚無日記，點擊右下新增"));
          }

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = Map<String, dynamic>.from(entries[index]);
              return ListTile(
                leading: Text(entry['mood'] ?? '🙂', style: const TextStyle(fontSize: 24)),
                title: Text(entry['content'].toString().split('\n').first),
                subtitle: Text(entry['date'].toString().substring(0, 10)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => JournalDetailPage(
                        entryKey: box.keyAt(index),
                        entry: Map<String, dynamic>.from(entry),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("簡易心情日記"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const NewEntryPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.psychology),
                title: const Text("五步驟反思日記"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ReflectiveJournalPage()));
                },
              ),
            ],
          ),
        ),
        child: const Icon(Icons.add),
      ),

    );
  }
}
