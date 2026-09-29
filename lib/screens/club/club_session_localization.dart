import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../models/local_club_administration.dart';

String localizedClubNumber(BuildContext context, num value) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return NumberFormat.decimalPattern(locale).format(value);
}

String localizedClubDateTime(BuildContext context, DateTime value) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  final local = value.toLocal();
  return '${DateFormat.yMMMMEEEEd(locale).format(local)} · '
      '${DateFormat.jm(locale).format(local)}';
}

String localizedClubCompactDate(BuildContext context, DateTime value) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.yMd(locale).format(value);
}

String clubSessionTypeLabel(AppLocalizations l10n, ClubSessionType type) =>
    switch (type) {
      ClubSessionType.judoTechnical => l10n.clubSessionTypeJudoTechnical,
      ClubSessionType.randori => l10n.clubSessionTypeRandori,
      ClubSessionType.tactical => l10n.clubSessionTypeTactical,
      ClubSessionType.physicalPreparation =>
        l10n.clubSessionTypePhysicalPreparation,
      ClubSessionType.recovery => l10n.clubSessionTypeRecovery,
      ClubSessionType.assessment => l10n.clubSessionTypeAssessment,
      ClubSessionType.mixed => l10n.clubSessionTypeMixed,
      ClubSessionType.other => l10n.clubSessionTypeOther,
      ClubSessionType.unspecifiedLegacy =>
        l10n.clubSessionTypeUnspecifiedLegacy,
    };

String clubSessionItemTypeLabel(
  AppLocalizations l10n,
  TrainingSessionItemType type,
) => switch (type) {
  TrainingSessionItemType.warmUp => l10n.clubSessionItemWarmUp,
  TrainingSessionItemType.ukemi => l10n.clubSessionItemUkemi,
  TrainingSessionItemType.technicalInstruction =>
    l10n.clubSessionItemTechnicalInstruction,
  TrainingSessionItemType.uchikomi => l10n.clubSessionItemUchikomi,
  TrainingSessionItemType.nagekomi => l10n.clubSessionItemNagekomi,
  TrainingSessionItemType.gripFightingKumiKata =>
    l10n.clubSessionItemGripFighting,
  TrainingSessionItemType.tachiWaza => l10n.clubSessionItemTachiWaza,
  TrainingSessionItemType.neWaza => l10n.clubSessionItemNeWaza,
  TrainingSessionItemType.randori => l10n.clubSessionItemRandori,
  TrainingSessionItemType.tacticalPractice =>
    l10n.clubSessionItemTacticalPractice,
  TrainingSessionItemType.coolDown => l10n.clubSessionItemCoolDown,
  TrainingSessionItemType.physicalConditioningCustom =>
    l10n.clubSessionItemPhysicalConditioningCustom,
  TrainingSessionItemType.customCoachAuthored =>
    l10n.clubSessionItemCustomCoachAuthored,
};

String clubDosageModeLabel(AppLocalizations l10n, TrainingDosageMode mode) =>
    switch (mode) {
      TrainingDosageMode.duration => l10n.clubSessionDosageDuration,
      TrainingDosageMode.repetitions => l10n.clubSessionDosageRepetitions,
      TrainingDosageMode.setsRepetitions =>
        l10n.clubSessionDosageSetsRepetitions,
      TrainingDosageMode.roundsDuration => l10n.clubSessionDosageRoundsDuration,
      TrainingDosageMode.distance => l10n.clubSessionDosageDistance,
      TrainingDosageMode.descriptiveCustom => l10n.clubSessionDosageDescriptive,
    };

String clubDosageSummary(
  BuildContext context,
  AppLocalizations l10n,
  TrainingSessionDosage dosage,
) => switch (dosage.mode) {
  TrainingDosageMode.duration => l10n.clubSessionDosageDurationValue(
    localizedClubNumber(context, dosage.durationMinutes!),
  ),
  TrainingDosageMode.repetitions => l10n.clubSessionDosageRepetitionsValue(
    localizedClubNumber(context, dosage.repetitions!),
  ),
  TrainingDosageMode.setsRepetitions => l10n.clubSessionDosageSetsValue(
    localizedClubNumber(context, dosage.sets!),
    localizedClubNumber(context, dosage.repetitions!),
  ),
  TrainingDosageMode.roundsDuration => l10n.clubSessionDosageRoundsValue(
    localizedClubNumber(context, dosage.rounds!),
    localizedClubNumber(context, dosage.roundDurationMinutes!),
  ),
  TrainingDosageMode.distance => l10n.clubSessionDosageDistanceValue(
    localizedClubNumber(context, dosage.distanceMeters!),
  ),
  TrainingDosageMode.descriptiveCustom => dosage.description!,
};
