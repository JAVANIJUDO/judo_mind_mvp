import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/design_system/icons/judo_icons.dart';
import '../../core/providers/local_athlete_profile_provider.dart';
import '../../core/providers/local_club_administration_provider.dart';
import '../../core/providers/local_exercise_library_provider.dart';
import '../../core/theme/judo_design_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../models/local_club_administration.dart';
import 'club_session_localization.dart';
import 'exercise_library_screen.dart';
import 'widgets/session_planner_dialog.dart';

class ClubAdministrationScreen extends StatelessWidget {
  const ClubAdministrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.clubAdministrationTitle)),
      body:
          Consumer2<
            LocalClubAdministrationProvider,
            LocalAthleteProfileProvider
          >(
            builder: (context, clubProvider, profileProvider, _) {
              if (clubProvider.state == LocalClubAdministrationState.initial ||
                  clubProvider.state == LocalClubAdministrationState.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                key: const ValueKey('club-administration-workspace'),
                padding: const EdgeInsets.fromLTRB(
                  JudoSpacing.lg,
                  JudoSpacing.lg,
                  JudoSpacing.lg,
                  JudoSpacing.xxxl,
                ),
                children: [
                  _Notice(text: l10n.clubLocalFoundationNotice),
                  const SizedBox(height: JudoSpacing.lg),
                  const _ExerciseLibraryDestination(),
                  const SizedBox(height: JudoSpacing.lg),
                  if (clubProvider.state ==
                      LocalClubAdministrationState.failure)
                    _StorageFailure(provider: clubProvider)
                  else if (clubProvider.snapshot.club == null)
                    _EmptyClub(provider: clubProvider)
                  else ...[
                    _Dashboard(snapshot: clubProvider.snapshot),
                    const SizedBox(height: JudoSpacing.lg),
                    _ClubDetails(provider: clubProvider),
                    const SizedBox(height: JudoSpacing.lg),
                    _Roster(
                      provider: clubProvider,
                      profileProvider: profileProvider,
                    ),
                    const SizedBox(height: JudoSpacing.lg),
                    _Groups(provider: clubProvider),
                    const SizedBox(height: JudoSpacing.lg),
                    _Sessions(provider: clubProvider),
                  ],
                ],
              );
            },
          ),
    );
  }
}

class _ExerciseLibraryDestination extends StatelessWidget {
  const _ExerciseLibraryDestination();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final libraryProvider = context.read<LocalExerciseLibraryProvider?>();
    return _Panel(
      key: const ValueKey('exercise-library-destination'),
      title: l10n.exerciseLibraryTitle,
      icon: Icons.fitness_center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.exerciseLibraryDescription),
          const SizedBox(height: JudoSpacing.md),
          ElevatedButton.icon(
            key: const ValueKey('open-exercise-library-action'),
            onPressed: libraryProvider == null
                ? null
                : () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: libraryProvider,
                        child: const ExerciseLibraryScreen(),
                      ),
                    ),
                  ),
            icon: const Icon(Icons.arrow_forward),
            label: Text(l10n.exerciseLibraryOpenAction),
          ),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
    label: text,
    child: Container(
      padding: const EdgeInsets.all(JudoSpacing.lg),
      decoration: BoxDecoration(
        color: JudoColors.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(JudoRadius.md),
        border: Border.all(color: JudoColors.secondary.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.phone_android_outlined, color: JudoColors.secondary),
          const SizedBox(width: JudoSpacing.md),
          Expanded(child: Text(text)),
        ],
      ),
    ),
  );
}

class _StorageFailure extends StatelessWidget {
  const _StorageFailure({required this.provider});

  final LocalClubAdministrationProvider provider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _Panel(
      key: const ValueKey('club-storage-failure'),
      title: l10n.clubStorageInvalidTitle,
      icon: Icons.error_outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.clubStorageInvalidDescription),
          const SizedBox(height: JudoSpacing.md),
          OutlinedButton(
            onPressed: provider.isBusy ? null : provider.initialize,
            child: Text(l10n.retryLabel),
          ),
        ],
      ),
    );
  }
}

class _EmptyClub extends StatelessWidget {
  const _EmptyClub({required this.provider});

  final LocalClubAdministrationProvider provider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _Panel(
      key: const ValueKey('club-empty-state'),
      title: l10n.clubEmptyTitle,
      icon: JudoIcons.club,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.clubEmptyDescription),
          const SizedBox(height: JudoSpacing.lg),
          ElevatedButton.icon(
            key: const ValueKey('create-club-action'),
            onPressed: provider.isBusy
                ? null
                : () => _editClub(context, provider),
            icon: const Icon(Icons.add),
            label: Text(l10n.clubCreateAction),
          ),
        ],
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({required this.snapshot});

  final LocalClubAdministrationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _Panel(
      key: const ValueKey('club-dashboard'),
      title: l10n.clubDashboardTitle,
      icon: JudoIcons.overview,
      child: Wrap(
        spacing: JudoSpacing.sm,
        runSpacing: JudoSpacing.sm,
        children: [
          _CountChip(
            label: l10n.clubMembersCount(
              localizedClubNumber(context, snapshot.rosterCount),
            ),
          ),
          _CountChip(
            label: l10n.clubGroupsCount(
              localizedClubNumber(context, snapshot.groupCount),
            ),
          ),
          _CountChip(
            label: l10n.clubSessionsCount(
              localizedClubNumber(context, snapshot.sessionCount),
            ),
          ),
          _CountChip(
            label: l10n.clubAttendanceCount(
              localizedClubNumber(context, snapshot.recordedAttendanceCount),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubDetails extends StatelessWidget {
  const _ClubDetails({required this.provider});

  final LocalClubAdministrationProvider provider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final club = provider.snapshot.club!;
    return _Panel(
      key: const ValueKey('club-details'),
      title: club.name,
      icon: JudoIcons.club,
      trailing: IconButton(
        key: const ValueKey('edit-club-action'),
        tooltip: l10n.clubEditAction,
        onPressed: provider.isBusy ? null : () => _editClub(context, provider),
        icon: const Icon(Icons.edit_outlined),
      ),
      child: Text(club.description ?? l10n.notAvailableLabel),
    );
  }
}

class _Roster extends StatelessWidget {
  const _Roster({required this.provider, required this.profileProvider});

  final LocalClubAdministrationProvider provider;
  final LocalAthleteProfileProvider profileProvider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final memberships = provider.snapshot.memberships;
    final displayName =
        profileProvider.profile.displayName ?? l10n.clubCurrentAthleteFallback;
    return _Panel(
      key: const ValueKey('club-roster'),
      title: l10n.clubRosterTitle,
      icon: JudoIcons.athlete,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (memberships.isEmpty) ...[
            Text(l10n.clubRosterEmpty),
            const SizedBox(height: JudoSpacing.md),
            ElevatedButton.icon(
              key: const ValueKey('link-current-athlete-action'),
              onPressed: provider.isBusy
                  ? null
                  : () => _linkCurrentAthlete(context, provider),
              icon: const Icon(Icons.link),
              label: Text(l10n.clubLinkCurrentAthlete),
            ),
          ] else
            ListTile(
              key: const ValueKey('current-athlete-membership'),
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(JudoIcons.athlete)),
              title: Text(displayName),
              subtitle: Text(l10n.clubCurrentAthleteLinked),
              trailing: const Icon(
                Icons.check_circle,
                color: JudoColors.success,
              ),
            ),
          const SizedBox(height: JudoSpacing.md),
          Text(
            l10n.clubAthleteLinkLimitation,
            key: const ValueKey('club-athlete-link-limitation'),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: JudoColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _Groups extends StatelessWidget {
  const _Groups({required this.provider});

  final LocalClubAdministrationProvider provider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groups = provider.snapshot.groups;
    return _Panel(
      key: const ValueKey('club-groups'),
      title: l10n.clubGroupsTitle,
      icon: JudoIcons.training,
      trailing: TextButton.icon(
        key: const ValueKey('create-group-action'),
        onPressed: provider.isBusy
            ? null
            : () => _createGroup(context, provider),
        icon: const Icon(Icons.add),
        label: Text(l10n.clubGroupCreateAction),
      ),
      child: groups.isEmpty
          ? Text(l10n.clubGroupEmpty)
          : Column(
              children: [
                for (final group in groups)
                  ListTile(
                    key: ValueKey('club-group-${group.id}'),
                    contentPadding: EdgeInsets.zero,
                    title: Text(group.name),
                    subtitle: Text(
                      l10n.clubGroupMemberCount(
                        localizedClubNumber(
                          context,
                          group.membershipIds.length,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _Sessions extends StatelessWidget {
  const _Sessions({required this.provider});

  final LocalClubAdministrationProvider provider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sessions = provider.snapshot.sessions;
    return _Panel(
      key: const ValueKey('club-sessions'),
      title: l10n.clubSessionsTitle,
      icon: Icons.event_outlined,
      trailing: TextButton.icon(
        key: const ValueKey('create-session-action'),
        onPressed: provider.isBusy
            ? null
            : () {
                if (provider.snapshot.groups.isEmpty) {
                  _message(context, l10n.clubCreateGroupFirst);
                  return;
                }
                _createSession(context, provider);
              },
        icon: const Icon(Icons.add),
        label: Text(l10n.clubSessionCreateAction),
      ),
      child: sessions.isEmpty
          ? Text(l10n.clubSessionEmpty)
          : Column(
              children: [
                for (final session in sessions)
                  _SessionCard(provider: provider, session: session),
              ],
            ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.provider, required this.session});

  final LocalClubAdministrationProvider provider;
  final ClubTrainingSession session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final group = provider.snapshot.groups.singleWhere(
      (value) => value.id == session.groupId,
    );
    final title =
        session.title ?? clubSessionTypeLabel(l10n, session.sessionType);
    return Card(
      key: ValueKey('club-session-${session.id}'),
      margin: const EdgeInsets.only(bottom: JudoSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(JudoSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  key: ValueKey('edit-session-${session.id}'),
                  tooltip: l10n.clubSessionEditAction,
                  onPressed: provider.isBusy
                      ? null
                      : () => _editSession(context, provider, session),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
            const SizedBox(height: JudoSpacing.xs),
            Text(
              '${l10n.clubSessionTypeLabel}: '
              '${clubSessionTypeLabel(l10n, session.sessionType)}',
            ),
            Text('${l10n.clubSessionGroupLabel}: ${group.name}'),
            if (session.sessionType == ClubSessionType.unspecifiedLegacy)
              Text(
                l10n.clubLegacySessionTypeNotice,
                style: const TextStyle(color: JudoColors.warning),
              ),
            if (session.objective != null)
              Text('${l10n.clubSessionObjectiveLabel}: ${session.objective}'),
            Text(
              '${l10n.clubSessionScheduledLabel}: '
              '${localizedClubDateTime(context, session.scheduledAtUtc)}',
            ),
            if (session.durationMinutes != null)
              Text(
                l10n.clubSessionDurationValue(
                  localizedClubNumber(context, session.durationMinutes!),
                ),
              ),
            const Divider(height: JudoSpacing.xxl),
            Text(
              l10n.clubSessionItemsTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: JudoSpacing.xs),
            Text(
              l10n.clubSessionItemsOptional,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: JudoColors.textSecondary),
            ),
            const SizedBox(height: JudoSpacing.sm),
            if (session.items.isEmpty)
              Text(
                l10n.clubSessionItemsEmpty,
                key: ValueKey('session-plan-empty-${session.id}'),
              )
            else
              for (final item in session.items)
                _SessionPlanItemView(item: item),
            if (group.membershipIds.isNotEmpty) ...[
              const Divider(height: JudoSpacing.xxl),
              Text(
                l10n.clubAttendanceTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: JudoSpacing.sm),
              for (final membershipId in group.membershipIds)
                _AttendanceControls(
                  provider: provider,
                  sessionId: session.id,
                  membershipId: membershipId,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AttendanceControls extends StatelessWidget {
  const _AttendanceControls({
    required this.provider,
    required this.sessionId,
    required this.membershipId,
  });

  final LocalClubAdministrationProvider provider;
  final String sessionId;
  final String membershipId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final records = provider.snapshot.attendanceRecords.where(
      (value) =>
          value.sessionId == sessionId && value.membershipId == membershipId,
    );
    final selected = records.isEmpty ? null : records.single.state;
    return Semantics(
      container: true,
      label: l10n.clubAttendanceTitle,
      child: Wrap(
        key: ValueKey('attendance-controls-$sessionId-$membershipId'),
        spacing: JudoSpacing.sm,
        runSpacing: JudoSpacing.sm,
        children: [
          for (final state in AttendanceState.values)
            ChoiceChip(
              key: ValueKey(
                'attendance-$sessionId-$membershipId-${state.name}',
              ),
              label: Text(_attendanceLabel(l10n, state)),
              selected: selected == state,
              onSelected: provider.isBusy
                  ? null
                  : (_) async {
                      final messenger = ScaffoldMessenger.of(context);
                      final successMessage = l10n.clubAttendanceSavedFeedback;
                      final failureMessage = l10n.clubOperationFailed;
                      final saved = await provider.recordAttendance(
                        sessionId: sessionId,
                        membershipId: membershipId,
                        attendanceState: state,
                      );
                      _showMessage(
                        messenger,
                        saved ? successMessage : failureMessage,
                      );
                    },
            ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(JudoSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: JudoColors.primary),
              const SizedBox(width: JudoSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: JudoSpacing.md),
          child,
        ],
      ),
    ),
  );
}

class _CountChip extends StatelessWidget {
  const _CountChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: JudoSpacing.md,
      vertical: JudoSpacing.sm,
    ),
    decoration: BoxDecoration(
      color: JudoColors.surfaceVariant,
      borderRadius: BorderRadius.circular(JudoRadius.sm),
    ),
    child: Text(label),
  );
}

class _SessionPlanItemView extends StatelessWidget {
  const _SessionPlanItemView({required this.item});

  final TrainingSessionItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title =
        item.exerciseSnapshot?.localizedName(
          Localizations.localeOf(context).languageCode,
        ) ??
        item.customTitle ??
        clubSessionItemTypeLabel(l10n, item.type);
    return Padding(
      key: ValueKey('session-plan-item-${item.id}'),
      padding: const EdgeInsets.only(bottom: JudoSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          Text(clubDosageSummary(context, l10n, item.dosage)),
          if (item.exerciseSnapshot != null) ...[
            Text(
              l10n.exerciseLinkedReference(
                localizedClubNumber(context, item.exerciseSnapshot!.revision),
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              item.exerciseSnapshot!.source ==
                      ExerciseLibrarySource.approvedRepository
                  ? l10n.exerciseApprovedBadge
                  : l10n.exerciseCoachAuthoredDisclosure,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (item.restSeconds != null)
            Text(
              l10n.clubSessionRestValue(
                localizedClubNumber(context, item.restSeconds!),
              ),
            ),
          if (item.coachNotes != null) Text(item.coachNotes!),
          if (item.requiresCoachAuthoredTitle)
            Text(
              l10n.clubSessionCoachAuthoredDisclosure,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: JudoColors.textSecondary),
            ),
        ],
      ),
    );
  }
}

Future<void> _editClub(
  BuildContext context,
  LocalClubAdministrationProvider provider,
) async {
  final draft = await showDialog<_ClubDraft>(
    context: context,
    builder: (_) => _ClubDialog(club: provider.snapshot.club),
  );
  if (draft == null || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  final l10n = AppLocalizations.of(context)!;
  final saved = await provider.saveClub(
    name: draft.name,
    description: draft.description,
  );
  _showMessage(messenger, saved ? l10n.clubSavedFeedback : l10n.clubSaveFailed);
}

Future<void> _linkCurrentAthlete(
  BuildContext context,
  LocalClubAdministrationProvider provider,
) async {
  final l10n = AppLocalizations.of(context)!;
  final controller = TextEditingController();
  final number = await showDialog<String?>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.clubLinkCurrentAthlete),
      content: TextField(
        key: const ValueKey('membership-number-field'),
        controller: controller,
        maxLength: ClubMembership.membershipNumberMaxLength,
        decoration: InputDecoration(labelText: l10n.clubMembershipNumberLabel),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          key: const ValueKey('confirm-link-athlete-action'),
          onPressed: () => Navigator.pop(dialogContext, controller.text),
          child: Text(l10n.clubLinkCurrentAthlete),
        ),
      ],
    ),
  );
  controller.dispose();
  if (number == null || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  final saved = await provider.linkCurrentAthlete(membershipNumber: number);
  _showMessage(
    messenger,
    saved ? l10n.clubAthleteLinkedFeedback : l10n.clubOperationFailed,
  );
}

Future<void> _createGroup(
  BuildContext context,
  LocalClubAdministrationProvider provider,
) async {
  final draft = await showDialog<_GroupDraft>(
    context: context,
    builder: (_) => _GroupDialog(memberships: provider.snapshot.memberships),
  );
  if (draft == null || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  final l10n = AppLocalizations.of(context)!;
  final saved = await provider.createGroup(
    name: draft.name,
    description: draft.description,
    membershipIds: draft.membershipIds,
  );
  _showMessage(
    messenger,
    saved ? l10n.clubGroupSavedFeedback : l10n.clubOperationFailed,
  );
}

Future<void> _createSession(
  BuildContext context,
  LocalClubAdministrationProvider provider,
) async {
  final draft = await showDialog<SessionPlannerDraft>(
    context: context,
    builder: (_) => SessionPlannerDialog(
      provider: provider,
      exerciseLibraryProvider: context.read<LocalExerciseLibraryProvider?>(),
      groups: provider.snapshot.groups,
    ),
  );
  if (draft == null || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  final l10n = AppLocalizations.of(context)!;
  final saved = await provider.createSession(
    groupId: draft.groupId,
    sessionType: draft.sessionType,
    title: draft.title,
    objective: draft.objective,
    scheduledAt: draft.scheduledAt,
    durationMinutes: draft.durationMinutes,
    items: draft.items,
  );
  _showMessage(
    messenger,
    saved ? l10n.clubSessionSavedFeedback : l10n.clubOperationFailed,
  );
}

Future<void> _editSession(
  BuildContext context,
  LocalClubAdministrationProvider provider,
  ClubTrainingSession session,
) async {
  final draft = await showDialog<SessionPlannerDraft>(
    context: context,
    builder: (_) => SessionPlannerDialog(
      provider: provider,
      exerciseLibraryProvider: context.read<LocalExerciseLibraryProvider?>(),
      groups: provider.snapshot.groups,
      existingSession: session,
    ),
  );
  if (draft == null || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  final l10n = AppLocalizations.of(context)!;
  final saved = await provider.updateSession(
    sessionId: session.id,
    groupId: draft.groupId,
    sessionType: draft.sessionType,
    title: draft.title,
    objective: draft.objective,
    scheduledAt: draft.scheduledAt,
    durationMinutes: draft.durationMinutes,
    items: draft.items,
  );
  _showMessage(
    messenger,
    saved ? l10n.clubSessionSavedFeedback : l10n.clubOperationFailed,
  );
}

void _message(BuildContext context, String message) {
  _showMessage(ScaffoldMessenger.of(context), message);
}

void _showMessage(ScaffoldMessengerState messenger, String message) {
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

String _attendanceLabel(AppLocalizations l10n, AttendanceState state) =>
    switch (state) {
      AttendanceState.present => l10n.clubAttendancePresent,
      AttendanceState.absent => l10n.clubAttendanceAbsent,
      AttendanceState.excused => l10n.clubAttendanceExcused,
    };

class _ClubDraft {
  const _ClubDraft(this.name, this.description);
  final String name;
  final String? description;
}

class _ClubDialog extends StatefulWidget {
  const _ClubDialog({required this.club});
  final Club? club;

  @override
  State<_ClubDialog> createState() => _ClubDialogState();
}

class _ClubDialogState extends State<_ClubDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.club?.name);
    _description = TextEditingController(text: widget.club?.description);
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(
        widget.club == null ? l10n.clubCreateAction : l10n.clubEditAction,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              key: const ValueKey('club-name-field'),
              controller: _name,
              maxLength: Club.nameMaxLength,
              decoration: InputDecoration(labelText: l10n.clubNameLabel),
              validator: (value) => value == null || value.trim().isEmpty
                  ? l10n.clubRequiredField
                  : null,
            ),
            TextFormField(
              key: const ValueKey('club-description-field'),
              controller: _description,
              maxLength: Club.descriptionMaxLength,
              decoration: InputDecoration(labelText: l10n.clubDescriptionLabel),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          key: const ValueKey('save-club-action'),
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(context, _ClubDraft(_name.text, _description.text));
          },
          child: Text(l10n.clubSaveAction),
        ),
      ],
    );
  }
}

class _GroupDraft {
  const _GroupDraft(this.name, this.description, this.membershipIds);
  final String name;
  final String? description;
  final List<String> membershipIds;
}

class _GroupDialog extends StatefulWidget {
  const _GroupDialog({required this.memberships});
  final List<ClubMembership> memberships;

  @override
  State<_GroupDialog> createState() => _GroupDialogState();
}

class _GroupDialogState extends State<_GroupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  bool _assignCurrent = true;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.clubGroupCreateAction),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              key: const ValueKey('group-name-field'),
              controller: _name,
              maxLength: TrainingGroup.nameMaxLength,
              decoration: InputDecoration(labelText: l10n.clubGroupNameLabel),
              validator: (value) => value == null || value.trim().isEmpty
                  ? l10n.clubRequiredField
                  : null,
            ),
            TextFormField(
              controller: _description,
              maxLength: TrainingGroup.descriptionMaxLength,
              decoration: InputDecoration(
                labelText: l10n.clubGroupDescriptionLabel,
              ),
            ),
            if (widget.memberships.isNotEmpty)
              CheckboxListTile(
                key: const ValueKey('assign-current-athlete-checkbox'),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _assignCurrent,
                onChanged: (value) =>
                    setState(() => _assignCurrent = value ?? false),
                title: Text(l10n.clubGroupAssignCurrentAthlete),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          key: const ValueKey('save-group-action'),
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(
              context,
              _GroupDraft(
                _name.text,
                _description.text,
                _assignCurrent
                    ? widget.memberships
                          .map((value) => value.id)
                          .toList(growable: false)
                    : const [],
              ),
            );
          },
          child: Text(l10n.clubGroupCreateAction),
        ),
      ],
    );
  }
}
