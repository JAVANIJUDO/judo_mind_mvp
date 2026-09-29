# Exercise Library CSV Import v1

This UTF-8 CSV contract supports bounded, local bulk authoring for the Coach
Exercise Library. The canonical blank template is
`exercise_library_import_v1.csv`. Import is previewed before one atomic local
write; cancelling the picker or preview does not change storage.

## Contract

- `schema_version` must be `1.0.0` on every data row.
- `exercise_id` is a stable, unique identifier matching the library ID rules.
  Duplicates within the file or existing local library are rejected.
- `authoring_locale` is `en` or `fa`. Its matching name (`name_en` or
  `name_fa`) is required. The other language is optional and is never filled
  with a fallback.
- `activity_category`, `modality`, and `supported_dosage_modes` use the exact
  Dart enum names from `training_activity_contract.dart`.
- Multi-value `equipment` and `supported_dosage_modes` fields use `|`.
- CSV quoting follows standard rules: quote fields containing commas, quotes,
  or line breaks and escape an embedded quote as `""`.
- `source_url`, when supplied, must be a direct absolute HTTP(S) page. Search
  result URLs are rejected.
- `media_license_status` is one of `not_provided`, `owned_or_licensed`, or
  `review_required`. A `media_reference` is accepted only with the explicit
  `owned_or_licensed` declaration. This declaration is not scientific review
  or media approval, and the import does not make media playable.

### Exact allowed enum values

`activity_category` accepts exactly these `TrainingSessionItemType` values:

```text
warmUp
ukemi
technicalInstruction
uchikomi
nagekomi
gripFightingKumiKata
tachiWaza
neWaza
randori
tacticalPractice
coolDown
physicalConditioningCustom
customCoachAuthored
```

Each `supported_dosage_modes` item accepts exactly one of these
`TrainingDosageMode` values:

```text
duration
repetitions
setsRepetitions
roundsDuration
distance
descriptiveCustom
```

`modality` accepts exactly these `ExerciseModality` values:

```text
freeWeight
machine
bodyweight
physicalConditioning
resistanceBand
shadowTraining
mobilityRecovery
judoSpecificDrill
other
```

### Documentation-only valid example

The following row illustrates formatting only. It is not seeded into the app
or runtime storage and is not an approved exercise or prescription.

```csv
1.0.0,example-band-warmup-001,en,Example band warm-up,,Documentation-only example.,,warmUp,resistanceBand,band|mat,duration|repetitions,,,,,Coach manual,https://example.org/exercise,,not_provided,Documentation-only example; do not seed.
```

Every imported record is forced to `coachAuthored` and
`notScientificallyReviewed`; reviewer identity and approval timestamps cannot
be imported. No dosage values, prescriptions, athlete roles, or scientific
claims are generated.

## Coach workflow

1. Copy the canonical template and author rows in a UTF-8 capable spreadsheet.
2. Keep the header unchanged and export as CSV UTF-8.
3. In Exercise Library choose **Import CSV** and select one file.
4. Review exact total, valid, invalid, duplicate, and per-row error counts.
5. Confirm to persist all valid preview rows once, or cancel to preserve the
   previous library unchanged.

Invalid rows are skipped from the proposed valid set. If persistence fails,
the repository retains the previous complete snapshot.
