#!/usr/bin/env python3
"""Generate the offline Dart vocabulary seed from the Excel-compatible CSV master."""
import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "assets" / "data" / "vocabulary_master.csv"
TARGET = ROOT / "lib" / "data" / "spreadsheet_vocabulary.dart"
FIELDS = ["level", "german", "article", "plural", "pronunciation_bn", "meaning_bn", "example_de", "example_bn", "word_type"]

with SOURCE.open(encoding="utf-8-sig", newline="") as stream:
    rows = list(csv.DictReader(stream))

import re

existing_words = set()
seed_file = ROOT / "lib" / "data" / "seed_data.dart"
for match in re.finditer(r"""['"]german['"]\s*:\s*['"]([^'"]+)['"]""", seed_file.read_text(encoding="utf-8")):
    existing_words.add(re.sub(r"^(der|die|das) ", "", match.group(1).strip()).casefold())
extended_file = ROOT / "lib" / "data" / "extended_vocabulary.dart"
for match in re.finditer(r'^\s*"\|([^|]+)\|', extended_file.read_text(encoding="utf-8"), re.MULTILINE):
    if match.group(1) not in {"A1", "A2", "B1", "B2"}:
        existing_words.add(match.group(1).strip().casefold())
additional_file = ROOT / "lib" / "data" / "additional_vocabulary.dart"
for match in re.finditer(r"""['"]german['"]\s*:\s*['"]([^'"]+)['"]""", additional_file.read_text(encoding="utf-8")):
    existing_words.add(match.group(1).strip().casefold())

seen = set()
for line, row in enumerate(rows, start=2):
    missing = [field for field in FIELDS if not (row.get(field) or "").strip()]
    if missing:
        raise SystemExit(f"CSV row {line}: missing {', '.join(missing)}")
    if row["level"] not in {"A1", "A2", "B1", "B2"}:
        raise SystemExit(f"CSV row {line}: invalid CEFR level")
    key = row["german"].strip().casefold()
    if key in seen or key in existing_words:
        raise SystemExit(f"CSV row {line}: duplicate German headword {row['german']}")
    seen.add(key)

def dart(value):
    return "'" + value.replace("\\", "\\\\").replace("'", "\\'").replace("$", "\\$") + "'"

lines = [
    "// GENERATED FILE. Edit assets/data/vocabulary_master.csv and run:",
    "// python3 tool/generate_vocabulary.py",
    "const spreadsheetVocabularySeed = <Map<String, Object?>>[",
]
for row in rows:
    fields = [
        ("level", "level"), ("german", "german"), ("article", "article"),
        ("plural", "plural"), ("pronunciation", "pronunciation_bn"),
        ("meaning_bn", "meaning_bn"), ("example_de", "example_de"),
        ("example_bn", "example_bn"), ("word_type", "word_type"),
    ]
    values = ", ".join(f"'{key}': {dart(row[source].strip())}" for key, source in fields)
    lines.append(f"  {{{values}}},")
lines.append("];")
TARGET.parent.mkdir(parents=True, exist_ok=True)
TARGET.write_text("\n".join(lines) + "\n", encoding="utf-8")
print(f"Generated {len(rows)} vocabulary entries at {TARGET.relative_to(ROOT)}")
