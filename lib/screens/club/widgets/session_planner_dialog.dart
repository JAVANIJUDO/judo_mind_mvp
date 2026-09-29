import 'package:flutter/material.dart';

import '../../../core/providers/local_club_administration_provider.dart';
import '../../../core/providers/local_exercise_library_provider.dart';
import '../../../core/theme/judo_design_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/local_club_administration.dart';
import '../../../models/local_exercise_library.dart';
import '../club_session_localization.dart';
import 'exercise_quick_selection_dialog.dart';

class SessionPlannerDraft {
  const SessionPlannerDraft({
    required this.groupId,
    required this.sessionType,
    required this.title,
    required this.objective,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.items,
  });

  final String groupId;
  final ClubSessionType sessionType;
  final String? title;
  final String? objective;
  final DateTime scheduledAt;
  final int? durationMinutes;
  final List<TrainingSessionItem> items;
}

class SessionPlannerDialog extends StatefulWidget {
  const SessionPlannerDialog({
    super.key,
    required this.provider,
    required this.groups,
    this.exerciseLibraryProvider,
    this.existingSession,
  });

  final LocalClubAdministrationProvider provider;
  final LocalExerciseLibraryProvider? exerciseLibraryProvider;
  final List<TrainingGroup> groups;
  final ClubTrainingSession? existingSession;

  @override
  State<SessionPlannerDialog> createState() => _SessionPlannerDialogState();
}

class _SessionPlannerDialogState extends State<SessionPlannerDialog> {
  final _sessionFormKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _objective;
  late final TextEditingController _duration;
  late String _groupId;
  ClubSessionType? _sessionType;
  late DateTime _scheduledAt;
  late List<_SessionItemDraft> _items;
  bool _dirty = false;
  bool _discardDialogOpen = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingSession;
    _title = TextEditingController(text: existing?.title);
    _objective = TextEditingController(text: existing?.objective);
    _duration = TextEditingController(
      text: existing?.durationMinutes?.toString() ?? '',
    );
    _groupId = existing?.groupId ?? widget.groups.first.id;
    _sessionType = existing?.sessionType == ClubSessionType.unspecifiedLegacy
        ? null
        : existing?.sessionType;
    final now = DateTime.now();
    _scheduledAt =
        existing?.scheduledAtUtc.toLocal() ??
        DateTime(now.year, now.month, now.day, now.hour + 1);
    _items =
        existing?.items
            .map(_SessionItemDraft.fromItem)
            .toList(growable: true) ??
        <_SessionItemDraft>[];
  }

  @override
  void dispose() {
    _title.dispose();
    _objective.dispose();
    _duration.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLegacy =
        widget.existingSession?.sessionType ==
        ClubSessionType.unspecifiedLegacy;
    return PopScope<Object?>(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmDiscard();
      },
      child: AlertDialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: JudoSpacing.md,
          vertical: JudoSpacing.lg,
        ),
        title: Text(
          widget.existingSession == null
              ? l10n.clubSessionCreateAction
              : l10n.clubSessionEditAction,
        ),
        content: SizedBox(
          width: 560,
          child: Form(
            key: _sessionFormKey,
            child: SingleChildScrollView(
              key: const ValueKey('session-planner-scroll-view'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLegacy) ...[
                    Text(
                      l10n.clubLegacySessionTypeNotice,
                      key: const ValueKey('legacy-session-type-notice'),
                      style: const TextStyle(color: JudoColors.warning),
                    ),
                    const SizedBox(height: JudoSpacing.md),
                  ],
                  _buildSessionFields(l10n),
                  const Divider(height: JudoSpacing.xxl),
                  _PlanSummary(
                    itemCount: _items.length,
                    scheduledDurationMinutes: _parseInt(_duration.text),
                    calculableMinutes: _calculableMinutes,
                    hasUnknownTime: _hasUnknownTime,
                  ),
                  const SizedBox(height: JudoSpacing.lg),
                  Text(
                    l10n.clubSessionItemsTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: JudoSpacing.xs),
                  Text(
                    l10n.clubSessionItemsOptional,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: JudoColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: JudoSpacing.md),
                  if (_items.isEmpty)
                    Text(
                      l10n.clubSessionItemsEmpty,
                      key: const ValueKey('session-items-empty'),
                    )
                  else
                    for (var index = 0; index < _items.length; index++)
                      _SessionItemAccordion(
                        draft: _items[index],
                        index: index,
                        onToggle: () => setState(
                          () =>
                              _items[index].expanded = !_items[index].expanded,
                        ),
                        onChanged: _markDirty,
                        onDuplicate: () => _duplicateItem(index),
                        onRemove: () => _removeItem(index),
                        onMoveUp: index == 0
                            ? null
                            : () => _moveItem(index, -1),
                        onMoveDown: index == _items.length - 1
                            ? null
                            : () => _moveItem(index, 1),
                      ),
                  const SizedBox(height: JudoSpacing.md),
                  if (widget.exerciseLibraryProvider != null) ...[
                    Wrap(
                      spacing: JudoSpacing.sm,
                      runSpacing: JudoSpacing.sm,
                      children: [
                        OutlinedButton.icon(
                          key: const ValueKey('choose-library-exercise-action'),
                          onPressed: widget.exerciseLibraryProvider == null
                              ? null
                              : _chooseFromLibrary,
                          icon: const Icon(Icons.fitness_center),
                          label: Text(l10n.exerciseChooseFromLibraryAction),
                        ),
                      ],
                    ),
                    const SizedBox(height: JudoSpacing.sm),
                  ],
                  OutlinedButton.icon(
                    key: const ValueKey('add-session-item-action'),
                    onPressed: _addItem,
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(l10n.exerciseWriteManuallyAction),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            key: const ValueKey('cancel-session-plan-action'),
            onPressed: _requestClose,
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            key: const ValueKey('save-session-action'),
            onPressed: _save,
            child: Text(l10n.clubSessionSavePlanAction),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionFields(AppLocalizations l10n) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      DropdownButtonFormField<String>(
        key: const ValueKey('session-group-field'),
        initialValue: _groupId,
        isExpanded: true,
        decoration: InputDecoration(labelText: l10n.clubSessionGroupLabel),
        items: widget.groups
            .map(
              (group) => DropdownMenuItem(
                value: group.id,
                child: Text(group.name, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(growable: false),
        onChanged: (value) {
          if (value == null) return;
          setState(() => _groupId = value);
          _markDirty();
        },
      ),
      const SizedBox(height: JudoSpacing.md),
      DropdownButtonFormField<ClubSessionType>(
        key: const ValueKey('session-type-field'),
        initialValue: _sessionType,
        isExpanded: true,
        decoration: InputDecoration(labelText: l10n.clubSessionTypeLabel),
        items: ClubSessionType.values
            .where((value) => value != ClubSessionType.unspecifiedLegacy)
            .map(
              (value) => DropdownMenuItem(
                value: value,
                child: Text(
                  clubSessionTypeLabel(l10n, value),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(growable: false),
        validator: (value) =>
            value == null ? l10n.clubSessionTypeRequired : null,
        onChanged: (value) {
          setState(() => _sessionType = value);
          _markDirty();
        },
      ),
      const SizedBox(height: JudoSpacing.md),
      TextFormField(
        key: const ValueKey('session-title-field'),
        controller: _title,
        maxLength: ClubTrainingSession.titleMaxLength,
        decoration: InputDecoration(labelText: l10n.clubSessionTitleLabel),
        onChanged: (_) => _markDirty(),
      ),
      TextFormField(
        key: const ValueKey('session-objective-field'),
        controller: _objective,
        maxLength: ClubTrainingSession.objectiveMaxLength,
        minLines: 2,
        maxLines: 4,
        decoration: InputDecoration(labelText: l10n.clubSessionObjectiveLabel),
        onChanged: (_) => _markDirty(),
      ),
      const SizedBox(height: JudoSpacing.sm),
      Wrap(
        spacing: JudoSpacing.sm,
        runSpacing: JudoSpacing.sm,
        children: [
          OutlinedButton.icon(
            key: const ValueKey('session-date-action'),
            onPressed: _selectDate,
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text(localizedClubCompactDate(context, _scheduledAt)),
          ),
          OutlinedButton.icon(
            key: const ValueKey('session-time-action'),
            onPressed: _selectTime,
            icon: const Icon(Icons.schedule_outlined),
            label: Text(
              MaterialLocalizations.of(
                context,
              ).formatTimeOfDay(TimeOfDay.fromDateTime(_scheduledAt)),
            ),
          ),
        ],
      ),
      const SizedBox(height: JudoSpacing.md),
      TextFormField(
        key: const ValueKey('session-duration-field'),
        controller: _duration,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: l10n.clubSessionDurationLabel),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return null;
          final number = _parseInt(value);
          return number == null || number < 1 || number > 1440
              ? l10n.clubInvalidDuration
              : null;
        },
        onChanged: (_) {
          _markDirty();
          setState(() {});
        },
      ),
    ],
  );

  int? get _calculableMinutes {
    if (_items.isEmpty) return null;
    var total = 0;
    var found = false;
    for (final item in _items) {
      final minutes = item.calculableMinutes;
      if (minutes == null) continue;
      found = true;
      total += minutes;
    }
    return found ? total : null;
  }

  bool get _hasUnknownTime =>
      _items.any((item) => item.calculableMinutes == null);

  void _markDirty() {
    if (mounted) setState(() => _dirty = true);
  }

  void _addItem() {
    setState(() {
      for (final item in _items) {
        item.expanded = false;
      }
      _items.add(
        _SessionItemDraft.empty(widget.provider.createSessionItemDraftId()),
      );
      _dirty = true;
    });
  }

  Future<void> _chooseFromLibrary() async {
    final provider = widget.exerciseLibraryProvider;
    if (provider == null) return;
    final language = Localizations.localeOf(context).languageCode;
    final selected = await showDialog<ExerciseLibraryEntry>(
      context: context,
      builder: (_) => ExerciseQuickSelectionDialog(
        provider: provider,
        languageCode: language,
      ),
    );
    if (selected == null || !mounted) return;
    await provider.recordSelection(selected.id);
    if (!mounted) return;
    setState(() {
      for (final item in _items) {
        item.expanded = false;
      }
      _items.add(
        _SessionItemDraft.fromLibrary(
          widget.provider.createSessionItemDraftId(),
          selected,
          language,
        ),
      );
      _dirty = true;
    });
  }

  void _duplicateItem(int index) {
    setState(() {
      _items.insert(
        index + 1,
        _items[index].duplicate(widget.provider.createSessionItemDraftId()),
      );
      _dirty = true;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index).dispose();
      _dirty = true;
    });
  }

  void _moveItem(int index, int delta) {
    setState(() {
      final item = _items.removeAt(index);
      _items.insert(index + delta, item);
      _dirty = true;
    });
  }

  Future<void> _save() async {
    final sessionValid = _sessionFormKey.currentState?.validate() ?? false;
    final builtItems = <TrainingSessionItem>[];
    var itemsValid = true;
    for (var index = 0; index < _items.length; index++) {
      final item = _items[index].build(widget.provider, index);
      if (item == null) {
        itemsValid = false;
        _items[index]
          ..expanded = true
          ..showErrors = true;
      } else {
        builtItems.add(item);
      }
    }
    if (!sessionValid || !itemsValid || _sessionType == null) {
      setState(() {});
      return;
    }
    _dirty = false;
    if (!mounted) return;
    Navigator.pop(
      context,
      SessionPlannerDraft(
        groupId: _groupId,
        sessionType: _sessionType!,
        title: _nullableText(_title.text),
        objective: _nullableText(_objective.text),
        scheduledAt: _scheduledAt,
        durationMinutes: _duration.text.trim().isEmpty
            ? null
            : _parseInt(_duration.text),
        items: List.unmodifiable(builtItems),
      ),
    );
  }

  void _requestClose() {
    if (_dirty) {
      _confirmDiscard();
      return;
    }
    Navigator.pop(context);
  }

  Future<void> _confirmDiscard() async {
    if (_discardDialogOpen || !mounted) return;
    _discardDialogOpen = true;
    final l10n = AppLocalizations.of(context)!;
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.clubSessionUnsavedChangesTitle),
        content: Text(l10n.clubSessionUnsavedChangesDescription),
        actions: [
          TextButton(
            key: const ValueKey('continue-editing-session-action'),
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.clubSessionContinueEditingAction),
          ),
          TextButton(
            key: const ValueKey('discard-session-changes-action'),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.clubSessionDiscardChangesAction),
          ),
        ],
      ),
    );
    _discardDialogOpen = false;
    if (discard != true || !mounted) return;
    _dirty = false;
    Navigator.pop(context);
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _scheduledAt,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (selected == null || !mounted) return;
    setState(() {
      _scheduledAt = DateTime(
        selected.year,
        selected.month,
        selected.day,
        _scheduledAt.hour,
        _scheduledAt.minute,
      );
      _dirty = true;
    });
  }

  Future<void> _selectTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt),
    );
    if (selected == null || !mounted) return;
    setState(() {
      _scheduledAt = DateTime(
        _scheduledAt.year,
        _scheduledAt.month,
        _scheduledAt.day,
        selected.hour,
        selected.minute,
      );
      _dirty = true;
    });
  }
}

class _PlanSummary extends StatelessWidget {
  const _PlanSummary({
    required this.itemCount,
    required this.scheduledDurationMinutes,
    required this.calculableMinutes,
    required this.hasUnknownTime,
  });

  final int itemCount;
  final int? scheduledDurationMinutes;
  final int? calculableMinutes;
  final bool hasUnknownTime;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheduled =
        scheduledDurationMinutes == null || scheduledDurationMinutes! <= 0
        ? l10n.clubSessionSummaryTimeUnavailable
        : l10n.clubSessionSummaryScheduledDuration(
            localizedClubNumber(context, scheduledDurationMinutes!),
          );
    final calculable = calculableMinutes == null
        ? l10n.clubSessionSummaryCalculableUnavailable
        : hasUnknownTime
        ? l10n.clubSessionSummaryCalculablePartial(
            localizedClubNumber(context, calculableMinutes!),
          )
        : l10n.clubSessionSummaryCalculableTime(
            localizedClubNumber(context, calculableMinutes!),
          );
    return Card(
      key: const ValueKey('session-plan-summary'),
      color: JudoColors.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(JudoSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.clubSessionLiveSummaryTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: JudoSpacing.xs),
            Text(
              l10n.clubSessionSummarySections(
                localizedClubNumber(context, itemCount),
              ),
              key: const ValueKey('session-plan-summary-count'),
            ),
            Text(
              scheduled,
              key: const ValueKey('session-plan-summary-duration'),
            ),
            Text(
              calculable,
              key: const ValueKey('session-plan-summary-calculable'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionItemAccordion extends StatelessWidget {
  const _SessionItemAccordion({
    required this.draft,
    required this.index,
    required this.onToggle,
    required this.onChanged,
    required this.onDuplicate,
    required this.onRemove,
    required this.onMoveUp,
    required this.onMoveDown,
  });

  final _SessionItemDraft draft;
  final int index;
  final VoidCallback onToggle;
  final VoidCallback onChanged;
  final VoidCallback onDuplicate;
  final VoidCallback onRemove;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      key: ValueKey('session-item-panel-${draft.id}'),
      clipBehavior: Clip.antiAlias,
      color: JudoColors.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            key: ValueKey('toggle-session-item-$index'),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                JudoSpacing.sm,
                JudoSpacing.sm,
                JudoSpacing.xs,
                JudoSpacing.xs,
              ),
              child: Row(
                children: [
                  Icon(draft.expanded ? Icons.expand_less : Icons.expand_more),
                  const SizedBox(width: JudoSpacing.xs),
                  Expanded(
                    child: Text(
                      draft.summary(context, l10n),
                      key: ValueKey('session-item-summary-$index'),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: JudoSpacing.sm,
              end: JudoSpacing.xs,
              bottom: JudoSpacing.xs,
            ),
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: JudoSpacing.xs,
              children: [
                _action(
                  key: 'duplicate-session-item-$index',
                  tooltip: l10n.clubSessionDuplicateItemAction,
                  icon: Icons.copy_outlined,
                  onPressed: onDuplicate,
                ),
                _action(
                  key: 'remove-session-item-$index',
                  tooltip: l10n.clubSessionRemoveItemAction,
                  icon: Icons.delete_outline,
                  onPressed: onRemove,
                ),
                _action(
                  key: 'move-session-item-up-$index',
                  tooltip: l10n.clubSessionMoveItemUp,
                  icon: Icons.arrow_upward,
                  onPressed: onMoveUp,
                ),
                _action(
                  key: 'move-session-item-down-$index',
                  tooltip: l10n.clubSessionMoveItemDown,
                  icon: Icons.arrow_downward,
                  onPressed: onMoveDown,
                ),
              ],
            ),
          ),
          if (draft.expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(JudoSpacing.md),
              child: _SessionItemFields(
                draft: draft,
                index: index,
                onChanged: onChanged,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _action({
    required String key,
    required String tooltip,
    required IconData icon,
    required VoidCallback? onPressed,
  }) => IconButton(
    key: ValueKey(key),
    tooltip: tooltip,
    visualDensity: VisualDensity.compact,
    onPressed: onPressed,
    icon: Icon(icon),
  );
}

class _SessionItemFields extends StatefulWidget {
  const _SessionItemFields({
    required this.draft,
    required this.index,
    required this.onChanged,
  });

  final _SessionItemDraft draft;
  final int index;
  final VoidCallback onChanged;

  @override
  State<_SessionItemFields> createState() => _SessionItemFieldsState();
}

class _SessionItemFieldsState extends State<_SessionItemFields> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final draft = widget.draft;
    return Form(
      key: draft.formKey,
      autovalidateMode: draft.showErrors
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (draft.showErrors && !draft.isValid)
            Padding(
              padding: const EdgeInsets.only(bottom: JudoSpacing.sm),
              child: Text(
                l10n.clubSessionPlanItemValidationError,
                key: ValueKey('session-item-validation-error-${widget.index}'),
                style: const TextStyle(color: JudoColors.danger),
              ),
            ),
          DropdownButtonFormField<TrainingSessionItemType>(
            key: ValueKey('session-item-type-field-${widget.index}'),
            initialValue: draft.type,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l10n.clubSessionItemTypeLabel,
            ),
            items: TrainingSessionItemType.values
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: Text(
                      clubSessionItemTypeLabel(l10n, value),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(growable: false),
            onChanged: draft.exerciseSnapshot != null
                ? null
                : (value) {
                    if (value == null) return;
                    setState(() => draft.type = value);
                    widget.onChanged();
                  },
          ),
          const SizedBox(height: JudoSpacing.md),
          TextFormField(
            key: ValueKey('session-item-title-field-${widget.index}'),
            controller: draft.title,
            enabled: draft.exerciseSnapshot == null,
            maxLength: TrainingSessionItem.titleMaxLength,
            decoration: InputDecoration(
              labelText: l10n.clubSessionCustomTitleLabel,
            ),
            validator: (value) =>
                draft.requiresTitle && (value == null || value.trim().isEmpty)
                ? l10n.clubSessionMeaningfulTextError
                : null,
            onChanged: (_) => _changed(),
          ),
          if (draft.requiresTitle) ...[
            Text(
              l10n.clubSessionCoachAuthoredDisclosure,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: JudoColors.textSecondary),
            ),
            const SizedBox(height: JudoSpacing.md),
          ],
          if (draft.exerciseSnapshot != null) ...[
            Text(
              l10n.exerciseLinkedReference(
                localizedClubNumber(context, draft.exerciseSnapshot!.revision),
              ),
              key: ValueKey('linked-exercise-${draft.id}'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              draft.exerciseSnapshot!.source ==
                      ExerciseLibrarySource.approvedRepository
                  ? l10n.exerciseApprovedBadge
                  : l10n.exerciseCoachAuthoredDisclosure,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: JudoSpacing.md),
          ],
          DropdownButtonFormField<TrainingDosageMode>(
            key: ValueKey('session-item-dosage-mode-${widget.index}'),
            initialValue: draft.mode,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l10n.clubSessionDosageModeLabel,
            ),
            items:
                (draft.exerciseSnapshot?.supportedDosageModes ??
                        TrainingDosageMode.values)
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(
                          clubDosageModeLabel(l10n, value),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(growable: false),
            onChanged: (value) {
              if (value == null) return;
              setState(() => draft.mode = value);
              widget.onChanged();
            },
          ),
          const SizedBox(height: JudoSpacing.md),
          ..._dosageFields(l10n),
          const SizedBox(height: JudoSpacing.md),
          TextFormField(
            key: ValueKey('session-item-rest-field-${widget.index}'),
            controller: draft.rest,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.clubSessionRestSecondsField,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return null;
              final number = _parseInt(value);
              return number == null || number < 0
                  ? l10n.clubSessionNonNegativeNumberError
                  : null;
            },
            onChanged: (_) => _changed(),
          ),
          const SizedBox(height: JudoSpacing.md),
          TextFormField(
            key: ValueKey('session-item-notes-field-${widget.index}'),
            controller: draft.notes,
            maxLength: TrainingSessionItem.notesMaxLength,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: l10n.clubSessionCoachNotesField,
            ),
            onChanged: (_) => _changed(),
          ),
        ],
      ),
    );
  }

  List<Widget> _dosageFields(AppLocalizations l10n) =>
      switch (widget.draft.mode) {
        TrainingDosageMode.duration => [
          _positiveIntegerField(
            key: 'session-item-duration-${widget.index}',
            controller: widget.draft.duration,
            label: l10n.clubSessionDurationMinutesField,
            error: l10n.clubSessionPositiveNumberError,
          ),
        ],
        TrainingDosageMode.repetitions => [
          _positiveIntegerField(
            key: 'session-item-repetitions-${widget.index}',
            controller: widget.draft.repetitions,
            label: l10n.clubSessionRepetitionsField,
            error: l10n.clubSessionPositiveNumberError,
          ),
        ],
        TrainingDosageMode.setsRepetitions => [
          _positiveIntegerField(
            key: 'session-item-sets-${widget.index}',
            controller: widget.draft.sets,
            label: l10n.clubSessionSetsField,
            error: l10n.clubSessionPositiveNumberError,
          ),
          const SizedBox(height: JudoSpacing.md),
          _positiveIntegerField(
            key: 'session-item-repetitions-${widget.index}',
            controller: widget.draft.repetitions,
            label: l10n.clubSessionRepetitionsField,
            error: l10n.clubSessionPositiveNumberError,
          ),
        ],
        TrainingDosageMode.roundsDuration => [
          _positiveIntegerField(
            key: 'session-item-rounds-${widget.index}',
            controller: widget.draft.rounds,
            label: l10n.clubSessionRoundsField,
            error: l10n.clubSessionPositiveNumberError,
          ),
          const SizedBox(height: JudoSpacing.md),
          _positiveIntegerField(
            key: 'session-item-round-duration-${widget.index}',
            controller: widget.draft.roundDuration,
            label: l10n.clubSessionRoundDurationField,
            error: l10n.clubSessionPositiveNumberError,
          ),
        ],
        TrainingDosageMode.distance => [
          TextFormField(
            key: ValueKey('session-item-distance-${widget.index}'),
            controller: widget.draft.distance,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.clubSessionDistanceMetersField,
            ),
            validator: (value) {
              final number = value == null ? null : _parseDouble(value);
              return number == null || !number.isFinite || number <= 0
                  ? l10n.clubSessionPositiveNumberError
                  : null;
            },
            onChanged: (_) => _changed(),
          ),
        ],
        TrainingDosageMode.descriptiveCustom => [
          TextFormField(
            key: ValueKey('session-item-description-${widget.index}'),
            controller: widget.draft.description,
            maxLength: TrainingSessionDosage.descriptionMaxLength,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: l10n.clubSessionDosageDescriptionField,
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? l10n.clubSessionMeaningfulTextError
                : null,
            onChanged: (_) => _changed(),
          ),
        ],
      };

  TextFormField _positiveIntegerField({
    required String key,
    required TextEditingController controller,
    required String label,
    required String error,
  }) => TextFormField(
    key: ValueKey(key),
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(labelText: label),
    validator: (value) {
      final number = value == null ? null : _parseInt(value);
      return number == null || number <= 0 ? error : null;
    },
    onChanged: (_) => _changed(),
  );

  void _changed() {
    widget.draft.showErrors = false;
    widget.onChanged();
    setState(() {});
  }
}

class _SessionItemDraft {
  _SessionItemDraft({
    required this.id,
    required this.type,
    required this.mode,
    required this.title,
    required this.duration,
    required this.repetitions,
    required this.sets,
    required this.rounds,
    required this.roundDuration,
    required this.distance,
    required this.description,
    required this.rest,
    required this.notes,
    required this.expanded,
    required this.exerciseSnapshot,
  });

  factory _SessionItemDraft.empty(String id) => _SessionItemDraft(
    id: id,
    type: TrainingSessionItemType.warmUp,
    mode: TrainingDosageMode.duration,
    title: TextEditingController(),
    duration: TextEditingController(),
    repetitions: TextEditingController(),
    sets: TextEditingController(),
    rounds: TextEditingController(),
    roundDuration: TextEditingController(),
    distance: TextEditingController(),
    description: TextEditingController(),
    rest: TextEditingController(),
    notes: TextEditingController(),
    expanded: true,
    exerciseSnapshot: null,
  );

  factory _SessionItemDraft.fromLibrary(
    String id,
    ExerciseLibraryEntry entry,
    String languageCode,
  ) => _SessionItemDraft(
    id: id,
    type: entry.activityCategory,
    mode: entry.supportedDosageModes.first,
    title: TextEditingController(text: entry.resolve(languageCode)?.name),
    duration: TextEditingController(),
    repetitions: TextEditingController(),
    sets: TextEditingController(),
    rounds: TextEditingController(),
    roundDuration: TextEditingController(),
    distance: TextEditingController(),
    description: TextEditingController(),
    rest: TextEditingController(),
    notes: TextEditingController(),
    expanded: true,
    exerciseSnapshot: entry.toSessionSnapshot(),
  );

  factory _SessionItemDraft.fromItem(TrainingSessionItem item) =>
      _SessionItemDraft(
        id: item.id,
        type: item.type,
        mode: item.dosage.mode,
        title: TextEditingController(text: item.customTitle),
        duration: TextEditingController(
          text: item.dosage.durationMinutes?.toString(),
        ),
        repetitions: TextEditingController(
          text: item.dosage.repetitions?.toString(),
        ),
        sets: TextEditingController(text: item.dosage.sets?.toString()),
        rounds: TextEditingController(text: item.dosage.rounds?.toString()),
        roundDuration: TextEditingController(
          text: item.dosage.roundDurationMinutes?.toString(),
        ),
        distance: TextEditingController(
          text: item.dosage.distanceMeters?.toString(),
        ),
        description: TextEditingController(text: item.dosage.description),
        rest: TextEditingController(text: item.restSeconds?.toString()),
        notes: TextEditingController(text: item.coachNotes),
        expanded: false,
        exerciseSnapshot: item.exerciseSnapshot,
      );

  final String id;
  TrainingSessionItemType type;
  TrainingDosageMode mode;
  final TextEditingController title;
  final TextEditingController duration;
  final TextEditingController repetitions;
  final TextEditingController sets;
  final TextEditingController rounds;
  final TextEditingController roundDuration;
  final TextEditingController distance;
  final TextEditingController description;
  final TextEditingController rest;
  final TextEditingController notes;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool expanded;
  final SessionExerciseReferenceSnapshot? exerciseSnapshot;
  bool showErrors = false;

  bool get requiresTitle =>
      type == TrainingSessionItemType.physicalConditioningCustom ||
      type == TrainingSessionItemType.customCoachAuthored;

  bool get isValid {
    final item = TrainingSessionItem(
      id: id,
      type: type,
      customTitle: _nullableText(title.text),
      order: 0,
      dosage: _dosage,
      restSeconds: rest.text.trim().isEmpty ? null : _parseInt(rest.text),
      coachNotes: _nullableText(notes.text),
      exerciseSnapshot: exerciseSnapshot,
    );
    return item.isValid;
  }

  int? get calculableMinutes => switch (mode) {
    TrainingDosageMode.duration => _positiveInt(duration.text),
    TrainingDosageMode.roundsDuration =>
      _positiveInt(rounds.text) == null ||
              _positiveInt(roundDuration.text) == null
          ? null
          : _positiveInt(rounds.text)! * _positiveInt(roundDuration.text)!,
    _ => null,
  };

  _SessionItemDraft duplicate(String newId) => _SessionItemDraft(
    id: newId,
    type: type,
    mode: mode,
    title: TextEditingController(text: title.text),
    duration: TextEditingController(text: duration.text),
    repetitions: TextEditingController(text: repetitions.text),
    sets: TextEditingController(text: sets.text),
    rounds: TextEditingController(text: rounds.text),
    roundDuration: TextEditingController(text: roundDuration.text),
    distance: TextEditingController(text: distance.text),
    description: TextEditingController(text: description.text),
    rest: TextEditingController(text: rest.text),
    notes: TextEditingController(text: notes.text),
    expanded: true,
    exerciseSnapshot: exerciseSnapshot,
  );

  TrainingSessionItem? build(
    LocalClubAdministrationProvider provider,
    int order,
  ) => provider.buildSessionItem(
    id: id,
    type: type,
    customTitle: _nullableText(title.text),
    order: order,
    dosage: _dosage,
    restSeconds: rest.text.trim().isEmpty ? null : _parseInt(rest.text),
    coachNotes: _nullableText(notes.text),
    exerciseSnapshot: exerciseSnapshot,
  );

  TrainingSessionDosage get _dosage => switch (mode) {
    TrainingDosageMode.duration => TrainingSessionDosage(
      mode: mode,
      durationMinutes: _parseInt(duration.text),
      repetitions: null,
      sets: null,
      rounds: null,
      roundDurationMinutes: null,
      distanceMeters: null,
      description: null,
    ),
    TrainingDosageMode.repetitions => TrainingSessionDosage(
      mode: mode,
      durationMinutes: null,
      repetitions: _parseInt(repetitions.text),
      sets: null,
      rounds: null,
      roundDurationMinutes: null,
      distanceMeters: null,
      description: null,
    ),
    TrainingDosageMode.setsRepetitions => TrainingSessionDosage(
      mode: mode,
      durationMinutes: null,
      repetitions: _parseInt(repetitions.text),
      sets: _parseInt(sets.text),
      rounds: null,
      roundDurationMinutes: null,
      distanceMeters: null,
      description: null,
    ),
    TrainingDosageMode.roundsDuration => TrainingSessionDosage(
      mode: mode,
      durationMinutes: null,
      repetitions: null,
      sets: null,
      rounds: _parseInt(rounds.text),
      roundDurationMinutes: _parseInt(roundDuration.text),
      distanceMeters: null,
      description: null,
    ),
    TrainingDosageMode.distance => TrainingSessionDosage(
      mode: mode,
      durationMinutes: null,
      repetitions: null,
      sets: null,
      rounds: null,
      roundDurationMinutes: null,
      distanceMeters: _parseDouble(distance.text),
      description: null,
    ),
    TrainingDosageMode.descriptiveCustom => TrainingSessionDosage(
      mode: mode,
      durationMinutes: null,
      repetitions: null,
      sets: null,
      rounds: null,
      roundDurationMinutes: null,
      distanceMeters: null,
      description: _nullableText(description.text),
    ),
  };

  String summary(BuildContext context, AppLocalizations l10n) {
    final category = clubSessionItemTypeLabel(l10n, type);
    final titleValue =
        exerciseSnapshot?.localizedName(
          Localizations.localeOf(context).languageCode,
        ) ??
        _nullableText(title.text);
    final dosage = _dosage;
    final dosageText = dosage.isValid
        ? clubDosageSummary(context, l10n, dosage)
        : l10n.clubSessionItemIncomplete;
    final restValue = _parseInt(rest.text);
    final restText = restValue == null || restValue < 0
        ? ''
        : ' — ${l10n.clubSessionRestValue(localizedClubNumber(context, restValue))}';
    final resolvedTitle = titleValue == null
        ? category
        : '$category · $titleValue';
    return '$resolvedTitle — $dosageText$restText';
  }

  void dispose() {
    for (final controller in [
      title,
      duration,
      repetitions,
      sets,
      rounds,
      roundDuration,
      distance,
      description,
      rest,
      notes,
    ]) {
      controller.dispose();
    }
  }
}

String? _nullableText(String value) {
  final normalized = value.trim();
  return normalized.isEmpty ? null : normalized;
}

String _normalizeDigits(String value) {
  const source = '۰۱۲۳۴۵۶۷۸۹٠١٢٣٤٥٦٧٨٩';
  const target = '01234567890123456789';
  var normalized = value.trim();
  for (var index = 0; index < source.length; index++) {
    normalized = normalized.replaceAll(source[index], target[index]);
  }
  return normalized;
}

int? _parseInt(String value) => int.tryParse(_normalizeDigits(value));

int? _positiveInt(String value) {
  final parsed = _parseInt(value);
  return parsed != null && parsed > 0 ? parsed : null;
}

double? _parseDouble(String value) =>
    double.tryParse(_normalizeDigits(value).replaceAll('٫', '.'));
