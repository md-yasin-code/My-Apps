# Deutsch Bangla 🇧🇩🇩🇪

Offline-first Flutter app for Bengali speakers learning German (A1–B2).

## Implemented in this starter
- Bengali onboarding and dashboard.
- Offline SQLite vocabulary with level, word-type, search, Bengali meaning, pronunciation, plural and examples.
- A1–B2 grammar library with 34 lessons (8 original + 26 added).
- 108 multiple-choice vocabulary and grammar questions (8 original + 100 generated from the curated word bank).
- Word and lesson favorites.
- Flashcard review with a simple two-day / immediate retry schedule.
- Local quiz answer history, learned-word counts, daily goal setting and active-day streak summary.
- Light, dark and system theme modes.
- Settings, progress dashboard and reset-progress action.
- SQLite schema v4 migrations for existing installations.

## Content size and quality note
The current vocabulary seed contains approximately 126 entries, not the requested 400–600. The lesson and quiz targets are met by count, but the generated vocabulary quiz distractors and all Bengali/German content still need instructor review. This is a learning prototype, not a complete or certified CEFR course.

## Tech stack
- Flutter / Dart (SDK >=3.3.0 <4.0.0)
- Material 3, Provider
- SQLite via sqflite

## Run
```bash
flutter pub get
flutter create . --platforms=android --org com.mohammadyasin # only when Android files are absent
flutter run
```

Build release APK:
```bash
flutter build apk --release
```

Run checks:
```bash
dart format .
flutter analyze
flutter test
```

## Structure
```
lib/
  data/           # SQLite schema, migrations and bundled offline curriculum
  domain/         # repository contracts
  models/         # typed learning models
  presentation/   # app-level state controllers
  repositories/   # SQLite repository implementation
  screens/        # Bengali Flutter screens
test/             # widget tests
```

## Database migration notes
Database v4 adds word type, 100 additional vocabulary entries, 26 lessons and 100 generated practice questions. Existing v1–v3 databases are upgraded by sequential migrations. User progress and favorites are stored locally.

Seed content is not automatically refreshed for future app versions unless a new migration/content version is added. Add reviewed data to the seed files and update `AppDatabase` migrations deliberately.

## Known limitations before store release
- Vocabulary is still below the 400–600 target.
- Pronunciation is Bengali phonetic guidance only; no bundled audio/TTS yet.
- Daily goal currently counts reviewed words; lesson/quiz-only sessions do not complete the word goal.
- The review scheduler is intentionally simple, not a full SM-2 implementation.
- Verify all seed translations and German grammar with an instructor.
- Run `flutter analyze`, `flutter test`, and `flutter build apk --release` on a configured Flutter/Android environment before publishing.
- Android platform wrapper, branded launcher icon and native splash assets may need generation/configuration if absent.

## Educational disclaimer
Independent study aid; not affiliated with Goethe-Institut and does not issue CEFR certificates. Bengali pronunciation spellings are approximations.

## License
MIT — see LICENSE.