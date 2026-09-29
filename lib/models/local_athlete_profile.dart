/// Versioned local/demo-only athlete profile containing optional,
/// explicitly self-reported fields.
class LocalAthleteProfile {
  const LocalAthleteProfile({
    required this.schemaVersion,
    required this.displayName,
    required this.beltRank,
    required this.club,
    required this.country,
    required this.biography,
  });

  static const currentSchemaVersion = '1.0.0';
  static const provenance = 'self-reported';
  static const storageScope = 'local-device';
  static const displayNameMaxLength = 80;
  static const beltRankMaxLength = 40;
  static const clubMaxLength = 120;
  static const countryMaxLength = 80;
  static const biographyMaxLength = 500;

  const LocalAthleteProfile.empty()
    : schemaVersion = currentSchemaVersion,
      displayName = null,
      beltRank = null,
      club = null,
      country = null,
      biography = null;

  final String schemaVersion;
  final String? displayName;
  final String? beltRank;
  final String? club;
  final String? country;
  final String? biography;

  bool get isEmpty =>
      displayName == null &&
      beltRank == null &&
      club == null &&
      country == null &&
      biography == null;

  bool get isValid =>
      schemaVersion == currentSchemaVersion &&
      _isValidOptional(displayName, displayNameMaxLength) &&
      _isValidOptional(beltRank, beltRankMaxLength) &&
      _isValidOptional(club, clubMaxLength) &&
      _isValidOptional(country, countryMaxLength) &&
      _isValidOptional(biography, biographyMaxLength);

  factory LocalAthleteProfile.fromInput({
    String? displayName,
    String? beltRank,
    String? club,
    String? country,
    String? biography,
  }) {
    final profile = LocalAthleteProfile(
      schemaVersion: currentSchemaVersion,
      displayName: _normalize(displayName),
      beltRank: _normalize(beltRank),
      club: _normalize(club),
      country: _normalize(country),
      biography: _normalize(biography),
    );
    if (!profile.isValid) {
      throw const FormatException('Invalid local athlete profile.');
    }
    return profile;
  }

  factory LocalAthleteProfile.fromJson(Map<String, dynamic> json) {
    const expectedKeys = {
      'schema_version',
      'provenance',
      'storage_scope',
      'display_name',
      'belt_rank',
      'club',
      'country',
      'biography',
    };
    if (json.keys.toSet().length != expectedKeys.length ||
        !json.keys.toSet().containsAll(expectedKeys) ||
        json['schema_version'] != currentSchemaVersion ||
        json['provenance'] != provenance ||
        json['storage_scope'] != storageScope) {
      throw const FormatException('Unsupported local athlete profile schema.');
    }

    final profile = LocalAthleteProfile(
      schemaVersion: json['schema_version'] as String,
      displayName: _optionalString(json, 'display_name'),
      beltRank: _optionalString(json, 'belt_rank'),
      club: _optionalString(json, 'club'),
      country: _optionalString(json, 'country'),
      biography: _optionalString(json, 'biography'),
    );
    if (!profile.isValid) {
      throw const FormatException('Invalid local athlete profile payload.');
    }
    return profile;
  }

  Map<String, dynamic> toJson() => {
    'schema_version': schemaVersion,
    'provenance': provenance,
    'storage_scope': storageScope,
    'display_name': displayName,
    'belt_rank': beltRank,
    'club': club,
    'country': country,
    'biography': biography,
  };
}

String? _normalize(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}

String? _optionalString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null || value is String) {
    return value as String?;
  }
  throw FormatException('$key must be a string or null.');
}

bool _isValidOptional(String? value, int maxLength) {
  if (value == null) {
    return true;
  }
  return value.isNotEmpty &&
      value == value.trim() &&
      value.length <= maxLength &&
      !value.contains(RegExp(r'[\u0000-\u0008\u000B\u000C\u000E-\u001F]'));
}
