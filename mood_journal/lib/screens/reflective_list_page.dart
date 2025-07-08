import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mood_journal/screens/reflective_detail_page.dart';

class ReflectiveListPage extends StatelessWidget {
  const ReflectiveListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reflectiveBox = Hive.box('reflectiveBox');

    return Scaffold(
      appBar: AppBar(title: const Text("反思日記列表")),
      body: ValueListenableBuilder(
        valueListenable: reflectiveBox.listenable(),
        builder: (context, box, _) {
          final entries = box.values.toList().reversed.toList();
          if (entries.isEmpty) {
            return const Center(child: Text("尚未撰寫任何反思日記"));
          }

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = Map<String, dynamic>.from(entries[index]);
              final key = box.keyAt(index);
              final date = DateTime.tryParse(entry['date']) ?? DateTime.now();
              final reframe = entry['reframe'] ?? '無';

              return ListTile(
                leading: const Icon(Icons.psychology),
                title: Text("${date.year}-${date.month}-${date.day}"),
                subtitle: Text(reframe, maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReflectiveDetailPage(entry: entry, entryKey: key),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
