import '../data/app_database.dart';
import '../models/vocabulary_word.dart';
import '../models/lesson.dart';
import '../models/quiz_question.dart';

class LearningRepository {
  LearningRepository(this._source);
  final AppDatabase _source;

  Future<void> initialize() async { await _source.database; }

  Future<List<VocabularyWord>> getWords({String level = 'All', String query = ''}) async {
    final db = await _source.database;
    final where = <String>[];
    final args = <Object?>[];
    if (level != 'All') { where.add('level = ?'); args.add(level); }
    if (query.trim().isNotEmpty) {
      where.add('(german LIKE ? OR meaning_bn LIKE ?)');
      args..add('%${query.trim()}%')..add('%${query.trim()}%');
    }
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
    return rows.map((r) => QuizQuestion(
      level: r['level'] as String,
      question: r['question'] as String,
      options: (r['options'] as String).split('|'),
      answer: r['answer'] as String,
      explanation: r['explanation'] as String,
    )).toList();
  }
}
