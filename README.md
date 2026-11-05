# Deutsch Bangla 🇧🇩🇩🇪

Offline-first Flutter app for Bengali speakers learning German (A1–B2).

## Implemented in this starter
- Bengali onboarding and dashboard.
- Offline SQLite vocabulary with level, word-type, search, Bengali meaning, pronunciation, plural and examples.
- A1–B2 grammar library with 34 lessons (8 original + 26 added).
- 148 multiple-choice vocabulary and grammar questions (8 original + 140 generated from the expanded word bank).
- Word and lesson favorites.
- Flashcard review with a simple two-day / immediate retry schedule.
- Local quiz answer history, learned-word counts, daily word goal and active-day streak (vocabulary, lessons and quizzes).
- Light, dark and system theme modes.
- Settings, progress dashboard and reset-progress action.
- SQLite schema v6 migrations for existing installations.
- German pronunciation playback via the device's installed German Text-to-Speech voice (offline after voice data is installed).
- Glassmorphism vocabulary cards and dashboard surfaces with staggered, soft entrance animations.
- Excel-compatible vocabulary master sheet with duplicate validation and CSV-to-Dart generation.

## Content size and quality note
The current vocabulary seed contains 209 distinct entries (43 managed through the spreadsheet master), still below the requested 400–600. The lesson and quiz targets are met by count, but the generated vocabulary quiz distractors and all Bengali/German content still need instructor review. This is a learning prototype, not a complete or certified CEFR course.

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
  services/       # German text-to-speech service
  widgets/        # reusable glass UI components
assets/data/      # Excel-compatible CSV vocabulary master
tool/             # CSV-to-Dart vocabulary generator
  domain/         # repository contracts
  models/         # typed learning models
  presentation/   # app-level state controllers
  repositories/   # SQLite repository implementation
  screens/        # Bengali Flutter screens
test/             # widget tests
```

## Database migration notes
Database v3 introduced word type and 100 expanded vocabulary entries; v4 added 26 lessons and 100 generated practice questions; v5 adds 40 vocabulary entries and matching questions; v6 adds 43 spreadsheet-managed vocabulary entries and 43 matching generated questions. Fresh installs receive the complete seed. Existing v1–v5 databases are upgraded by sequential migrations. User progress and favorites are stored locally.

### Add vocabulary with Excel
1. Open `assets/data/vocabulary_master.csv` in Microsoft Excel (choose UTF-8 if prompted).
2. Add one row with these columns, in order: `level`, `german`, `article`, `plural`, `pronunciation_bn`, `meaning_bn`, `example_de`, `example_bn`, `word_type`.
3. Keep German headwords unique (without `der/die/das` prefixes in the `german` column). Use `—` when a plural does not apply.
4. Save as **CSV UTF-8** and commit the updated CSV to GitHub.
5. Run `python3 tool/generate_vocabulary.py` to regenerate `lib/data/spreadsheet_vocabulary.dart`.
6. For an app update, increment the SQLite schema version and add a migration that inserts the new seed rows and generated quiz items. Existing users do not receive new bundled content until that migration is included.

The generator checks required columns, CEFR levels and duplicate German headwords before writing Dart. The CSV is Excel-compatible; the committed Dart file keeps all lessons and words available offline.

## Known limitations before store release
- Vocabulary is still below the 400–600 target.
- TTS uses the phone's installed German voice; voice availability and offline operation depend on Android TTS language data installed on the device.
- Daily goal currently counts reviewed words; lesson/quiz-only sessions do not complete the word goal.
- The review scheduler is intentionally simple, not a full SM-2 implementation.
- Quiz currently uses multiple-choice questions only; fill-in-the-blank and true/false modes remain to be added.
- A branded launcher icon and native splash screen are still pending.
- Verify all seed translations and German grammar with an instructor.
- Run `flutter analyze`, `flutter test`, and `flutter build apk --release` on a configured Flutter/Android environment before publishing.
- Review all newly added spreadsheet entries and generated distractors with a German instructor.
- Android platform wrapper, branded launcher icon and native splash assets may need generation/configuration if absent.

## Educational disclaimer
Independent study aid; not affiliated with Goethe-Institut and does not issue CEFR certificates. Bengali pronunciation spellings are approximations.

## License
MIT — see LICENSE.