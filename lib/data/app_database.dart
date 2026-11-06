import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'seed_data.dart';
import 'extended_vocabulary.dart';
import 'extended_lessons.dart';
import 'vocabulary_quiz_seed.dart';
import 'additional_vocabulary.dart';
import 'spreadsheet_vocabulary.dart';

class AppDatabase {
  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    final path = p.join(await getDatabasesPath(), 'deutsch_bangla.db');
    _database = await openDatabase(path, version: 6,
      onCreate: (db, version) async {
        await _createLearningTables(db);
        await _createUserTables(db);
        final batch = db.batch();
        for (final row in vocabularySeed) { batch.insert('vocabulary', row); }
        for (final row in buildExtendedVocabulary()) { batch.insert('vocabulary', row); }
        for (final row in additionalVocabularySeed) { batch.insert('vocabulary', row); }
        for (final row in spreadsheetVocabularySeed) { batch.insert('vocabulary', row); }
        for (final row in lessonSeed) { batch.insert('lessons', row); }
        for (final row in extendedLessonSeed) { batch.insert('lessons', row); }
        for (final row in quizSeed) { batch.insert('quizzes', row); }
        for (final row in buildVocabularyQuizSeed()) { batch.insert('quizzes', row); }
        for (final row in buildSpreadsheetVocabularyQuizSeed()) { batch.insert('quizzes', row); }
        await batch.commit(noResult: true);
        await db.execute("UPDATE vocabulary SET word_type = CASE WHEN article IN ('verb','adverb','adjective','conjunction') THEN article ELSE COALESCE(word_type, 'noun') END");
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE vocabulary ADD COLUMN is_favorite INTEGER NOT NULL DEFAULT 0');
          await db.execute('ALTER TABLE lessons ADD COLUMN is_favorite INTEGER NOT NULL DEFAULT 0');
          await _createUserTables(db);
        }
        if (oldVersion < 3) {
          await db.execute("ALTER TABLE vocabulary ADD COLUMN word_type TEXT NOT NULL DEFAULT 'noun'");
          await db.execute("UPDATE vocabulary SET word_type = CASE WHEN article IN ('verb','adverb','adjective','conjunction') THEN article ELSE 'noun' END");
          final batch = db.batch();
          for (final row in buildExtendedVocabulary()) { batch.insert('vocabulary', row, conflictAlgorithm: ConflictAlgorithm.ignore); }
          await batch.commit(noResult: true);
        }
        if (oldVersion < 4) {
          final batch = db.batch();
          for (final row in extendedLessonSeed) { batch.insert('lessons', row); }
          for (final row in buildExtendedVocabularyQuizSeed()) { batch.insert('quizzes', row); }
          await batch.commit(noResult: true);
        }
        if (oldVersion < 5) {
          final batch = db.batch();
          for (final row in additionalVocabularySeed) { batch.insert('vocabulary', row, conflictAlgorithm: ConflictAlgorithm.ignore); }
          for (final row in buildAdditionalVocabularyQuizSeed()) { batch.insert('quizzes', row, conflictAlgorithm: ConflictAlgorithm.ignore); }
          await batch.commit(noResult: true);
        }
        if (oldVersion < 6) {
          final batch = db.batch();
          for (final row in spreadsheetVocabularySeed) {
            batch.insert('vocabulary', row, conflictAlgorithm: ConflictAlgorithm.ignore);
          }
          for (final row in buildSpreadsheetVocabularyQuizSeed()) {
            batch.insert('quizzes', row, conflictAlgorithm: ConflictAlgorithm.ignore);
          }
          await batch.commit(noResult: true);
        }
      });
    await _syncSpreadsheetContent(_database!);
    return _database!;
  }

  /// Adds newly bundled spreadsheet words when an updated app is opened.
  /// This keeps content releases independent from schema-version bumps.
  Future<void> _syncSpreadsheetContent(Database db) async {
    await db.transaction((txn) async {
      for (final row in spreadsheetVocabularySeed) {
        final existing = await txn.query(
          'vocabulary',
          columns: ['id'],
          where: 'level = ? AND german = ?',
          whereArgs: [row['level'], row['german']],
          limit: 1,
        );
        if (existing.isEmpty) {
          await txn.insert('vocabulary', row);
        }
      }
      for (final row in buildSpreadsheetVocabularyQuizSeed()) {
        final existing = await txn.query(
          'quizzes',
          columns: ['id'],
          where: 'level = ? AND question = ?',
          whereArgs: [row['level'], row['question']],
          limit: 1,
        );
        if (existing.isEmpty) {
          await txn.insert('quizzes', row);
        }
      }
    });
  }

  Future<void> _createLearningTables(DatabaseExecutor db) async {
    await db.execute('''CREATE TABLE vocabulary (id INTEGER PRIMARY KEY AUTOINCREMENT, level TEXT NOT NULL, german TEXT NOT NULL, article TEXT NOT NULL, plural TEXT NOT NULL, pronunciation TEXT NOT NULL, word_type TEXT NOT NULL DEFAULT 'noun', meaning_bn TEXT NOT NULL, example_de TEXT NOT NULL, example_bn TEXT NOT NULL, is_favorite INTEGER NOT NULL DEFAULT 0)''');
    await db.execute('''CREATE TABLE lessons (id INTEGER PRIMARY KEY AUTOINCREMENT, level TEXT NOT NULL, title TEXT NOT NULL, summary TEXT NOT NULL, rule TEXT NOT NULL, example TEXT NOT NULL, is_favorite INTEGER NOT NULL DEFAULT 0)''');
    await db.execute('''CREATE TABLE quizzes (id INTEGER PRIMARY KEY AUTOINCREMENT, level TEXT NOT NULL, question TEXT NOT NULL, options TEXT NOT NULL, answer TEXT NOT NULL, explanation TEXT NOT NULL)''');
  }
  Future<void> _createUserTables(DatabaseExecutor db) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS learning_progress (id INTEGER PRIMARY KEY AUTOINCREMENT, item_type TEXT NOT NULL, item_id INTEGER NOT NULL, status TEXT NOT NULL DEFAULT 'seen', repetitions INTEGER NOT NULL DEFAULT 0, correct_count INTEGER NOT NULL DEFAULT 0, wrong_count INTEGER NOT NULL DEFAULT 0, due_at TEXT, updated_at TEXT NOT NULL, UNIQUE(item_type, item_id))''');
    await db.execute('''CREATE TABLE IF NOT EXISTS daily_activity (activity_date TEXT PRIMARY KEY, minutes INTEGER NOT NULL DEFAULT 0, words_reviewed INTEGER NOT NULL DEFAULT 0, quiz_correct INTEGER NOT NULL DEFAULT 0, quiz_total INTEGER NOT NULL DEFAULT 0)''');
    await db.execute('''CREATE TABLE IF NOT EXISTS app_settings (setting_key TEXT PRIMARY KEY, setting_value TEXT NOT NULL)''');
  }
  Future<Map<String, Object?>> exportUserData() async {
    final db = await database;
    final progress = await db.query('learning_progress');
    final activity = await db.query('daily_activity');
    final settings = await db.query('app_settings');
    final wordFavorites = await db.query('vocabulary', columns: ['id', 'level', 'german'], where: 'is_favorite = 1');
    final lessonFavorites = await db.query('lessons', columns: ['id', 'level', 'title'], where: 'is_favorite = 1');
    return {
      'progress': progress,
      'dailyActivity': activity,
      'settings': settings,
      'wordFavorites': wordFavorites,
      'lessonFavorites': lessonFavorites,
      'formatVersion': 1,
    };
  }

  Future<void> close() async { await _database?.close(); _database = null; }
}