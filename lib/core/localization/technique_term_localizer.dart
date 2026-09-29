import '../../l10n/app_localizations.dart';

/// Localizes stable technique taxonomy values while preserving their canonical
/// raw values for filtering and storage.
abstract final class TechniqueTermLocalizer {
  const TechniqueTermLocalizer._();

  static String taxonomy(AppLocalizations l10n, String rawValue) {
    return switch (_normalize(rawValue)) {
      'nage waza' => l10n.nageWaza,
      'katame waza' => l10n.katameWaza,
      'te waza' => l10n.teWaza,
      'koshi waza' => l10n.koshiWaza,
      'ashi waza' => l10n.ashiWaza,
      'ma sutemi waza' => l10n.maSutemiWaza,
      'yoko sutemi waza' => l10n.yokoSutemiWaza,
      'sutemi waza' => l10n.sutemiWaza,
      'osaekomi waza' => l10n.osaekomiWaza,
      'shime waza' => l10n.shimeWaza,
      'kansetsu waza' => l10n.kansetsuWaza,
      'ne waza' => l10n.neWaza,
      'tachi waza' => l10n.tachiWaza,
      _ => rawValue,
    };
  }

  static String difficulty(AppLocalizations l10n, String rawValue) {
    return switch (_normalize(rawValue)) {
      'beginner' || 'basic' => l10n.beginner,
      'intermediate' => l10n.intermediate,
      'advanced' || 'expert' => l10n.advanced,
      'elite' => l10n.eliteLevel,
      _ => rawValue,
    };
  }

  static String filter(AppLocalizations l10n, String rawValue) {
    return switch (_normalize(rawValue)) {
      'all' => l10n.allCategories,
      'all levels' => l10n.allLevels,
      _ => difficulty(l10n, taxonomy(l10n, rawValue)),
    };
  }

  static String _normalize(String value) => value
      .trim()
      .toLowerCase()
      .replaceAll('-', ' ')
      .replaceAll(RegExp(r'\s+'), ' ');
}
