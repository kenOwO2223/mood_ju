class ReflectiveEntry {
  final String id;
  final DateTime date;
  final String event;         // 發生了什麼事？
  final String thought;       // 當時你怎麼想？
  final String feeling;       // 感覺是什麼？（情緒詞）
  final int intensity;        // 情緒強度（0~10）
  final String reaction;      // 做了什麼反應？
  final String reframe;       // 換個角度想，還能怎麼看待？

  ReflectiveEntry({
    required this.id,
    required this.date,
    required this.event,
    required this.thought,
    required this.feeling,
    required this.intensity,
    required this.reaction,
    required this.reframe,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'event': event,
        'thought': thought,
        'feeling': feeling,
        'intensity': intensity,
        'reaction': reaction,
        'reframe': reframe,
      };

  factory ReflectiveEntry.fromMap(Map<String, dynamic> map) => ReflectiveEntry(
        id: map['id'],
        date: DateTime.parse(map['date']),
        event: map['event'],
        thought: map['thought'],
        feeling: map['feeling'],
        intensity: map['intensity'],
        reaction: map['reaction'],
        reframe: map['reframe'],
      );
}
