import 'package:flutter/material.dart';

import '../../../core/providers/local_exercise_library_provider.dart';
import '../../../core/theme/judo_design_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/local_exercise_library.dart';

class ExerciseQuickSelectionDialog extends StatefulWidget {
  const ExerciseQuickSelectionDialog({
    super.key,
    required this.provider,
    required this.languageCode,
  });

  final LocalExerciseLibraryProvider provider;
  final String languageCode;

  @override
  State<ExerciseQuickSelectionDialog> createState() =>
      _ExerciseQuickSelectionDialogState();
}

class _ExerciseQuickSelectionDialogState
    extends State<ExerciseQuickSelectionDialog> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final results = widget.provider.query(
      ExerciseLibraryQuery(search: _search.text, includeArchived: false),
      languageCode: widget.languageCode,
    );
    return AlertDialog(
      title: Text(l10n.exerciseLibrarySelectionTitle),
      content: SizedBox(
        width: 520,
        height: 520,
        child: Column(
          children: [
            TextField(
              key: const ValueKey('quick-exercise-search'),
              controller: _search,
              decoration: InputDecoration(
                labelText: l10n.exerciseSearchLabel,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: JudoSpacing.sm),
            Expanded(
              child: ListView(
                children: [
                  if (_search.text.isEmpty) ...[
                    if (widget.provider.favoriteEntries.isNotEmpty) ...[
                      Text(l10n.exerciseFavoritesTitle),
                      ...widget.provider.favoriteEntries.map(_tile),
                    ],
                    if (widget.provider.recentEntries.isNotEmpty) ...[
                      Text(l10n.exerciseRecentTitle),
                      ...widget.provider.recentEntries.map(_tile),
                    ],
                  ],
                  Text(l10n.exerciseResultsTitle),
                  if (results.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(JudoSpacing.md),
                      child: Text(l10n.exerciseLibrarySelectionEmpty),
                    )
                  else
                    ...results.map(_tile),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }

  Widget _tile(ExerciseLibraryEntry entry) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      key: ValueKey('select-library-exercise-${entry.id}'),
      dense: true,
      title: Text(
        entry.resolve(widget.languageCode)?.name ??
            l10n.exerciseTranslationUnavailable,
      ),
      subtitle: Text(
        entry.isApproved
            ? l10n.exerciseApprovedBadge
            : l10n.exerciseCoachAuthoredDisclosure,
      ),
      leading: widget.provider.isFavorite(entry.id)
          ? const Icon(Icons.star)
          : null,
      onTap: () => Navigator.pop(context, entry),
    );
  }
}
