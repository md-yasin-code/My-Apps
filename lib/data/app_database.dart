import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'seed_data.dart';

class AppDatabase {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final path = p.join(await getDatabasesPath(), 'deutsch_bangla.db');
    _database = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''CREATE TABLE vocabulary (
        id INTEGER PRIMARY KEY AUTOINCREMENT, level TEXT, german TEXT, article TEXT,
        plural TEXT, pronunciation TEXT, meaning_bn TEXT, example_de TEXT, example_bn TEXT)''');
      await db.execute('''CREATE TABLE lessons (
        id INTEGER PRIMARY KEY AUTOINCREMENT, level TEXT, title TEXT, summary TEXT, rule TEXT, example TEXT)''');
      await db.execute('''CREATE TABLE quizzes (
        id INTEGER PRIMARY KEY AUTOINCREMENT, level TEXT, question TEXT, options TEXT, answer TEXT, explanation TEXT)''');
      final batch = db.batch();
      for (final row in vocabularySeed) { batch.insert('vocabulary', row); }
      for (final row in lessonSeed) { batch.insert('lessons', row); }
      for (final row in quizSeed) { batch.insert('quizzes', row); }
      await batch.commit(noResult: true);
    });
    return _database!;
  }
}
