class JournalEntry {
  final String id;
  final DateTime date;
  final String mood; // emoji or icon name
  final String content;

  JournalEntry({
    required this.id,
    required this.date,
    required this.mood,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mood': mood,
      'content': content,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      date: DateTime.parse(map['date']),
      mood: map['mood'],
      content: map['content'],
    );
  }
}
