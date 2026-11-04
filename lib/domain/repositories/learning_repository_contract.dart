import '../../models/vocabulary_word.dart';
import '../../models/lesson.dart';
import '../../models/quiz_question.dart';

abstract interface class LearningRepositoryContract {
  Future<List<VocabularyWord>> getWords({String level, String query});
  Future<List<Lesson>> getLessons({String level});
  Future<List<QuizQuestion>> getQuiz({String level});
  Future<void> setFavorite({required String itemType, required int itemId, required bool favorite});
  Future<List<Map<String, Object?>>> getFavorites({required String itemType});
  Future<void> recordProgress({required String itemType, required int itemId, required bool correct});
  Future<Map<String, Object?>> getProgressSummary();
  Future<void> saveSetting(String key, String value);
  Future<String?> readSetting(String key);
}