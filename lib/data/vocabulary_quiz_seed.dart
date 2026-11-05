import 'extended_vocabulary.dart';
import 'additional_vocabulary.dart';
import 'spreadsheet_vocabulary.dart';

List<Map<String, Object?>> buildExtendedVocabularyQuizSeed() {
  final allWords = <Map<String, Object?>>[...buildExtendedVocabulary(), ...additionalVocabularySeed];
  return _buildQuestions(buildExtendedVocabulary(), allWords);
}

List<Map<String, Object?>> buildVocabularyQuizSeed() {
  final allWords = <Map<String, Object?>>[...buildExtendedVocabulary(), ...additionalVocabularySeed];
  return _buildQuestions(allWords, allWords);
}

List<Map<String, Object?>> buildAdditionalVocabularyQuizSeed() {
  final allWords = <Map<String, Object?>>[...buildExtendedVocabulary(), ...additionalVocabularySeed];
  return _buildQuestions(additionalVocabularySeed, allWords, offset: buildExtendedVocabulary().length);
}

List<Map<String, Object?>> _buildQuestions(List<Map<String, Object?>> source, List<Map<String, Object?>> allWords, {int offset = 0}) {
  final questions = <Map<String, Object?>>[];
  for (var i = 0; i < source.length; i++) {
    final word = source[i];
    final globalIndex = offset + i;
    final distractorA = allWords[(globalIndex + 7) % allWords.length];
    final distractorB = allWords[(globalIndex + 19) % allWords.length];
    final options = <String>[word['german']! as String, distractorA['german']! as String, distractorB['german']! as String];
    final shift = globalIndex % 3;
    final rotated = <String>[...options.skip(shift), ...options.take(shift)];
    questions.add({'level': word['level'], 'question': 'কোন জার্মান শব্দটির অর্থ: “${word['meaning_bn']}”?', 'options': rotated.join('|'), 'answer': word['german'], 'explanation': '${word['german']} = ${word['meaning_bn']}। উদাহরণ: ${word['example_de']} — ${word['example_bn']}'});
  }
  return questions;
}
List<Map<String, Object?>> buildSpreadsheetVocabularyQuizSeed() {
  final allWords = <Map<String, Object?>>[...buildExtendedVocabulary(), ...additionalVocabularySeed, ...spreadsheetVocabularySeed];
  return _buildQuestions(spreadsheetVocabularySeed, allWords, offset: buildExtendedVocabulary().length + additionalVocabularySeed.length);
}
