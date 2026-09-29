import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../search/search_normalization.dart';
import '../../data/repositories/local_exercise_library_repository.dart';
import '../../models/local_exercise_library.dart';
import '../../models/training_activity_contract.dart';
import '../../data/storage/local_exercise_library_storage.dart';

enum LocalExerciseLibraryState { initial, loading, ready, saving, failure }

typedef ExerciseLibraryClock = DateTime Function();
typedef ExerciseLibraryIdFactory = String Function(DateTime now);

class CoachAuthoredExerciseInput {
  const CoachAuthoredExerciseInput({
    required this.authoringLocale,
    this.nameEn,
    this.nameFa,
    this.descriptionEn,
    this.descriptionFa,
    this.instructionsEn,
    this.instructionsFa,
    required this.activityCategory,
    required this.modality,
    this.equipment = const [],
    required this.supportedDosageModes,
    this.commonErrorEn,
    this.commonErrorFa,
    this.safetyEn,
    this.safetyFa,
    this.mediaReference,
    this.sourceReference,
    this.provenanceNotes,
  });

  final ExerciseAuthoringLocale authoringLocale;
  final String? nameEn;
  final String? nameFa;
  final String? descriptionEn;
  final String? descriptionFa;
  final String? instructionsEn;
  final String? instructionsFa;
  final TrainingSessionItemType activityCategory;
  final ExerciseModality modality;
  final List<String> equipment;
  final List<TrainingDosageMode> supportedDosageModes;
  final String? commonErrorEn;
  final String? commonErrorFa;
  final String? safetyEn;
  final String? safetyFa;
  final String? mediaReference;
  final String? sourceReference;
  final String? provenanceNotes;
}

class ExerciseLibraryQuery {
  const ExerciseLibraryQuery({
    this.search = '',
    this.activityCategory,
    this.source,
    this.reviewStatus,
    this.includeArchived = true,
  });

  final String search;
  final TrainingSessionItemType? activityCategory;
  final ExerciseLibrarySource? source;
  final ExerciseReviewStatus? reviewStatus;
  final bool includeArchived;
}

class LocalExerciseLibraryProvider extends ChangeNotifier {
  LocalExerciseLibraryProvider({
    required this.repository,
    this.usageStorage,
    ExerciseLibraryClock? clock,
    ExerciseLibraryIdFactory? idFactory,
  }) : _clock = clock ?? _utcNow,
       _idFactory = idFactory ?? _defaultId;

  final ExerciseLibraryRepository repository;
  final LocalExerciseLibraryUsageStorage? usageStorage;
  final ExerciseLibraryClock _clock;
  final ExerciseLibraryIdFactory _idFactory;

  LocalExerciseLibraryState _state = LocalExerciseLibraryState.initial;
  LocalExerciseLibrarySnapshot _snapshot =
      const LocalExerciseLibrarySnapshot.empty();
  LocalExerciseLibraryFailure? _failure;
  ExerciseLibraryUsageState _usage = const ExerciseLibraryUsageState.empty();
  bool _usageWritable = true;

  LocalExerciseLibraryState get state => _state;
  LocalExerciseLibrarySnapshot get snapshot => _snapshot;
  LocalExerciseLibraryFailure? get failure => _failure;
  ExerciseLibraryUsageState get usage => _usage;
  bool get usageAvailable => _usageWritable;
  bool get isBusy =>
      _state == LocalExerciseLibraryState.loading ||
      _state == LocalExerciseLibraryState.saving;

  Future<bool> initialize() async {
    _state = LocalExerciseLibraryState.loading;
    _failure = null;
    notifyListeners();
    final result = await repository.load();
    if (!result.isSuccess) {
      _state = LocalExerciseLibraryState.failure;
      _failure = result.failure;
      notifyListeners();
      return false;
    }
    _snapshot = result.snapshot!;
    await _loadUsage();
    _state = LocalExerciseLibraryState.ready;
    notifyListeners();
    return true;
  }

  List<ExerciseLibraryEntry> query(
    ExerciseLibraryQuery query, {
    required String languageCode,
  }) {
    if (languageCode != 'en' && languageCode != 'fa') return const [];
    final search = normalizeSearchValue(query.search);
    return _snapshot.entries
        .where((entry) {
          if (!query.includeArchived && entry.archived) return false;
          if (query.activityCategory != null &&
              entry.activityCategory != query.activityCategory) {
            return false;
          }
          if (query.source != null && entry.source != query.source) {
            return false;
          }
          if (query.reviewStatus != null &&
              entry.reviewStatus != query.reviewStatus) {
            return false;
          }
          if (search.isEmpty) return true;
          final content = entry.resolve(languageCode);
          return content != null &&
              <String?>[
                content.name,
                content.description,
                content.instructions,
                ...entry.equipment,
              ].whereType<String>().any(
                (value) => normalizeSearchValue(value).contains(search),
              );
        })
        .toList(growable: false)
      ..sort((a, b) {
        if (a.archived != b.archived) return a.archived ? 1 : -1;
        final aName = a.resolve(languageCode)?.name;
        final bName = b.resolve(languageCode)?.name;
        if (aName == null && bName == null) return a.id.compareTo(b.id);
        if (aName == null) return 1;
        if (bName == null) return -1;
        return aName.compareTo(bName);
      });
  }

  List<ExerciseLibraryEntry> get favoriteEntries =>
      _orderedUsageEntries(_usage.favoriteExerciseIds);

  List<ExerciseLibraryEntry> get recentEntries =>
      _orderedUsageEntries(_usage.recentExerciseIds);

  bool isFavorite(String exerciseId) =>
      _usage.favoriteExerciseIds.contains(exerciseId);

  Future<bool> toggleFavorite(String exerciseId) async {
    if (!_snapshot.entries.any((value) => value.id == exerciseId) ||
        !_usageWritable) {
      return false;
    }
    final favorites = _usage.favoriteExerciseIds.toSet();
    favorites.contains(exerciseId)
        ? favorites.remove(exerciseId)
        : favorites.add(exerciseId);
    return _persistUsage(
      ExerciseLibraryUsageState(
        schemaVersion: ExerciseLibraryUsageState.currentSchemaVersion,
        favoriteExerciseIds: Set.unmodifiable(favorites),
        recentExerciseIds: _usage.recentExerciseIds,
      ),
    );
  }

  Future<bool> recordSelection(String exerciseId) async {
    if (!_snapshot.entries.any((value) => value.id == exerciseId) ||
        !_usageWritable) {
      return false;
    }
    final recent =
        _usage.recentExerciseIds
            .where((value) => value != exerciseId)
            .toList(growable: true)
          ..insert(0, exerciseId);
    if (recent.length > ExerciseLibraryUsageState.maxRecentItems) {
      recent.removeRange(
        ExerciseLibraryUsageState.maxRecentItems,
        recent.length,
      );
    }
    return _persistUsage(
      ExerciseLibraryUsageState(
        schemaVersion: ExerciseLibraryUsageState.currentSchemaVersion,
        favoriteExerciseIds: _usage.favoriteExerciseIds,
        recentExerciseIds: List.unmodifiable(recent),
      ),
    );
  }

  Future<bool> createCoachAuthored(CoachAuthoredExerciseInput input) async {
    if (!_hasAuthoringLocaleName(input)) return false;
    final now = _clock().toUtc();
    final id = _idFactory(now);
    if (_snapshot.entries.any((value) => value.id == id)) return false;
    final entry = _buildEntry(
      id: id,
      revision: 1,
      createdAtUtc: now,
      updatedAtUtc: now,
      archived: false,
      input: input,
    );
    if (!entry.isValid) return false;
    return _persist(
      LocalExerciseLibrarySnapshot(
        schemaVersion: LocalExerciseLibrarySnapshot.currentSchemaVersion,
        entries: List.unmodifiable([..._snapshot.entries, entry]),
      ),
    );
  }

  Future<bool> importCoachAuthoredEntries(
    List<ExerciseLibraryEntry> entries,
  ) async {
    if (entries.isEmpty || isBusy) return false;
    final existingIds = _snapshot.entries.map((value) => value.id).toSet();
    final importIds = <String>{};
    for (final entry in entries) {
      if (!entry.isValid ||
          !entry.isCoachAuthored ||
          entry.reviewStatus !=
              ExerciseReviewStatus.notScientificallyReviewed ||
          !importIds.add(entry.id) ||
          existingIds.contains(entry.id)) {
        return false;
      }
    }
    return _persist(
      LocalExerciseLibrarySnapshot(
        schemaVersion: LocalExerciseLibrarySnapshot.currentSchemaVersion,
        entries: List.unmodifiable([..._snapshot.entries, ...entries]),
      ),
    );
  }

  Future<bool> editCoachAuthored({
    required String exerciseId,
    required CoachAuthoredExerciseInput input,
  }) async {
    if (!_hasAuthoringLocaleName(input)) return false;
    final matches = _snapshot.entries.where((value) => value.id == exerciseId);
    if (matches.length != 1 || !matches.single.isCoachAuthored) return false;
    final current = matches.single;
    final updated = _buildEntry(
      id: current.id,
      revision: current.revision + 1,
      createdAtUtc: current.createdAtUtc,
      updatedAtUtc: _clock().toUtc(),
      archived: current.archived,
      input: input,
    );
    if (!updated.isValid) return false;
    return _replace(updated);
  }

  Future<bool> setArchived({
    required String exerciseId,
    required bool archived,
  }) async {
    final matches = _snapshot.entries.where((value) => value.id == exerciseId);
    if (matches.length != 1 || !matches.single.isCoachAuthored) return false;
    final current = matches.single;
    if (current.archived == archived) return true;
    final updated = ExerciseLibraryEntry(
      id: current.id,
      revision: current.revision + 1,
      source: current.source,
      reviewStatus: current.reviewStatus,
      nameEn: current.nameEn,
      nameFa: current.nameFa,
      descriptionEn: current.descriptionEn,
      descriptionFa: current.descriptionFa,
      instructionsEn: current.instructionsEn,
      instructionsFa: current.instructionsFa,
      activityCategory: current.activityCategory,
      modality: current.modality,
      equipment: current.equipment,
      supportedDosageModes: current.supportedDosageModes,
      commonErrorEn: current.commonErrorEn,
      commonErrorFa: current.commonErrorFa,
      safetyEn: current.safetyEn,
      safetyFa: current.safetyFa,
      mediaReference: current.mediaReference,
      sourceReference: current.sourceReference,
      provenanceNotes: current.provenanceNotes,
      reviewedBy: null,
      reviewedAtUtc: null,
      createdAtUtc: current.createdAtUtc,
      updatedAtUtc: _clock().toUtc(),
      archived: archived,
    );
    return updated.isValid && await _replace(updated);
  }

  ExerciseLibraryEntry _buildEntry({
    required String id,
    required int revision,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    required bool archived,
    required CoachAuthoredExerciseInput input,
  }) => ExerciseLibraryEntry(
    id: id,
    revision: revision,
    source: ExerciseLibrarySource.coachAuthored,
    reviewStatus: ExerciseReviewStatus.notScientificallyReviewed,
    nameEn: _normalize(input.nameEn),
    nameFa: _normalize(input.nameFa),
    descriptionEn: _normalize(input.descriptionEn),
    descriptionFa: _normalize(input.descriptionFa),
    instructionsEn: _normalize(input.instructionsEn),
    instructionsFa: _normalize(input.instructionsFa),
    activityCategory: input.activityCategory,
    modality: input.modality,
    equipment: List.unmodifiable(
      input.equipment
          .map((value) => value.trim())
          .where((value) => value.isNotEmpty)
          .toSet(),
    ),
    supportedDosageModes: List.unmodifiable(input.supportedDosageModes.toSet()),
    commonErrorEn: _normalize(input.commonErrorEn),
    commonErrorFa: _normalize(input.commonErrorFa),
    safetyEn: _normalize(input.safetyEn),
    safetyFa: _normalize(input.safetyFa),
    mediaReference: _normalize(input.mediaReference),
    sourceReference: _normalize(input.sourceReference),
    provenanceNotes: _normalize(input.provenanceNotes),
    reviewedBy: null,
    reviewedAtUtc: null,
    createdAtUtc: createdAtUtc,
    updatedAtUtc: updatedAtUtc,
    archived: archived,
  );

  Future<bool> _replace(ExerciseLibraryEntry updated) => _persist(
    LocalExerciseLibrarySnapshot(
      schemaVersion: _snapshot.schemaVersion,
      entries: List.unmodifiable(
        _snapshot.entries.map(
          (value) => value.id == updated.id ? updated : value,
        ),
      ),
    ),
  );

  Future<bool> _persist(LocalExerciseLibrarySnapshot candidate) async {
    if (isBusy || !candidate.isValid) return false;
    _state = LocalExerciseLibraryState.saving;
    _failure = null;
    notifyListeners();
    final result = await repository.save(candidate);
    if (!result.isSuccess) {
      _state = LocalExerciseLibraryState.failure;
      _failure = result.failure;
      notifyListeners();
      return false;
    }
    _snapshot = result.snapshot!;
    _state = LocalExerciseLibraryState.ready;
    notifyListeners();
    return true;
  }

  Future<void> _loadUsage() async {
    if (usageStorage == null) return;
    try {
      final payload = await usageStorage!.readUsagePayload();
      if (payload == null) return;
      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Usage payload must be an object.');
      }
      _usage = ExerciseLibraryUsageState.fromJson(decoded);
    } catch (_) {
      _usage = const ExerciseLibraryUsageState.empty();
      _usageWritable = false;
    }
  }

  Future<bool> _persistUsage(ExerciseLibraryUsageState candidate) async {
    if (!candidate.isValid || !_usageWritable) return false;
    if (usageStorage != null) {
      try {
        if (!await usageStorage!.writeUsagePayload(
          jsonEncode(candidate.toJson()),
        )) {
          return false;
        }
      } catch (_) {
        return false;
      }
    }
    _usage = candidate;
    notifyListeners();
    return true;
  }

  List<ExerciseLibraryEntry> _orderedUsageEntries(Iterable<String> ids) {
    final byId = {for (final entry in _snapshot.entries) entry.id: entry};
    return List.unmodifiable(
      ids
          .map((id) => byId[id])
          .whereType<ExerciseLibraryEntry>()
          .where((entry) => !entry.archived),
    );
  }
}

DateTime _utcNow() => DateTime.now().toUtc();

int _exerciseSequence = 0;

String _defaultId(DateTime now) =>
    'exercise-${now.microsecondsSinceEpoch}-${_exerciseSequence++}';

String? _normalize(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}

bool _hasAuthoringLocaleName(CoachAuthoredExerciseInput input) =>
    switch (input.authoringLocale) {
      ExerciseAuthoringLocale.en => _normalize(input.nameEn) != null,
      ExerciseAuthoringLocale.fa => _normalize(input.nameFa) != null,
    };
