import 'extended_vocabulary.dart';

List<Map<String, Object?>> buildVocabularyQuizSeed() {
  final words = buildExtendedVocabulary();
  final questions = <Map<String, Object?>>[];
  for (var i = 0; i < words.length; i++) {
    final word = words[i];
    final distractorA = words[(i + 7) % words.length];
    final distractorB = words[(i + 19) % words.length];
    final options = <String>[word['german']! as String, distractorA['german']! as String, distractorB['german']! as String];
    final shift = i % 3;
    final rotated = <String>[...options.skip(shift), ...options.take(shift)];
    questions.add({'level': word['level'], 'question': 'কোন জার্মান শব্দটির অর্থ: “${word['meaning_bn']}”?', 'options': rotated.join('|'), 'answer': word['german'], 'explanation': '${word['german']} = ${word['meaning_bn']}। উদাহরণ: ${word['example_de']} — ${word['example_bn']}'});
  }
  return questions;
}