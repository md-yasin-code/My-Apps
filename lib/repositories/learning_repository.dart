import 'package:sqflite/sqflite.dart';
import '../data/app_database.dart';
import '../models/vocabulary_word.dart';
import '../models/lesson.dart';
import '../models/quiz_question.dart';
import '../domain/repositories/learning_repository_contract.dart';

class LearningRepository implements LearningRepositoryContract {
  LearningRepository(this._source);
  final AppDatabase _source;
  Future<void> initialize() async { await _source.database; }

  Future<List<VocabularyWord>> getWords({String level = 'All', String query = '', String wordType = 'All'}) async {
    final db = await _source.database;
    final where = <String>[]; final args = <Object?>[];
    if (level != 'All') { where.add('level = ?'); args.add(level); }
    if (query.trim().isNotEmpty) { where.add('(german LIKE ? OR meaning_bn LIKE ?)'); args..add('%${query.trim()}%')..add('%${query.trim()}%'); }
    if (wordType != 'All') { where.add('word_type = ?'); args.add(wordType); }
    final rows = await db.query('vocabulary', where: where.isEmpty ? null : where.join(' AND '), whereArgs: args, orderBy: 'level, german');
    return rows.map(VocabularyWord.fromMap).toList();
  }
  Future<List<Lesson>> getLessons({String level = 'All'}) async {
    final db = await _source.database;
    final rows = await db.query('lessons', where: level == 'All' ? null : 'level = ?', whereArgs: level == 'All' ? null : [level], orderBy: 'level, id');
    return rows.map(Lesson.fromMap).toList();
  }
  Future<List<QuizQuestion>> getQuiz({String level = 'All'}) async {
    final db = await _source.database;
    final rows = await db.query('quizzes', where: level == 'All' ? null : 'level = ?', whereArgs: level == 'All' ? null : [level]);
    return rows.map((r) => QuizQuestion(id: r['id'] as int, level: r['level'] as String, question: r['question'] as String, options: (r['options'] as String).split('|'), answer: r['answer'] as String, explanation: r['explanation'] as String)).toList();
  }
  Future<List<VocabularyWord>> getDueWords() async {
    final db = await _source.database;
    final now = DateTime.now().toIso8601String();
    final rows = await db.rawQuery('SELECT v.* FROM vocabulary v LEFT JOIN learning_progress p ON p.item_type = ? AND p.item_id = v.id WHERE p.id IS NULL OR p.due_at IS NULL OR p.due_at <= ? ORDER BY COALESCE(p.due_at, ?), v.level LIMIT 50', ['word', now, now]);
    return rows.map(VocabularyWord.fromMap).toList();
  }
  Future<void> setFavorite({required String itemType, required int itemId, required bool favorite}) async {
    if (!['word', 'lesson'].contains(itemType)) throw ArgumentError.value(itemType, 'itemType');
    final db = await _source.database;
    await db.update(itemType == 'word' ? 'vocabulary' : 'lessons', {'is_favorite': favorite ? 1 : 0}, where: 'id = ?', whereArgs: [itemId]);
  }
  Future<List<Map<String, Object?>>> getFavorites({required String itemType}) async {
    if (!['word', 'lesson'].contains(itemType)) throw ArgumentError.value(itemType, 'itemType');
    final db = await _source.database;
    return db.query(itemType == 'word' ? 'vocabulary' : 'lessons', where: 'is_favorite = 1', orderBy: 'level, id');
  }
  Future<void> recordProgress({required String itemType, required int itemId, required bool correct}) async {
    if (!['word', 'lesson', 'quiz'].contains(itemType)) throw ArgumentError.value(itemType, 'itemType');
    final db = await _source.database; final now = DateTime.now(); final today = now.toIso8601String().substring(0, 10);
    await db.transaction((txn) async {
      final existing = await txn.query('learning_progress', where: 'item_type = ? AND item_id = ?', whereArgs: [itemType, itemId], limit: 1);
      final previous = existing.isEmpty ? <String, Object?>{} : existing.first;
      await txn.insert('learning_progress', {'item_type': itemType, 'item_id': itemId, 'status': correct ? 'learning' : 'review', 'repetitions': ((previous['repetitions'] as int?) ?? 0) + 1, 'correct_count': ((previous['correct_count'] as int?) ?? 0) + (correct ? 1 : 0), 'wrong_count': ((previous['wrong_count'] as int?) ?? 0) + (correct ? 0 : 1), 'due_at': now.add(Duration(days: correct ? 2 : 0)).toIso8601String(), 'updated_at': now.toIso8601String()}, conflictAlgorithm: ConflictAlgorithm.replace);
      await txn.rawInsert('INSERT INTO daily_activity (activity_date, minutes, words_reviewed, quiz_correct, quiz_total) VALUES (?, ?, ?, ?, ?) ON CONFLICT(activity_date) DO UPDATE SET minutes = minutes + excluded.minutes, words_reviewed = words_reviewed + excluded.words_reviewed, quiz_correct = quiz_correct + excluded.quiz_correct, quiz_total = quiz_total + excluded.quiz_total', [today, itemType == 'lesson' ? 1 : 0, itemType == 'word' ? 1 : 0, itemType == 'quiz' && correct ? 1 : 0, itemType == 'quiz' ? 1 : 0]);
    });
  }
  Future<Map<String, Object?>> getProgressSummary() async {
    final db = await _source.database;
    final words = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM learning_progress WHERE item_type='word' AND status='learning'")) ?? 0;
    final lessons = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM learning_progress WHERE item_type='lesson'")) ?? 0;
    final totals = (await db.rawQuery('SELECT COALESCE(SUM(quiz_correct),0) AS correct, COALESCE(SUM(quiz_total),0) AS total FROM daily_activity')).first;
    final activeRows = await db.query('daily_activity', columns: ['activity_date'], where: 'minutes > 0 OR words_reviewed > 0 OR quiz_total > 0', orderBy: 'activity_date DESC');
    final activeDates = activeRows.map((row) => row['activity_date'] as String).toSet();
    final today = DateTime.now();
    final todayKey = today.toIso8601String().substring(0, 10);
    final todayWords = Sqflite.firstIntValue(await db.rawQuery('SELECT COALESCE(words_reviewed,0) FROM daily_activity WHERE activity_date = ?', [todayKey])) ?? 0;
    var cursor = DateTime(today.year, today.month, today.day);
    if (!activeDates.contains(todayKey)) cursor = cursor.subtract(const Duration(days: 1));
    var streak = 0;
    while (activeDates.contains(cursor.toIso8601String().substring(0, 10))) { streak++; cursor = cursor.subtract(const Duration(days: 1)); }
    final levelProgress = <Map<String, Object?>>[];
    for (final level in ['A1', 'A2', 'B1', 'B2']) {
      final levelWords = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM learning_progress p JOIN vocabulary v ON v.id = p.item_id WHERE p.item_type='word' AND p.status='learning' AND v.level = ?", [level])) ?? 0;
      final levelLessons = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM learning_progress p JOIN lessons l ON l.id = p.item_id WHERE p.item_type='lesson' AND l.level = ?", [level])) ?? 0;
      final levelQuiz = (await db.rawQuery("SELECT COALESCE(SUM(p.correct_count),0) AS correct, COALESCE(SUM(p.correct_count + p.wrong_count),0) AS total FROM learning_progress p JOIN quizzes q ON q.id = p.item_id WHERE p.item_type='quiz' AND q.level = ?", [level])).first;
      levelProgress.add({'level': level, 'words': levelWords, 'lessons': levelLessons, 'quiz_correct': levelQuiz['correct'], 'quiz_total': levelQuiz['total']});
    }
    return {'words_learned': words, 'lessons_touched': lessons, 'quiz_correct': totals['correct'], 'quiz_total': totals['total'], 'active_days': activeDates.length, 'current_streak': streak, 'today_words': todayWords, 'levels': levelProgress};
  }
  Future<void> saveSetting(String key, String value) async { final db = await _source.database; await db.insert('app_settings', {'setting_key': key, 'setting_value': value}, conflictAlgorithm: ConflictAlgorithm.replace); }
  Future<String?> readSetting(String key) async { final db = await _source.database; final rows = await db.query('app_settings', columns: ['setting_value'], where: 'setting_key = ?', whereArgs: [key], limit: 1); return rows.isEmpty ? null : rows.first['setting_value'] as String; }
  Future<void> resetProgress() async { final db = await _source.database; await db.transaction((txn) async { await txn.delete('learning_progress'); await txn.delete('daily_activity'); }); }
}