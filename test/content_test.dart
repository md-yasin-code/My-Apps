import 'package:flutter_test/flutter_test.dart';
import 'package:deutsch_bangla/data/extended_lessons.dart';
import 'package:deutsch_bangla/data/extended_vocabulary.dart';
import 'package:deutsch_bangla/data/additional_vocabulary.dart';
import 'package:deutsch_bangla/data/vocabulary_quiz_seed.dart';

void main() {
  test('Bundled A1-B2 curriculum seed is populated', () {
    final words = buildExtendedVocabulary();
    expect(words.length, 100);
    expect(additionalVocabularySeed.length, 40);
    expect(words.map((word) => word['level']).toSet(), containsAll(['A1', 'A2', 'B1', 'B2']));
    expect(extendedLessonSeed.length, 26);
    expect(buildVocabularyQuizSeed().length, 140);
    expect(buildAdditionalVocabularyQuizSeed().length, 40);
  });
}