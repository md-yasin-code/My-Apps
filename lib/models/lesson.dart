class Lesson {
  const Lesson({required this.id, required this.level, required this.title, required this.summary, required this.rule, required this.example});
  final int id;
  final String level, title, summary, rule, example;

  factory Lesson.fromMap(Map<String, Object?> map) => Lesson(
    id: map['id'] as int, level: map['level'] as String, title: map['title'] as String,
    summary: map['summary'] as String, rule: map['rule'] as String, example: map['example'] as String,
  );
}
