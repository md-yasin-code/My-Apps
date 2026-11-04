class VocabularyWord {
  const VocabularyWord({required this.id, required this.level, required this.german, required this.article, required this.plural, required this.pronunciation, required this.meaningBn, required this.exampleDe, required this.exampleBn, this.wordType = 'noun', this.isFavorite = false});
  final int id;
  final String level, german, article, plural, pronunciation, meaningBn, exampleDe, exampleBn, wordType;
  final bool isFavorite;
  factory VocabularyWord.fromMap(Map<String, Object?> map) => VocabularyWord(
    id: map['id'] as int, level: map['level'] as String, german: map['german'] as String,
    article: map['article'] as String, plural: map['plural'] as String, pronunciation: map['pronunciation'] as String,
    meaningBn: map['meaning_bn'] as String, exampleDe: map['example_de'] as String, exampleBn: map['example_bn'] as String,
    wordType: (map['word_type'] as String?) ?? 'noun', isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
  );
  Map<String, Object?> toMap() => {'id': id, 'level': level, 'german': german, 'article': article, 'plural': plural, 'pronunciation': pronunciation, 'meaning_bn': meaningBn, 'example_de': exampleDe, 'example_bn': exampleBn, 'word_type': wordType, 'is_favorite': isFavorite ? 1 : 0};
}