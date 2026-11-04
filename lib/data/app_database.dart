import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'seed_data.dart';
import 'extended_vocabulary.dart';

class AppDatabase {
  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    final path = p.join(await getDatabasesPath(), 'deutsch_bangla.db');
    _database = await openDatabase(path, version: 3,
      onCreate: (db, version) async {
        await _createLearningTables(db);
        await _createUserTables(db);
        final batch = db.batch();
        for (final row in vocabularySeed) { batch.insert('vocabulary', row); }
        for (final row in buildExtendedVocabulary()) { batch.insert('vocabulary', row); }
        for (final row in lessonSeed) { batch.insert('lessons', row); }
        for (final row in quizSeed) { batch.insert('quizzes', row); }
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
      });
    return _database!;
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
  Future<void> close() async { await _database?.close(); _database = null; }
}