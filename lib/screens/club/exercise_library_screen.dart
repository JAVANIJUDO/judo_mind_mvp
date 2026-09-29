import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/local_exercise_library_provider.dart';
import '../../core/theme/judo_design_tokens.dart';
import '../../data/files/exercise_csv_file_selector.dart';
import '../../data/import/exercise_library_csv_importer.dart';
import '../../l10n/app_localizations.dart';
import '../../models/local_exercise_library.dart';
import '../../models/training_activity_contract.dart';
import 'club_session_localization.dart';

enum _ExerciseUsageFilter { all, favorites, recent }

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key, this.csvFileSelector});

  final ExerciseCsvFileSelector? csvFileSelector;

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  final _search = TextEditingController();
  TrainingSessionItemType? _category;
  ExerciseLibrarySource? _source;
  ExerciseReviewStatus? _review;
  _ExerciseUsageFilter _usageFilter = _ExerciseUsageFilter.all;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final language = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.exerciseLibraryTitle)),
      body: Consumer<LocalExerciseLibraryProvider>(
        builder: (context, provider, _) {
          if (provider.state == LocalExerciseLibraryState.initial ||
              provider.state == LocalExerciseLibraryState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.state == LocalExerciseLibraryState.failure) {
            return Center(child: Text(l10n.exerciseLibraryStorageFailure));
          }
          final queriedEntries = provider.query(
            ExerciseLibraryQuery(
              search: _search.text,
              activityCategory: _category,
              source: _source,
              reviewStatus: _review,
            ),
            languageCode: language,
          );
          final queriedById = {
            for (final entry in queriedEntries) entry.id: entry,
          };
          final entries = switch (_usageFilter) {
            _ExerciseUsageFilter.all => queriedEntries,
            _ExerciseUsageFilter.favorites =>
              provider.favoriteEntries
                  .map((entry) => queriedById[entry.id])
                  .whereType<ExerciseLibraryEntry>()
                  .toList(growable: false),
            _ExerciseUsageFilter.recent =>
              provider.recentEntries
                  .map((entry) => queriedById[entry.id])
                  .whereType<ExerciseLibraryEntry>()
                  .toList(growable: false),
          };
          return ListView(
            key: const ValueKey('exercise-library-list'),
            padding: const EdgeInsets.fromLTRB(
              JudoSpacing.md,
              JudoSpacing.md,
              JudoSpacing.md,
              96,
            ),
            children: [
              TextField(
                key: const ValueKey('exercise-search-field'),
                controller: _search,
                decoration: InputDecoration(
                  labelText: l10n.exerciseSearchLabel,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: JudoSpacing.md),
              Wrap(
                spacing: JudoSpacing.sm,
                runSpacing: JudoSpacing.sm,
                children: [
                  FilledButton.icon(
                    key: const ValueKey('import-exercise-csv-action'),
                    onPressed: provider.isBusy
                        ? null
                        : () => _importCsv(context, provider),
                    icon: const Icon(Icons.upload_file_outlined),
                    label: Text(l10n.exerciseImportCsvAction),
                  ),
                  OutlinedButton.icon(
                    key: const ValueKey('create-coach-exercise-action'),
                    onPressed: provider.isBusy
                        ? null
                        : () => _editEntry(context),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.exerciseCreateAction),
                  ),
                ],
              ),
              const SizedBox(height: JudoSpacing.md),
              DropdownButtonFormField<TrainingSessionItemType?>(
                key: const ValueKey('exercise-category-filter'),
                initialValue: _category,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: l10n.exerciseCategoryFilterLabel,
                ),
                items: [
                  DropdownMenuItem(value: null, child: Text(l10n.filterAll)),
                  ...TrainingSessionItemType.values.map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(clubSessionItemTypeLabel(l10n, value)),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _category = value),
              ),
              const SizedBox(height: JudoSpacing.sm),
              Wrap(
                key: const ValueKey('exercise-usage-filters'),
                spacing: JudoSpacing.sm,
                runSpacing: JudoSpacing.xs,
                children: [
                  FilterChip(
                    key: const ValueKey('exercise-filter-all'),
                    label: Text(l10n.filterAll),
                    selected: _usageFilter == _ExerciseUsageFilter.all,
                    onSelected: (_) =>
                        setState(() => _usageFilter = _ExerciseUsageFilter.all),
                  ),
                  FilterChip(
                    key: const ValueKey('exercise-filter-favorites'),
                    label: Text(
                      l10n.exerciseFavoritesFilter(
                        provider.favoriteEntries.length.toString(),
                      ),
                    ),
                    selected: _usageFilter == _ExerciseUsageFilter.favorites,
                    onSelected: (_) => setState(
                      () => _usageFilter = _ExerciseUsageFilter.favorites,
                    ),
                  ),
                  FilterChip(
                    key: const ValueKey('exercise-filter-recent'),
                    label: Text(
                      l10n.exerciseRecentFilter(
                        provider.recentEntries.length.toString(),
                      ),
                    ),
                    selected: _usageFilter == _ExerciseUsageFilter.recent,
                    onSelected: (_) => setState(
                      () => _usageFilter = _ExerciseUsageFilter.recent,
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                key: const ValueKey('exercise-more-filters'),
                tilePadding: EdgeInsets.zero,
                title: Text(l10n.exerciseMoreFilters),
                children: [
                  DropdownButtonFormField<ExerciseLibrarySource?>(
                    key: const ValueKey('exercise-source-filter'),
                    initialValue: _source,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.exerciseSourceFilterLabel,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(l10n.filterAll),
                      ),
                      DropdownMenuItem(
                        value: ExerciseLibrarySource.approvedRepository,
                        child: Text(l10n.exerciseApprovedBadge),
                      ),
                      DropdownMenuItem(
                        value: ExerciseLibrarySource.coachAuthored,
                        child: Text(l10n.exerciseCoachAuthoredBadge),
                      ),
                    ],
                    onChanged: (value) => setState(() => _source = value),
                  ),
                  const SizedBox(height: JudoSpacing.sm),
                  DropdownButtonFormField<ExerciseReviewStatus?>(
                    key: const ValueKey('exercise-review-filter'),
                    initialValue: _review,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.exerciseReviewFilterLabel,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(l10n.filterAll),
                      ),
                      ...ExerciseReviewStatus.values.map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(_reviewLabel(l10n, value)),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => _review = value),
                  ),
                ],
              ),
              const SizedBox(height: JudoSpacing.lg),
              Text(
                l10n.exerciseResultsTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: JudoSpacing.sm),
              if (entries.isEmpty)
                if (_usageFilter == _ExerciseUsageFilter.favorites)
                  _UsageEmptyState(
                    key: const ValueKey('exercise-favorites-empty'),
                    icon: Icons.star_border,
                    message: l10n.exerciseFavoritesEmpty,
                  )
                else if (_usageFilter == _ExerciseUsageFilter.recent)
                  _UsageEmptyState(
                    key: const ValueKey('exercise-recent-empty'),
                    icon: Icons.history,
                    message: l10n.exerciseRecentEmpty,
                  )
                else
                  _EmptyLibrary(
                    approvedCount: provider.snapshot.approvedCount,
                    filtered:
                        _search.text.isNotEmpty ||
                        _category != null ||
                        _source != null ||
                        _review != null,
                  )
              else
                for (final entry in entries)
                  _ExerciseCard(
                    entry: entry,
                    languageCode: language,
                    favorite: provider.isFavorite(entry.id),
                    onFavorite: () => _toggleFavorite(provider, entry.id),
                    onEdit: entry.isCoachAuthored
                        ? () => _editEntry(context, existing: entry)
                        : null,
                    onArchive: entry.isCoachAuthored
                        ? () => _archive(context, entry)
                        : null,
                  ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _toggleFavorite(
    LocalExerciseLibraryProvider provider,
    String exerciseId,
  ) async {
    final changed = await provider.toggleFavorite(exerciseId);
    if (!changed || !mounted) return;
    if (_usageFilter == _ExerciseUsageFilter.favorites &&
        provider.favoriteEntries.isEmpty) {
      setState(() => _usageFilter = _ExerciseUsageFilter.all);
    }
  }

  Future<void> _editEntry(
    BuildContext context, {
    ExerciseLibraryEntry? existing,
  }) async {
    final input = await showDialog<CoachAuthoredExerciseInput>(
      context: context,
      builder: (_) => _ExerciseEditorDialog(existing: existing),
    );
    if (input == null || !context.mounted) return;
    final provider = context.read<LocalExerciseLibraryProvider>();
    final saved = existing == null
        ? await provider.createCoachAuthored(input)
        : await provider.editCoachAuthored(
            exerciseId: existing.id,
            input: input,
          );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved
              ? AppLocalizations.of(context)!.exerciseSavedFeedback
              : AppLocalizations.of(context)!.clubOperationFailed,
        ),
      ),
    );
  }

  Future<void> _importCsv(
    BuildContext context,
    LocalExerciseLibraryProvider provider,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final selector =
        widget.csvFileSelector ?? const FilePickerExerciseCsvFileSelector();
    final selection = await selector.selectCsv();
    if (selection == null || !context.mounted) return;
    final preview = ExerciseLibraryCsvImporter().parseBytes(
      selection.bytes,
      existingExerciseIds: provider.snapshot.entries
          .map((entry) => entry.id)
          .toSet(),
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.exerciseImportPreviewTitle),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(selection.name),
                Text(l10n.exerciseImportTotal(preview.totalRows.toString())),
                Text(l10n.exerciseImportValid(preview.validRows.toString())),
                Text(
                  l10n.exerciseImportInvalid(preview.invalidRows.toString()),
                ),
                Text(
                  l10n.exerciseImportDuplicates(
                    preview.duplicateRows.toString(),
                  ),
                ),
                for (final issue in preview.fileIssues)
                  Text(
                    l10n.exerciseImportFileError(_issueLabel(l10n, issue.code)),
                  ),
                for (final row in preview.rows.where((row) => !row.isValid))
                  Text(
                    l10n.exerciseImportRowError(
                      row.rowNumber.toString(),
                      row.issues
                          .map((issue) => _issueLabel(l10n, issue.code))
                          .join(' · '),
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            key: const ValueKey('confirm-exercise-csv-import'),
            onPressed: preview.canImport
                ? () => Navigator.pop(dialogContext, true)
                : null,
            child: Text(l10n.exerciseImportConfirmAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final saved = await provider.importCoachAuthoredEntries(
      preview.validEntries,
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved
              ? l10n.exerciseImportSaved(preview.validRows.toString())
              : l10n.clubOperationFailed,
        ),
      ),
    );
  }

  Future<void> _archive(
    BuildContext context,
    ExerciseLibraryEntry entry,
  ) async {
    await context.read<LocalExerciseLibraryProvider>().setArchived(
      exerciseId: entry.id,
      archived: !entry.archived,
    );
  }
}

class _UsageEmptyState extends StatelessWidget {
  const _UsageEmptyState({
    super.key,
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(JudoSpacing.lg),
      child: Column(
        children: [
          Icon(icon, size: 36),
          const SizedBox(height: JudoSpacing.sm),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary({required this.approvedCount, required this.filtered});

  final int approvedCount;
  final bool filtered;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      key: const ValueKey('exercise-library-empty-state'),
      child: Padding(
        padding: const EdgeInsets.all(JudoSpacing.lg),
        child: Column(
          children: [
            const Icon(Icons.fitness_center, size: 40),
            const SizedBox(height: JudoSpacing.md),
            Text(
              filtered
                  ? l10n.exerciseFilteredEmpty
                  : l10n.exerciseLibraryEmptyTitle,
              textAlign: TextAlign.center,
            ),
            if (!filtered && approvedCount == 0) ...[
              const SizedBox(height: JudoSpacing.sm),
              Text(
                l10n.exerciseApprovedLibraryEmptyDisclosure,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.entry,
    required this.languageCode,
    required this.favorite,
    required this.onFavorite,
    required this.onEdit,
    required this.onArchive,
  });

  final ExerciseLibraryEntry entry;
  final String languageCode;
  final bool favorite;
  final VoidCallback onFavorite;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = entry.resolve(languageCode);
    return Card(
      key: ValueKey('exercise-entry-${entry.id}'),
      child: Padding(
        padding: const EdgeInsets.all(JudoSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    content?.name ?? l10n.exerciseTranslationUnavailable,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  key: ValueKey('exercise-favorite-${entry.id}'),
                  tooltip: favorite
                      ? l10n.exerciseRemoveFavorite
                      : l10n.exerciseAddFavorite,
                  onPressed: onFavorite,
                  icon: Icon(favorite ? Icons.star : Icons.star_border),
                ),
              ],
            ),
            const SizedBox(height: JudoSpacing.xs),
            Wrap(
              spacing: JudoSpacing.xs,
              runSpacing: JudoSpacing.xs,
              children: [
                Chip(
                  label: Text(
                    entry.isApproved
                        ? l10n.exerciseApprovedBadge
                        : l10n.exerciseCoachAuthoredBadge,
                  ),
                ),
                if (entry.archived) Chip(label: Text(l10n.exerciseArchived)),
              ],
            ),
            if (entry.isCoachAuthored)
              Text(
                l10n.exerciseCoachAuthoredDisclosure,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            Text(clubSessionItemTypeLabel(l10n, entry.activityCategory)),
            if (entry.equipment.isNotEmpty) Text(entry.equipment.join(' · ')),
            if (onEdit != null || onArchive != null)
              Wrap(
                alignment: WrapAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(l10n.exerciseEditAction),
                  ),
                  TextButton.icon(
                    onPressed: onArchive,
                    icon: Icon(
                      entry.archived ? Icons.unarchive : Icons.archive_outlined,
                    ),
                    label: Text(
                      entry.archived
                          ? l10n.exerciseUnarchiveAction
                          : l10n.exerciseArchiveAction,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseEditorDialog extends StatefulWidget {
  const _ExerciseEditorDialog({this.existing});

  final ExerciseLibraryEntry? existing;

  @override
  State<_ExerciseEditorDialog> createState() => _ExerciseEditorDialogState();
}

class _ExerciseEditorDialogState extends State<_ExerciseEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEn;
  late final TextEditingController _nameFa;
  late final TextEditingController _descriptionEn;
  late final TextEditingController _descriptionFa;
  late TrainingSessionItemType _category;
  late ExerciseModality _modality;
  late Set<TrainingDosageMode> _dosageModes;
  late ExerciseAuthoringLocale _authoringLocale;

  @override
  void initState() {
    super.initState();
    final value = widget.existing;
    _nameEn = TextEditingController(text: value?.nameEn);
    _nameFa = TextEditingController(text: value?.nameFa);
    _descriptionEn = TextEditingController(text: value?.descriptionEn);
    _descriptionFa = TextEditingController(text: value?.descriptionFa);
    _category =
        value?.activityCategory ??
        TrainingSessionItemType.physicalConditioningCustom;
    _modality = value?.modality ?? ExerciseModality.physicalConditioning;
    _dosageModes =
        value?.supportedDosageModes.toSet() ??
        {TrainingDosageMode.setsRepetitions};
    _authoringLocale = value?.nameFa != null && value?.nameEn == null
        ? ExerciseAuthoringLocale.fa
        : ExerciseAuthoringLocale.en;
  }

  @override
  void dispose() {
    _nameEn.dispose();
    _nameFa.dispose();
    _descriptionEn.dispose();
    _descriptionFa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    _authoringLocale = Localizations.localeOf(context).languageCode == 'fa'
        ? ExerciseAuthoringLocale.fa
        : ExerciseAuthoringLocale.en;
    return AlertDialog(
      title: Text(
        widget.existing == null
            ? l10n.exerciseCreateAction
            : l10n.exerciseEditAction,
      ),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.exerciseCoachAuthoredDisclosure),
                TextFormField(
                  key: const ValueKey('exercise-name-en'),
                  controller: _nameEn,
                  maxLength: ExerciseLibraryEntry.nameMaxLength,
                  decoration: InputDecoration(labelText: l10n.exerciseNameEn),
                  validator: _authoringLocale == ExerciseAuthoringLocale.en
                      ? _required
                      : null,
                ),
                TextFormField(
                  key: const ValueKey('exercise-name-fa'),
                  controller: _nameFa,
                  maxLength: ExerciseLibraryEntry.nameMaxLength,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(labelText: l10n.exerciseNameFa),
                  validator: _authoringLocale == ExerciseAuthoringLocale.fa
                      ? _required
                      : null,
                ),
                TextFormField(
                  controller: _descriptionEn,
                  maxLength: ExerciseLibraryEntry.longTextMaxLength,
                  decoration: InputDecoration(
                    labelText: l10n.exerciseDescriptionEn,
                  ),
                ),
                TextFormField(
                  controller: _descriptionFa,
                  maxLength: ExerciseLibraryEntry.longTextMaxLength,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    labelText: l10n.exerciseDescriptionFa,
                  ),
                ),
                DropdownButtonFormField<TrainingSessionItemType>(
                  initialValue: _category,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l10n.exerciseCategoryFilterLabel,
                  ),
                  items: TrainingSessionItemType.values
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(clubSessionItemTypeLabel(l10n, value)),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) => setState(() => _category = value!),
                ),
                const SizedBox(height: JudoSpacing.md),
                DropdownButtonFormField<ExerciseModality>(
                  initialValue: _modality,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l10n.exerciseModalityLabel,
                  ),
                  items: ExerciseModality.values
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(_modalityLabel(l10n, value)),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) => setState(() => _modality = value!),
                ),
                const SizedBox(height: JudoSpacing.md),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(l10n.exerciseSupportedDosageModes),
                ),
                for (final mode in TrainingDosageMode.values)
                  CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    value: _dosageModes.contains(mode),
                    title: Text(clubDosageModeLabel(l10n, mode)),
                    onChanged: (selected) => setState(() {
                      if (selected ?? false) {
                        _dosageModes.add(mode);
                      } else if (_dosageModes.length > 1) {
                        _dosageModes.remove(mode);
                      }
                    }),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          key: const ValueKey('save-coach-exercise-action'),
          onPressed: _save,
          child: Text(l10n.exerciseSaveAction),
        ),
      ],
    );
  }

  String? _required(String? value) => value == null || value.trim().isEmpty
      ? AppLocalizations.of(context)!.clubSessionMeaningfulTextError
      : null;

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final old = widget.existing;
    Navigator.pop(
      context,
      CoachAuthoredExerciseInput(
        authoringLocale: _authoringLocale,
        nameEn: _nameEn.text,
        nameFa: _nameFa.text,
        descriptionEn: _descriptionEn.text,
        descriptionFa: _descriptionFa.text,
        instructionsEn: old?.instructionsEn,
        instructionsFa: old?.instructionsFa,
        activityCategory: _category,
        modality: _modality,
        equipment: old?.equipment ?? const [],
        supportedDosageModes: _dosageModes.toList(growable: false),
        commonErrorEn: old?.commonErrorEn,
        commonErrorFa: old?.commonErrorFa,
        safetyEn: old?.safetyEn,
        safetyFa: old?.safetyFa,
        mediaReference: old?.mediaReference,
        sourceReference: old?.sourceReference,
        provenanceNotes: old?.provenanceNotes,
      ),
    );
  }
}

String _reviewLabel(AppLocalizations l10n, ExerciseReviewStatus value) =>
    switch (value) {
      ExerciseReviewStatus.approved => l10n.exerciseReviewApproved,
      ExerciseReviewStatus.reviewRequired => l10n.exerciseReviewRequired,
      ExerciseReviewStatus.notScientificallyReviewed =>
        l10n.exerciseReviewNotScientific,
    };

String _modalityLabel(AppLocalizations l10n, ExerciseModality value) =>
    switch (value) {
      ExerciseModality.freeWeight => l10n.exerciseModalityFreeWeight,
      ExerciseModality.machine => l10n.exerciseModalityMachine,
      ExerciseModality.bodyweight => l10n.exerciseModalityBodyweight,
      ExerciseModality.physicalConditioning =>
        l10n.exerciseModalityConditioning,
      ExerciseModality.resistanceBand => l10n.exerciseModalityBand,
      ExerciseModality.shadowTraining => l10n.exerciseModalityShadow,
      ExerciseModality.mobilityRecovery => l10n.exerciseModalityMobility,
      ExerciseModality.judoSpecificDrill => l10n.exerciseModalityJudoDrill,
      ExerciseModality.other => l10n.exerciseModalityOther,
    };

String _issueLabel(
  AppLocalizations l10n,
  ExerciseCsvIssueCode code,
) => switch (code) {
  ExerciseCsvIssueCode.emptyFile => l10n.exerciseImportIssueEmptyFile,
  ExerciseCsvIssueCode.invalidUtf8 => l10n.exerciseImportIssueInvalidUtf8,
  ExerciseCsvIssueCode.malformedCsv => l10n.exerciseImportIssueMalformedCsv,
  ExerciseCsvIssueCode.malformedHeader => l10n.exerciseImportIssueHeader,
  ExerciseCsvIssueCode.unsupportedSchema => l10n.exerciseImportIssueSchema,
  ExerciseCsvIssueCode.missingId => l10n.exerciseImportIssueMissingId,
  ExerciseCsvIssueCode.duplicateInFile => l10n.exerciseImportIssueDuplicateFile,
  ExerciseCsvIssueCode.duplicateStored =>
    l10n.exerciseImportIssueDuplicateStored,
  ExerciseCsvIssueCode.invalidAuthoringLocale => l10n.exerciseImportIssueLocale,
  ExerciseCsvIssueCode.missingRequiredName => l10n.exerciseImportIssueName,
  ExerciseCsvIssueCode.invalidActivityCategory =>
    l10n.exerciseImportIssueCategory,
  ExerciseCsvIssueCode.invalidModality => l10n.exerciseImportIssueModality,
  ExerciseCsvIssueCode.invalidDosageMode => l10n.exerciseImportIssueDosage,
  ExerciseCsvIssueCode.invalidSourceUrl => l10n.exerciseImportIssueUrl,
  ExerciseCsvIssueCode.invalidMediaLicense =>
    l10n.exerciseImportIssueMediaLicense,
  ExerciseCsvIssueCode.mediaLicenseRequired =>
    l10n.exerciseImportIssueMediaDeclaration,
  ExerciseCsvIssueCode.invalidRecord => l10n.exerciseImportIssueRecord,
};
