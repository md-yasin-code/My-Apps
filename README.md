# Deutsch Bangla — Offline German Learning App

An offline-first Flutter starter app for Bengali speakers learning German from CEFR A1 to B2.

## Features
- Bengali-first mobile interface
- A1, A2, B1 and B2 vocabulary with articles, plural forms, Bengali pronunciation, meanings and examples
- Grammar/lesson cards with simple Bengali explanations
- Level-filtered vocabulary and short interactive quizzes
- SQLite local database; starter content is seeded on first launch
- Clean separation between models, data/database, repository and presentation

## Requirements
- Flutter stable (Dart SDK >=3.3)
- Android Studio/Android SDK for Android builds

## Setup
1. Install Flutter and verify with `flutter doctor`.
2. Clone this repository.
3. From the repository root run:
   ```bash
   flutter pub get
   flutter create . --platforms=android
   flutter run
   ```
   The `flutter create` step generates the Android platform wrapper if it is not present in the repository.
4. Build an APK with `flutter build apk --release`.

## Project structure
```
lib/
  main.dart
  app.dart
  data/
    app_database.dart
    seed_data.dart
  models/
    vocabulary_word.dart
    lesson.dart
    quiz_question.dart
  repositories/
    learning_repository.dart
  screens/
    home_screen.dart
    vocabulary_screen.dart
    lessons_screen.dart
    quiz_screen.dart
```

## Offline data
All learning content is stored locally in SQLite. No account or network connection is required. The first run inserts the bundled starter dataset. To expand the curriculum, add reviewed entries to `lib/data/seed_data.dart` and increment the database version/migration when changing the schema.

## Content and learning note
This repository provides a useful starter curriculum, not a complete certified A1–B2 course. The included words and grammar notes should be reviewed by a qualified German instructor before publication as a full course. IPA/pronunciation hints are learner aids, not a substitute for audio and listening practice.

## License
Choose and add a license before distributing the app publicly.
