import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final english = _arb('lib/l10n/app_en.arb');
  final persian = _arb('lib/l10n/app_fa.arb');

  test('Settings uses validation-only scientific wording', () {
    expect(
      english['settingsV2aSupportedBoundary'],
      'Single-Attempt V2A validation is currently limited to the engineering '
      'metrics {metricIds}. These metrics are not scientifically approved for '
      'definitive technique assessment.',
    );
    expect(
      english['settingsReviewRequiredBoundary'],
      'A result requiring review remains pending until it is confirmed by a '
      'qualified human reviewer.',
    );
    expect(
      persian['settingsV2aSupportedBoundary'],
      'اعتبارسنجی V2A تک‌تلاش در حال حاضر فقط به معیارهای مهندسی '
      '{metricIds} محدود است. این معیارها برای ارزیابی قطعی تکنیک، تأیید علمی '
      'نشده‌اند.',
    );
    expect(
      persian['settingsReviewRequiredBoundary'],
      'نتیجه‌ای که نیازمند بازبینی است، تا زمان تأیید بازبین انسانی واجد '
      'صلاحیت در وضعیت انتظار باقی می‌ماند.',
    );
  });

  test('high-traffic product wording states exact non-scientific meaning', () {
    expect(
      english['homeJourneyLearnDescription'],
      contains('available 67-technique catalog'),
    );
    expect(
      english['homeJourneyAnalyzeDescription'],
      contains('engineering workflow with human-checked inputs'),
    );
    expect(
      english['homeJourneyTrackProgressDescription'],
      contains('local validation history'),
    );
    expect(
      english['localAttemptStorageDisclosure'],
      contains('engineering validation summary'),
    );
    expect(
      persian['homeJourneyAnalyzeDescription'],
      contains('گردش‌کار مهندسی محدود'),
    );
    expect(
      persian['homeJourneyTrackProgressDescription'],
      contains('سابقه اعتبارسنجی محلی'),
    );
  });

  test('misleading approval and raw enum wording is absent', () {
    final englishText = english.values.whereType<String>().join('\n');
    final persianText = persian.values.whereType<String>().join('\n');

    for (final forbidden in const [
      'approved Uchi Mata metrics',
      'approved 67-technique library',
      'approved content',
      'existing human-reviewed Single-Attempt Uchi Mata V1/V2A analysis',
      'saved, versioned scientific analysis history',
      'saved scientific history',
      'review_required',
    ]) {
      expect(
        englishText.toLowerCase(),
        isNot(contains(forbidden.toLowerCase())),
        reason: forbidden,
      );
    }

    for (final forbidden in const [
      'شاخص‌های تأییدشده اوچی‌ماتا',
      'محتوای تأییدشده',
      'تاریخچه علمی ذخیره‌شده',
      'خلاصه علمی نسخه‌دار',
      'review_required',
    ]) {
      expect(persianText, isNot(contains(forbidden)), reason: forbidden);
    }
  });
}

Map<String, dynamic> _arb(String path) {
  return jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
}
