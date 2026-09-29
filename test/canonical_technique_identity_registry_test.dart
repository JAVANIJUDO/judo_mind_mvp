import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/core/scientific_transparency/scientific_transparency_model.dart';
import 'package:judo_mind/core/scientific_transparency/uchi_mata_scientific_transparency.dart';
import 'package:judo_mind/data/techniques/canonical_technique_identity_registry.dart';
import 'package:judo_mind/data/techniques/technique_factory.dart';
import 'package:judo_mind/models/canonical_technique_identity.dart';
import 'package:judo_mind/models/technique_model.dart';
import 'package:judo_mind/screens/technique_detail/technique_detail_route_policy.dart';

const _registryPath =
    'docs/technique_registry/JM_CANONICAL_TECHNIQUE_IDENTITY_REGISTRY.csv';
const _standardPath =
    'docs/scientific_foundation/JM_TECHNIQUE_EXPLANATION_CONTENT_STANDARD_EN_FA.md';

void main() {
  final table = _readCsv(_registryPath);

  test('registry has exactly 67 rows and the required 23-column width', () {
    expect(table.rows, hasLength(67));
    expect(table.header, hasLength(23));
  });

  test('registry has exactly 67 unique three-digit IDs', () {
    final ids = table.rows.map((row) => row['technique_id']!).toList();
    expect(ids.toSet(), hasLength(67));
    expect(ids.every((id) => RegExp(r'^\d{3}$').hasMatch(id)), isTrue);
  });

  test('001 remains Uchi Mata', () {
    final row = table.byId('001');
    expect(row['canonical_english_name'], 'Uchi Mata');
    expect(
      row['identity_verification_state'],
      'VERIFIED_EXISTING_PROJECT_RECORD',
    );
  });

  test('existing IDs 002-005 preserve their project identities', () {
    expect(table.byId('002')['canonical_english_name'], 'Seoi Nage');
    expect(table.byId('003')['canonical_english_name'], 'O Soto Gari');
    expect(table.byId('004')['canonical_english_name'], 'Harai Goshi');
    expect(table.byId('005')['canonical_english_name'], 'Tomoe Nage');
  });

  test('canonical identities and romanized names are unique', () {
    final keys = table.rows
        .map((row) => row['canonical_japanese_romanized_name']!.toLowerCase())
        .toList();
    expect(keys.toSet(), hasLength(keys.length));
  });

  test('typed registry exactly mirrors CSV identity fields', () {
    final records = CanonicalTechniqueIdentityRegistry.records;
    expect(records, hasLength(67));
    for (final record in records) {
      final row = table.byId(record.techniqueId);
      expect(record.canonicalEnglishName, row['canonical_english_name']);
      expect(
        record.canonicalJapaneseRomanizedName,
        row['canonical_japanese_romanized_name'],
      );
      expect(record.canonicalJapaneseScript, row['canonical_japanese_script']);
      expect(record.subclassification, row['subclassification']);
      expect(
        record.identityVerificationState.wireValue,
        row['identity_verification_state'],
      );
    }
  });

  test('runtime catalog IDs are valid registry foreign keys', () {
    final registryIds = CanonicalTechniqueIdentityRegistry.records
        .map((record) => record.techniqueId)
        .toSet();
    expect(
      TechniqueFactory.allTechniques.every(
        (technique) => registryIds.contains(technique.id),
      ),
      isTrue,
    );
    expect(TechniqueFactory.officialRoadmapTechniqueCount, 67);
  });

  test('classification values and counts match the bounded 67 roster', () {
    const expected = <String, int>{
      'TE_WAZA': 16,
      'KOSHI_WAZA': 10,
      'ASHI_WAZA': 21,
      'MA_SUTEMI_WAZA': 5,
      'YOKO_SUTEMI_WAZA': 15,
    };
    final actual = <String, int>{};
    for (final row in table.rows) {
      actual.update(
        row['subclassification']!,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    expect(actual, expected);
  });

  test('all registry rows remain locked and membership grants no unlock', () {
    expect(
      table.rows.every((row) => row['unlock_eligibility'] == 'LOCKED'),
      isTrue,
    );
    expect(
      CanonicalTechniqueIdentityRegistry.records.every(
        (record) => !record.isUnlocked,
      ),
      isTrue,
    );
    expect(TechniqueFactory.readOnlyEducationalTechniqueIds, isEmpty);
  });

  test('registry-to-route mapping preserves specialized Uchi Mata', () {
    final decision = TechniqueDetailRoutePolicy.resolve('001');
    expect(decision.kind, TechniqueDetailRouteKind.specializedUchiMata);
    expect(decision.canonicalIdentity?.techniqueId, '001');
  });

  test('normalized identity fails closed before absent model resolution', () {
    final decision = TechniqueDetailRoutePolicy.resolve('006');
    expect(decision.kind, TechniqueDetailRouteKind.locked);
    expect(
      decision.blockReason,
      TechniqueDetailRouteBlockReason.identityReviewRequired,
    );
    expect(decision.canonicalIdentity?.techniqueId, '006');
  });

  test('unknown identity fails closed', () {
    final decision = TechniqueDetailRoutePolicy.resolve('999');
    expect(decision.kind, TechniqueDetailRouteKind.locked);
    expect(decision.blockReason, TechniqueDetailRouteBlockReason.unknownId);
  });

  test('unresolved identity fails closed', () {
    final decision = TechniqueDetailRoutePolicy.resolve(
      '006',
      catalog: const [_fixture],
      readOnlyEducationalIds: const {'006'},
      identityRegistry: const [_unresolvedIdentity],
    );
    expect(decision.kind, TechniqueDetailRouteKind.locked);
    expect(
      decision.blockReason,
      TechniqueDetailRouteBlockReason.identityReviewRequired,
    );
  });

  test('conflicting identity fails closed', () {
    final decision = TechniqueDetailRoutePolicy.resolve('003');
    expect(decision.kind, TechniqueDetailRouteKind.locked);
    expect(
      decision.blockReason,
      TechniqueDetailRouteBlockReason.identityConflict,
    );
  });

  test('verified identity still requires explicit route eligibility', () {
    final decision = TechniqueDetailRoutePolicy.resolve(
      '006',
      catalog: const [_fixture],
      identityRegistry: const [_verifiedIdentity],
    );
    expect(decision.kind, TechniqueDetailRouteKind.locked);
    expect(
      decision.blockReason,
      TechniqueDetailRouteBlockReason.notReadOnlyEligible,
    );
  });

  test('explicit verified identity and eligibility resolve generic route', () {
    final decision = TechniqueDetailRoutePolicy.resolve(
      '006',
      catalog: const [_fixture],
      readOnlyEducationalIds: const {'006'},
      identityRegistry: const [_verifiedIdentity],
    );
    expect(decision.kind, TechniqueDetailRouteKind.genericReadOnly);
    expect(decision.canonicalIdentity, same(_verifiedIdentity));
  });

  test('non-001 identity inherits no scientific or analysis state', () {
    final snapshot = UchiMataScientificTransparency.forTechnique('002');
    expect(snapshot, same(ScientificTransparencySnapshot.failClosed));
    expect(snapshot.scientificApprovalIssued, isFalse);
    expect(snapshot.candidateSources, isEmpty);
  });

  test('Persian states distinguish reviewed from unavailable identities', () {
    final counts = <String, int>{};
    for (final row in table.rows) {
      counts.update(
        row['persian_name_state']!,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    expect(counts['EXISTING_REVIEWED'], 1);
    expect(counts['EXISTING_UNREVIEWED'], 4);
    expect(counts['TRANSLITERATION_PENDING_REVIEW'] ?? 0, 0);
    expect(counts['NOT_AVAILABLE'], 62);
  });

  test('explanation standard contains sections separation and safeguards', () {
    final standard = File(_standardPath).readAsStringSync();
    final normalizedStandard = standard
        .replaceAll(RegExp(r'\r?\n>\s?'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
    for (final section in const <String>[
      'TECHNIQUE_IDENTITY',
      'SHORT_OVERVIEW',
      'GRIP_AND_STARTING_POSITION',
      'KUZUSHI',
      'TSUKURI',
      'KAKE',
      'MAKIKOMI_OR_FOLLOW_THROUGH',
      'KEY_COACHING_POINTS',
      'COMMON_MISTAKES',
      'SAFETY_POINTS',
      'VARIATIONS',
      'COMBINATIONS',
      'COUNTERS',
      'VISUAL_EXPLANATION',
      'VIDEO_EXPLANATION',
      'TECHNICAL_INTERPRETATION',
      'BIOMECHANICAL_INTERPRETATION',
      'EVIDENCE_AND_REVIEW_STATUS',
      'TECHNICAL_EDUCATIONAL_CONTENT',
      'CONCEPTUAL_MECHANICAL_INTERPRETATION',
      'SCIENTIFIC_BIOMECHANICAL_EVIDENCE',
    ]) {
      expect(standard, contains(section), reason: section);
    }
    expect(
      normalizedStandard,
      contains(
        'This diagram is an educational interpretation. Arrows indicate conceptual movement or force directions and do not represent direct force measurement.',
      ),
    );
    expect(
      normalizedStandard,
      contains(
        'این نمودار یک تفسیر آموزشی است. فلش‌ها جهت‌های مفهومی حرکت یا نیرو را نشان',
      ),
    );
    expect(standard, contains('must not be copied'));
    expect(standard, contains('project-owned'));
    expect(standard, contains('properly licensed'));
    expect(standard, contains('recorded permission and provenance'));
  });
}

class _CsvTable {
  const _CsvTable(this.header, this.rows);

  final List<String> header;
  final List<Map<String, String>> rows;

  Map<String, String> byId(String id) =>
      rows.singleWhere((row) => row['technique_id'] == id);
}

_CsvTable _readCsv(String path) {
  final lines = File(path)
      .readAsLinesSync()
      .where((line) => line.trim().isNotEmpty)
      .toList(growable: false);
  final header = lines.first.split(',');
  final rows = lines
      .skip(1)
      .map((line) {
        final values = line.split(',');
    if (values.length != header.length) {
      throw FormatException(
        'CSV row width ${values.length} does not match ${header.length}: $line',
      );
    }
        return <String, String>{
          for (var index = 0; index < header.length; index++)
            header[index]: values[index],
        };
      })
      .toList(growable: false);
  return _CsvTable(header, rows);
}

const _verifiedIdentity = CanonicalTechniqueIdentity(
  techniqueId: '006',
  canonicalEnglishName: 'Neutral Fixture',
  canonicalJapaneseRomanizedName: 'Neutral-fixture',
  canonicalJapaneseScript: '試',
  persianName: '',
  persianNameState: TechniquePersianNameState.notAvailable,
  officialClassification: 'KODOKAN_NAGE_WAZA',
  techniqueFamily: 'THROWING_TECHNIQUE',
  nageWazaOrKatameWaza: 'NAGE_WAZA',
  subclassification: 'TE_WAZA',
  existingModelAvailable: true,
  identityVerificationState:
      TechniqueIdentityVerificationState.verifiedOfficialSource,
  classificationVerificationState:
      TechniqueIdentityVerificationState.verifiedOfficialSource,
  normalizationNotes: '',
  identityConflicts: '',
  technicalHumanReviewRequired: false,
);

const _unresolvedIdentity = CanonicalTechniqueIdentity(
  techniqueId: '006',
  canonicalEnglishName: '',
  canonicalJapaneseRomanizedName: '',
  canonicalJapaneseScript: '',
  persianName: '',
  persianNameState: TechniquePersianNameState.notAvailable,
  officialClassification: '',
  techniqueFamily: '',
  nageWazaOrKatameWaza: '',
  subclassification: '',
  existingModelAvailable: true,
  identityVerificationState: TechniqueIdentityVerificationState.unresolved,
  classificationVerificationState:
      TechniqueIdentityVerificationState.unresolved,
  normalizationNotes: '',
  identityConflicts: '',
  technicalHumanReviewRequired: true,
);

const _fixture = TechniqueModel(
  id: '006',
  englishName: 'Neutral Fixture',
  japaneseName: '試',
  category: 'Nage Waza',
  type: 'Te Waza',
  beltLevel: 'Unavailable',
  difficulty: 'Unavailable',
  description: '',
  technicalAnalysis: '',
  translations: [],
  images: [],
  videos: [],
  trainingVideo: '',
  competitionVideo: '',
  executionSteps: [],
  keyPoints: [],
  commonMistakes: [],
  safetyTips: [],
  combinations: [],
  counters: [],
  quiz: [],
  sources: [],
);
