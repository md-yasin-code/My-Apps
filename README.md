# Deutsch Bangla 🇧🇩🇩🇪

An offline-first Flutter learning app for Bengali speakers studying German from CEFR A1 to B2.

## Project status

This repository is being improved incrementally. The current starter includes a Bengali home screen, searchable and level-filtered vocabulary, grammar lesson cards, multiple-choice quizzes, and SQLite-seeded learning content.

Recent foundation work:
- SQLite schema v2 with a safe v1-to-v2 upgrade path.
- Local tables for vocabulary/lesson favorites, learning progress, daily activity, and app settings.
- Repository operations for favorites, progress summaries, settings, and resetting progress.
- A domain-level repository contract separating the learning API from SQLite implementation.

**Not yet complete:** the requested 400–600 reviewed vocabulary entries, 25–35 complete lessons, 80–120 quiz questions, complete progress/streak/daily-goal UI, SRS review interface, onboarding, settings screens, theme switching, audio, release assets and full Android release verification. Do not treat this as a finished or certified A1–B2 course yet.

## Stack
- Flutter / Dart (SDK >=3.3.0 <4.0.0)
- Material 3
- SQLite (sqflite)
- Provider

## Run locally
```bash
flutter pub get
flutter create . --platforms=android # only if Android platform files are absent
flutter run
```

Build a release APK:
```bash
flutter build apk --release
```

Quality checks:
```bash
dart format .
flutter analyze
flutter test
```

## Architecture
```
lib/
  data/           # SQLite database, schema migrations and bundled seed data
  domain/         # Repository contracts and learning rules
  models/         # Typed learning entities
  repositories/   # SQLite-backed repository implementation
  screens/        # Flutter presentation screens
```

## Database
SQLite database version 2 creates content tables (vocabulary, lessons, quizzes), item-level learning progress, daily activity, and local app settings. Existing v1 installs are upgraded by adding favorite columns and creating new user-data tables; existing learning content is retained.

## Adding content
Add reviewed entries to lib/data/seed_data.dart. A seed-file edit alone does not update databases that have already been created. Use a content-version migration or deliberate bundled-content refresh strategy when shipping additional words, lessons, or quizzes. Verify German spelling, noun gender, plural, Bengali meaning and both example translations before merging.

## Educational disclaimer
This is an independent learning aid, not an official Goethe-Institut product or a CEFR certificate. Bengali phonetic spellings are approximate pronunciation hints, not a replacement for listening practice. Have course content reviewed by a qualified German instructor before presenting it as a complete curriculum.

## License
MIT. See LICENSE.