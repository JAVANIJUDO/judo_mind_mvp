import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/core/localization/technique_term_localizer.dart';
import 'package:judo_mind/l10n/app_localizations_en.dart';
import 'package:judo_mind/l10n/app_localizations_fa.dart';

void main() {
  test('Persian runtime closes every English template message', () {
    final en = _arb('lib/l10n/app_en.arb');
    final fa = _arb('lib/l10n/app_fa.arb');
    final templateKeys = en.keys.where((key) => !key.startsWith('@')).toSet();
    final persianKeys = fa.keys.where((key) => !key.startsWith('@')).toSet();

    expect(templateKeys.difference(persianKeys), isEmpty);
    expect(templateKeys, hasLength(persianKeys.length));
    expect(templateKeys, isNot(contains('profile')));
    expect(templateKeys, isNot(contains('retry')));
  });

  test('reachable aliases use the approved current Persian messages', () {
    final homeSource = File(
      'lib/screens/home/home_screen.dart',
    ).readAsStringSync();
    final progressSource = File(
      'lib/screens/progress/progress_overview_screen.dart',
    ).readAsStringSync();

    expect(homeSource, contains('l10n.moduleAthleteProfileTitle'));
    expect(homeSource, isNot(contains('l10n.profile')));
    expect(progressSource, contains('l10n.retryLabel'));
    expect(progressSource, isNot(contains('l10n.retry,')));
  });

  test('approved high-traffic Persian wording is natural and complete', () {
    final fa = _arb('lib/l10n/app_fa.arb');

    expect(fa['homeAnalyzeUchiMataTitle'], 'تحلیل اجرای اوچی‌ماتا');
    expect(fa['journeyTrackProgressTitle'], 'مرور تحلیل‌ها');
    expect(fa['localAnalysisHistoryTitle'], 'سابقه اعتبارسنجی محلی');
    expect(fa['unavailableLabel'], 'هنوز در دسترس نیست');
    expect(fa['moduleStatusFoundationPartial'], 'در حال تکمیل');
    expect(fa['exploreAllCapabilities'], 'مشاهده همه بخش‌ها');
    expect(fa['settingsScientificBoundaryTitle'], 'اعتبار علمی و محدودیت‌ها');
    expect(fa['settingsLocalDataTitle'], 'داده‌های روی دستگاه و حریم خصوصی');
    expect(fa['advanced'], 'پیشرفته');
    expect(fa['startTraining'], 'شروع تمرین');
    expect(fa['champions'], 'قهرمانان');

    for (final key in const [
      'homeAnalyzeUchiMataTitle',
      'journeyTrackProgressTitle',
      'localAnalysisHistoryTitle',
      'unavailableLabel',
      'moduleStatusFoundationPartial',
      'exploreAllCapabilities',
      'settingsScientificBoundaryTitle',
      'settingsLocalDataTitle',
      'homeJourneyAnalyzeDescription',
      'homeJourneyTrackProgressDescription',
      'homeJourneyCoachUnavailable',
      'techniqueTrainingUnavailable',
      'analysisNoticeDescription',
    ]) {
      expect(
        fa[key],
        isNot(matches(RegExp('[A-Za-z]'))),
        reason: '$key must not expose English in Persian mode',
      );
    }
  });

  test('Judo taxonomy keeps Japanese identity with Persian context', () {
    final fa = AppLocalizationsFa();
    expect(
      TechniqueTermLocalizer.taxonomy(fa, 'Nage Waza'),
      'ناگه‌وازا (فنون پرتابی)',
    );
    expect(
      TechniqueTermLocalizer.taxonomy(fa, 'Ashi Waza'),
      'آشی‌وازا (فنون پا)',
    );
    expect(TechniqueTermLocalizer.difficulty(fa, 'Advanced'), 'پیشرفته');
    expect(TechniqueTermLocalizer.filter(fa, 'All Levels'), 'همه سطح‌ها');
  });

  test('English product wording remains intact', () {
    final en = AppLocalizationsEn();
    expect(en.homeAnalyzeUchiMataTitle, 'Analyze Uchi Mata');
    expect(en.journeyTrackProgressTitle, 'Track Progress');
    expect(en.localAnalysisHistoryTitle, 'Local validation history');
    expect(en.unavailableLabel, 'Unavailable');
  });

  test('reachable screens contain no legacy English Analyze literals', () {
    for (final path in const [
      'lib/screens/technique_detail/widgets/analyze/analyze_section.dart',
      'lib/screens/techniques/techniques_screen.dart',
      'lib/screens/techniques/widgets/technique_search_bar.dart',
      'lib/screens/techniques/widgets/technique_filter_sheet.dart',
    ]) {
      final source = File(path).readAsStringSync();
      for (final forbidden in const [
        'Analyze My ',
        'Search technique...',
        'No techniques found',
        'Choose from Gallery',
        'I understand this is video-based analysis.',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: '$path: $forbidden');
      }
    }
  });
}

Map<String, dynamic> _arb(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
