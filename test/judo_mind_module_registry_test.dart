import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/core/constants/modules.dart';
import 'package:judo_mind/models/module_model.dart';

void main() {
  test('official registry contains exactly 18 unique canonical modules', () {
    final modules = JudoMindModules.modules;

    expect(modules, hasLength(18));
    expect(modules.map((module) => module.id).toSet(), hasLength(18));
    expect(
      modules.map((module) => module.canonicalName).toSet(),
      hasLength(18),
    );
    expect(
      modules.map((module) => module.localizedDisplayKey).toSet(),
      hasLength(18),
    );
    expect(modules.any((module) => module.id == 'medical-support'), isFalse);
    expect(modules.any((module) => module.id == 'nutrition'), isFalse);
  });

  test('product charter module list matches the canonical code registry', () {
    final charter = File(
      'docs/JUDO_MIND_PRODUCT_FRAMEWORK.md',
    ).readAsStringSync();
    final block = RegExp(
      r'<!-- OFFICIAL_MODULES_START -->([\s\S]*?)<!-- OFFICIAL_MODULES_END -->',
    ).firstMatch(charter);

    expect(block, isNotNull, reason: 'Canonical charter markers are required.');

    final documentedNames = RegExp(r'^\d+\.\s+(.+)$', multiLine: true)
        .allMatches(block!.group(1)!)
        .map((match) => match.group(1)!.trim())
        .toList(growable: false);
    final registeredNames = JudoMindModules.modules
        .map((module) => module.canonicalName)
        .toList(growable: false);

    expect(documentedNames, hasLength(18));
    expect(documentedNames, registeredNames);
  });

  test(
    'only real destinations are reachable and unavailable modules fail closed',
    () {
      final reachable = JudoMindModules.reachableModules;
      final unavailable = JudoMindModules.unavailableModules;

      expect(reachable.map((module) => module.id).toSet(), {
        'home',
        'techniques',
        'monitoring-progress-mastery',
        'athlete-profile',
        'club-administration',
        'app-management-settings',
      });
      expect(unavailable, hasLength(12));
      for (final module in unavailable) {
        expect(module.route, isNull, reason: module.id);
        expect(module.unavailableReason?.trim(), isNotEmpty, reason: module.id);
        expect(module.isReachable, isFalse, reason: module.id);
      }
    },
  );

  test(
    'athlete Home is a derived reachable subset, not an 18-tile registry',
    () {
      expect(
        JudoMindModules.athleteHomeModules.map((module) => module.id).toList(),
        ['techniques', 'athlete-profile'],
      );
      for (final module in JudoMindModules.athleteHomeModules) {
        expect(module.showOnAthleteHome, isTrue);
        expect(module.isReachable, isTrue);
        expect(module.icon, isNotNull);
      }
    },
  );

  test('every module declares at least one coordinated platform surface', () {
    for (final module in JudoMindModules.modules) {
      expect(module.surfaces, isNotEmpty, reason: module.id);
      expect(module.readiness, isA<JudoMindModuleReadiness>());
    }
  });
}
