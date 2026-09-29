// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get unavailableLabel => 'هنوز در دسترس نیست';

  @override
  String get moreTechniqueSections => 'بخش‌های بیشتر تکنیک';

  @override
  String get scientificDetailsTitle => 'جزئیات علمی';

  @override
  String get provenanceMeasured => 'اندازه‌گیری‌شده';

  @override
  String get provenanceReconstructed => 'بازسازی‌شده';

  @override
  String get provenanceModelEstimated => 'برآوردشده توسط مدل';

  @override
  String get provenanceAiInferred => 'استنباط‌شده با هوش مصنوعی';

  @override
  String get provenanceUnknown => 'نامشخص';

  @override
  String get insufficientEvidenceLabel => 'شواهد ناکافی';

  @override
  String get leftSide => 'چپ';

  @override
  String get rightSide => 'راست';

  @override
  String get toriRole => 'توری';

  @override
  String get ukeRole => 'اوکه';

  @override
  String get unassignedRole => 'تعیین‌نشده';

  @override
  String reviewedGateSummary(
    String trackId,
    int detectionIndex,
    String role,
    String supportSide,
    String attackingSide,
    int startMs,
    int endMs,
  ) {
    return '$trackId؛ تشخیص $detectionIndex؛ $role؛ پای اتکای $supportSide؛ پای حمله $attackingSide؛ از $startMs تا $endMs میلی‌ثانیه';
  }

  @override
  String get allCategories => 'همه';

  @override
  String get allLevels => 'همه سطح‌ها';

  @override
  String get techniqueSearchHint => 'جست‌وجوی تکنیک';

  @override
  String get noTechniquesFound => 'تکنیکی پیدا نشد';

  @override
  String officialTechniquesCount(int count) {
    return '$count تکنیک رسمی جودو';
  }

  @override
  String get ijfTechniqueDatabase => 'فهرست رسمی تکنیک‌های فدراسیون جهانی جودو';

  @override
  String get filtersTitle => 'فیلترها';

  @override
  String get eliteLevel => 'حرفه‌ای';

  @override
  String get sutemiWaza => 'سوتمی‌وازا (فنون فداشونده)';

  @override
  String get neWaza => 'نه‌وازا (فنون خاک)';

  @override
  String get tachiWaza => 'تاچی‌وازا (فنون ایستاده)';

  @override
  String get analyzeVideoDescription =>
      'یک ویدیوی تمرین یا مسابقه را برای بررسی آزمایشی وضعیت دوبعدی بدن انتخاب کنید. این مرحله هویت، فازهای حرکت یا بیومکانیک را تشخیص نمی‌دهد.';

  @override
  String get addTechniqueVideo => 'افزودن ویدیوی تکنیک';

  @override
  String get videoVisibilityGuidance =>
      'ویدیویی روشن انتخاب کنید که بدن هر دو جودوکار دیده شود.';

  @override
  String get chooseFromGallery => 'انتخاب از گالری';

  @override
  String get recordVideo => 'ضبط ویدیو';

  @override
  String get selectedVideo => 'ویدیوی انتخاب‌شده';

  @override
  String get captureFullBodiesGuidance =>
      'بدن کامل توری و اوکه در تصویر دیده شود.';

  @override
  String get captureStableLightGuidance =>
      'دوربین را ثابت نگه دارید و نور کافی فراهم کنید.';

  @override
  String get captureNoCrossingGuidance => 'کسی از جلوی دوربین عبور نکند.';

  @override
  String get captureViewGuidance =>
      'نمای جانبی یا ۴۵ درجه، مفصل‌ها را واضح‌تر نشان می‌دهد.';

  @override
  String get captureDurationGuidance => 'حداکثر زمان ویدیو ۳ دقیقه است.';

  @override
  String get cameraAngleLabel => 'زاویه دوربین';

  @override
  String get cameraSideView => 'نمای جانبی';

  @override
  String get cameraFrontView => 'نمای روبه‌رو';

  @override
  String get cameraRearView => 'نمای پشت';

  @override
  String get cameraFortyFiveView => 'نمای ۴۵ درجه';

  @override
  String get analysisNoticeTitle => 'می‌دانم که این تحلیل بر پایه ویدیو است.';

  @override
  String get analysisNoticeDescription =>
      'این مرحله فقط دیده‌شدن وضعیت دوبعدی بدن را بررسی می‌کند. هویت توری یا اوکه، فازهای حرکت، بازسازی سه‌بعدی، نیرو و گشتاور را گزارش نمی‌کند.';

  @override
  String get videoSelectionFailed => 'ویدیو انتخاب نشد.';

  @override
  String get analysisFailedUnexpectedly =>
      'تحلیل وضعیت بدن به‌صورت ایمن متوقف شد. دوباره تلاش کنید.';

  @override
  String videoSizeMegabytes(String size) {
    return '$size مگابایت';
  }

  @override
  String get sourceInternationalJudoFederation => 'فدراسیون جهانی جودو';

  @override
  String get sourceKodokanJudoInstitute => 'مؤسسه جودوی کودوکان';

  @override
  String get sourceEuropeanJudoUnion => 'اتحادیه جودوی اروپا';

  @override
  String get techniqueSectionUnavailable => 'این بخش تکنیک هنوز در دسترس نیست.';

  @override
  String get techniqueTrainingUnavailable =>
      'تمرین‌های اختصاصی اوچی‌ماتا هنوز آماده انتشار نیستند.';

  @override
  String get techniqueMasteryUnavailable =>
      'ثبت پیشرفت و تسلط اوچی‌ماتا هنوز در دسترس نیست.';

  @override
  String get techniqueChampionsUnavailable =>
      'منابع تأییدشده قهرمانان اوچی‌ماتا هنوز در دسترس نیست.';

  @override
  String get techniqueSensiBotUnavailable =>
      'مربی‌گری سنسی‌بات برای اوچی‌ماتا هنوز در دسترس نیست.';

  @override
  String get techniqueMediaItemUnavailable =>
      'هنوز منبع رسانه‌ای تأییدشده‌ای برای این مورد افزوده نشده است.';

  @override
  String get techniqueMediaOpenFailed => 'رسانه انتخاب‌شده باز نشد.';

  @override
  String get techniqueCompetitionVideoUnavailable =>
      'هنوز ویدئوی مستقیم و تأییدشده‌ای از مسابقه در دسترس نیست.';

  @override
  String get techniqueCompetitionVideoOpenFailed => 'ویدئوی مسابقه باز نشد.';

  @override
  String get submitAnswer => 'ثبت پاسخ';

  @override
  String get overview => 'نمای کلی';

  @override
  String get techniqueApplicationContext => 'زمینه کاربرد';

  @override
  String get techniqueGripAndStartingPosition => 'گرفتن و وضعیت شروع';

  @override
  String get techniqueExecutionPhases => 'مراحل اجرا';

  @override
  String get techniqueFollowThrough => 'ماکیکومی یا ادامه حرکت';

  @override
  String get techniqueVariations => 'گونه‌های اجرایی';

  @override
  String get techniqueVisualExplanation => 'توضیح تصویری';

  @override
  String get techniqueVideoExplanation => 'توضیح ویدئویی';

  @override
  String get techniqueTechnicalExplanation => 'توضیح فنی';

  @override
  String get techniqueConceptualMechanicalInterpretation =>
      'تفسیر مکانیکی مفهومی';

  @override
  String get techniqueBiomechanicalInterpretation => 'تفسیر بیومکانیکی';

  @override
  String get techniqueMeasuredBiomechanicalResult =>
      'نتیجه بیومکانیکی اندازه‌گیری‌شده';

  @override
  String get techniqueEvidenceReviewStatus => 'وضعیت منبع و بازبینی';

  @override
  String get techniqueStatementClassification => 'طبقه‌بندی گزاره';

  @override
  String get techniqueContentSource => 'منبع محتوا';

  @override
  String get techniqueSourceType => 'نوع منبع';

  @override
  String get techniqueProvenanceLicense => 'منشأ / مجوز';

  @override
  String get techniqueTechnicalReviewStatus => 'وضعیت بازبینی فنی';

  @override
  String get techniqueScientificReviewStatus => 'وضعیت بازبینی علمی';

  @override
  String get techniqueReviewerRole => 'نقش بازبین';

  @override
  String get techniqueLastReviewDate => 'تاریخ آخرین بازبینی';

  @override
  String get techniqueReviewNotReviewed => 'بازبینی نشده';

  @override
  String get techniqueReviewRequired => 'نیازمند بازبینی';

  @override
  String get techniqueReviewRecorded => 'بازبینی ثبت شده است';

  @override
  String get techniqueConceptualDiagramDisclaimer =>
      'این نمودار یک تفسیر آموزشی است. فلش‌ها جهت‌های مفهومی حرکت یا نیرو را نشان می‌دهند و بیانگر اندازه‌گیری مستقیم نیرو نیستند.';

  @override
  String get biomechanics => 'بیومکانیک';

  @override
  String get techniqueType => 'نوع تکنیک';

  @override
  String get beltLevel => 'سطح کمربند';

  @override
  String get approvedContentUnavailable =>
      'هنوز محتوای آموزشی گزینش‌شده‌ای برای این بخش در دسترس نیست.';

  @override
  String get classicalPhases => 'مراحل کلاسیک';

  @override
  String get kuzushi => 'کوزوشی';

  @override
  String get tsukuri => 'تسوکوری';

  @override
  String get kake => 'کاکه';

  @override
  String get additionalExecutionSteps => 'مراحل اجرایی تکمیلی';

  @override
  String get noAdditionalExecutionSteps =>
      'مرحله اجرایی تکمیلیِ تأییدشده‌ای در دسترس نیست.';

  @override
  String get approvedKeyPoints => 'نکات کلیدی تأییدشده';

  @override
  String get tacticalContentIncomplete =>
      'راهنمای تاکتیکی اختصاصی این تکنیک هنوز منبع تأییدشده ندارد.';

  @override
  String get competitionContentIncomplete =>
      'تحلیل اختصاصی مسابقه برای این تکنیک هنوز آماده نیست.';

  @override
  String get watchCompetitionExample => 'مشاهده نمونه مسابقه';

  @override
  String get officialSources => 'منابع رسمی';

  @override
  String get officialLabel => 'رسمی';

  @override
  String get verifiedLabel => 'تأییدشده';

  @override
  String get noApprovedSources =>
      'هیچ مرجع مستقیم و تأییدشده‌ای برای این تکنیک افزوده نشده است.';

  @override
  String get mistakesAndSafety => 'خطاها و ایمنی';

  @override
  String get safetyGuidance => 'راهنمای ایمنی';

  @override
  String get noCommonMistakes => 'هنوز خطای رایج تأییدشده‌ای ثبت نشده است.';

  @override
  String get noSafetyGuidance =>
      'هنوز راهنمای ایمنی تأییدشده‌ای افزوده نشده است.';

  @override
  String get noCombinations => 'هنوز ترکیب تأییدشده‌ای افزوده نشده است.';

  @override
  String get noCounters => 'هنوز ضدحمله تأییدشده‌ای افزوده نشده است.';

  @override
  String get techniqueQuiz => 'آزمون تکنیک';

  @override
  String get quizUnavailable =>
      'هیچ پرسش تأییدشده‌ای برای این تکنیک در دسترس نیست.';

  @override
  String get visualBiomechanics => 'بیومکانیک بصری';

  @override
  String get visualBiomechanicsDescription =>
      'برای بررسی نمایش حرکتی تأییدشده موجود در پروژه، از لایه‌های آموزشی استفاده کنید.';

  @override
  String get visualBiomechanicsUnavailable =>
      'توالی بصری بیومکانیکی تأییدشده‌ای برای این تکنیک در دسترس نیست.';

  @override
  String get educationalVisualizationLimitation =>
      'فقط نمایش آموزشی است؛ بیومکانیک سه‌بعدی اندازه‌گیری‌شده یا بازسازی‌شده نیست و نیرو، گشتاور، توان یا مرکز جرم واقعی را گزارش نمی‌کند.';

  @override
  String get blueLayer => 'لایه آبی';

  @override
  String get blueLayerDescription => 'حرکت پا، ورود و حرکت بدن';

  @override
  String get goldLayer => 'لایه طلایی';

  @override
  String get goldLayerDescription => 'گرفتن، کشش و کنترل زنجیره حرکتی';

  @override
  String get greenLayer => 'لایه سبز';

  @override
  String get greenLayerDescription => 'مفاهیم نمایشی جهت، تعادل و موقعیت بدن';

  @override
  String get visualPhaseGuidanceDescription =>
      'هر مرحله کلاسیک با یک نمایش برداری آموزشی همراه است و متن آن مستقیماً از محتوای ساختاریافته تکنیک می‌آید.';

  @override
  String get animationDisabledStaticFallback =>
      'حرکت نمایشی غیرفعال است. برای بررسی نمای ثابت، یک مرحله را انتخاب کنید.';

  @override
  String get educationalPracticeTitle => 'راهنمای آموزشی تمرین';

  @override
  String get educationalPracticeDescription =>
      'پیش از تمرین زیر نظر مربی، مراحل اجرا، نکات کلیدی، خطاهای رایج و راهنمای ایمنی تأییدشده را مرور کنید.';

  @override
  String get educationalPracticeLimitation =>
      'این بخش فقط راهنمای آموزشی است. زمان‌سنج، تعداد تکرار، برنامه آمادگی جسمانی و مربی‌گری شخصی در دسترس نیستند.';

  @override
  String get shadowTrainingTitle => 'تمرین سایه';

  @override
  String get strengthConditioningTitle => 'قدرت و آمادگی جسمانی';

  @override
  String get resistanceBandTrainingTitle => 'تمرین با کش مقاومتی';

  @override
  String get trainingExperienceUnavailable =>
      'تمرین اختصاصی این تکنیک هنوز در دسترس نیست';

  @override
  String get trainingExperienceUnavailableDescription =>
      'این تمرین پس از تأیید محتوا، راهنمای ایمنی و منبع تصویری منتشر می‌شود.';

  @override
  String get trainingObjectiveLabel => 'هدف';

  @override
  String get trainingRelatedPhaseLabel => 'مرحله مرتبط';

  @override
  String get trainingEquipmentLabel => 'تجهیزات';

  @override
  String get trainingAthleteLevelLabel => 'سطح ورزشکار';

  @override
  String get trainingPrescriptionLabel => 'نسخه تمرینی تأییدشده';

  @override
  String get trainingRestLabel => 'استراحت';

  @override
  String get trainingMediaLabel => 'مرجع رسانه تأییدشده';

  @override
  String get trainingSafetyLabel => 'راهنمای ایمنی';

  @override
  String get trainingSourceLabel => 'منبع';

  @override
  String get trainingProvenanceLabel => 'منشأ محتوا';

  @override
  String get shadowPhaseSequenceLabel => 'توالی مراحل';

  @override
  String get shadowMovementPathLabel => 'مسیر حرکت و ورود';

  @override
  String get shadowMirrorGhostLabel => 'نمای آینه‌ای / شبح';

  @override
  String get shadowFrontSideLabel => 'نمای روبه‌رو / جانبی';

  @override
  String get shadowPaceLabel => 'حالت‌های سرعت تأییدشده';

  @override
  String get shadowRepetitionTrackingLabel => 'ثبت تکرار';

  @override
  String get shadowHistoryBoundaryLabel => 'ثبت در تاریخچه';

  @override
  String get conditioningMovementPatternLabel => 'الگوی حرکتی هدف';

  @override
  String get conditioningCommonErrorLabel => 'خطای رایج اجرا';

  @override
  String get bandAnchorLabel => 'محل و ارتفاع مهار کش';

  @override
  String get bandDirectionLabel => 'جهت مقاومت / نیرو';

  @override
  String get bandGripMappingLabel => 'نگاشت گرفتن آستین / یقه';

  @override
  String get bandRotationPathLabel => 'مسیر ورود / چرخش';

  @override
  String get bandLegRolesLabel => 'نقش پای اتکا / پای حمله';

  @override
  String get bandSafeDistanceLabel => 'راهنمای فاصله ایمن';

  @override
  String get bandResistanceLevelLabel => 'سطح مقاومت تأییدشده';

  @override
  String get bandDangerWarningLabel => 'هشدار خطای خطرناک';

  @override
  String get trainingCapabilityEnabled =>
      'در محتوای آموزشی بازبینی‌شده موجود است';

  @override
  String get trainingCapabilityDisabled => 'تأیید نشده یا در دسترس نیست';

  @override
  String trainingSetsValue(int count) {
    return '$count ست';
  }

  @override
  String trainingRepetitionsValue(int count) {
    return '$count تکرار';
  }

  @override
  String trainingDurationValue(int seconds) {
    return '$seconds ثانیه';
  }

  @override
  String trainingRestValue(int seconds) {
    return '$seconds ثانیه';
  }

  @override
  String trainingSessionsValue(int count) {
    return '$count جلسه در هفته';
  }

  @override
  String get appName => 'جودو مایند';

  @override
  String get settings => 'تنظیمات';

  @override
  String get settingsLanguageSectionTitle => 'زبان';

  @override
  String get settingsLanguageDescription =>
      'زبان فعلی برنامه را انتخاب کنید. انتخاب بلافاصله اعمال می‌شود و به‌صورت محلی روی همین دستگاه می‌ماند.';

  @override
  String get settingsLanguageEnglish => 'انگلیسی';

  @override
  String get settingsLanguagePersian => 'فارسی';

  @override
  String get settingsLocalDataTitle => 'داده‌های روی دستگاه و حریم خصوصی';

  @override
  String get settingsLocalDataDescription =>
      'پروفایل و تحلیل‌هایی که خودتان ذخیره می‌کنید فقط روی همین دستگاه می‌مانند. همگام‌سازی ابری یا فدراسیونی هنوز فعال نیست.';

  @override
  String settingsStoredHistoryCount(int count) {
    return 'سوابق اعتبارسنجی محلی: $count';
  }

  @override
  String get settingsHistoryUnavailable =>
      'سابقه اعتبارسنجی محلی خوانده نشد. داده‌های موجود تغییر نکردند.';

  @override
  String get settingsHistoryEmpty =>
      'هنوز سابقه اعتبارسنجی محلی روی این دستگاه ذخیره نشده است.';

  @override
  String get settingsClearHistoryAction => 'پاک‌کردن سابقه اعتبارسنجی';

  @override
  String get settingsClearHistoryConfirmTitle =>
      'سابقه اعتبارسنجی محلی پاک شود؟';

  @override
  String get settingsClearHistoryConfirmDescription =>
      'فقط سوابق اعتبارسنجی محلی پاک می‌شوند. پروفایل، زبان و تنظیمات دیگر باقی می‌مانند.';

  @override
  String get settingsHistoryCleared => 'سابقه اعتبارسنجی محلی پاک شد.';

  @override
  String get settingsHistoryClearFailed =>
      'سابقه اعتبارسنجی محلی پاک نشد. داده‌های دیگر تغییر نکردند.';

  @override
  String get settingsScientificBoundaryTitle => 'اعتبار علمی و محدودیت‌ها';

  @override
  String settingsV2aSupportedBoundary(String metricIds) {
    return 'اعتبارسنجی V2A تک‌تلاش در حال حاضر فقط به معیارهای مهندسی $metricIds محدود است. این معیارها برای ارزیابی قطعی تکنیک، تأیید علمی نشده‌اند.';
  }

  @override
  String get settingsReviewRequiredBoundary =>
      'نتیجه‌ای که نیازمند بازبینی است، تا زمان تأیید بازبین انسانی واجد صلاحیت در وضعیت انتظار باقی می‌ماند.';

  @override
  String get settingsMultiPersonBoundary => 'شواهد چندنفره همچنان ناکافی است.';

  @override
  String get settingsInteractionBoundary =>
      'شاخص‌های تعاملی همچنان غیرقابل گزارش‌اند.';

  @override
  String get settingsUnavailableModulesBoundary =>
      'بخش‌های آماده‌نشده تا زمان تکمیل، بسته می‌مانند.';

  @override
  String get settingsApplicationInfoTitle => 'اطلاعات برنامه';

  @override
  String get settingsApplicationNameLabel => 'برنامه';

  @override
  String get settingsApplicationStatusLabel => 'وضعیت فعلی';

  @override
  String get settingsApplicationStatusLocalDemo => 'در حال تکمیل';

  @override
  String get settingsAvailableLanguagesLabel => 'زبان‌های در دسترس';

  @override
  String get settingsAvailableLanguagesValue => 'انگلیسی و فارسی';

  @override
  String get settingsStorageBoundaryLabel => 'ذخیره‌سازی و حریم خصوصی';

  @override
  String get settingsStorageBoundaryValue =>
      'داده پشتیبانی‌شده پروفایل و تاریخچه روی همین دستگاه می‌ماند؛ همگام‌سازی ابری یا فدراسیونی ادعا نمی‌شود.';

  @override
  String get cancel => 'لغو';

  @override
  String get filter => 'فیلتر';

  @override
  String get loading => 'در حال بارگذاری...';

  @override
  String get startTraining => 'شروع تمرین';

  @override
  String get techniques => 'تکنیک‌ها';

  @override
  String get techniqueDetails => 'جزئیات تکنیک';

  @override
  String get japaneseName => 'نام ژاپنی';

  @override
  String get classification => 'طبقه‌بندی';

  @override
  String get description => 'توضیحات';

  @override
  String get technicalAnalysis => 'تحلیل فنی';

  @override
  String get keyPoints => 'نکات کلیدی';

  @override
  String get commonMistakes => 'خطاهای رایج';

  @override
  String get safetyTips => 'نکات ایمنی';

  @override
  String get executionSteps => 'مراحل اجرا';

  @override
  String get combinations => 'ترکیب‌ها';

  @override
  String get counters => 'ضدحمله‌ها';

  @override
  String get difficulty => 'سطح دشواری';

  @override
  String get beginner => 'مبتدی';

  @override
  String get intermediate => 'متوسط';

  @override
  String get advanced => 'پیشرفته';

  @override
  String get belt => 'کمربند';

  @override
  String get category => 'دسته‌بندی';

  @override
  String get source => 'منبع';

  @override
  String get officialMedia => 'رسانه رسمی';

  @override
  String get videoLibrary => 'کتابخانه ویدیو';

  @override
  String get trainingVideo => 'ویدیوی آموزشی';

  @override
  String get competitionAnalysis => 'تحلیل مسابقه';

  @override
  String get quiz => 'آزمون';

  @override
  String get nextQuestion => 'پرسش بعدی';

  @override
  String get question => 'پرسش';

  @override
  String get yourScore => 'امتیاز شما';

  @override
  String get quizCompleted => 'آزمون تکمیل شد';

  @override
  String get retakeQuiz => 'تکرار آزمون';

  @override
  String get nageWaza => 'ناگه‌وازا (فنون پرتابی)';

  @override
  String get katameWaza => 'کاتامه‌وازا (فنون کنترل)';

  @override
  String get teWaza => 'ته‌وازا (فنون دست)';

  @override
  String get koshiWaza => 'کوشی‌وازا (فنون کمر)';

  @override
  String get ashiWaza => 'آشی‌وازا (فنون پا)';

  @override
  String get maSutemiWaza => 'ما-سوتمی‌وازا (فنون فداشونده به پشت)';

  @override
  String get yokoSutemiWaza => 'یوکو-سوتمی‌وازا (فنون فداشونده به پهلو)';

  @override
  String get osaekomiWaza => 'اوسائکومی‌وازا (فنون نگه‌داشتن)';

  @override
  String get shimeWaza => 'شیمه‌وازا (فنون خفه‌کردن)';

  @override
  String get kansetsuWaza => 'کانستسو‌وازا (فنون قفل مفصل)';

  @override
  String get champions => 'قهرمانان';

  @override
  String get ijfProfile => 'پروفایل IJF';

  @override
  String get competitionUsage => 'کاربرد در مسابقات';

  @override
  String get tacticalIntelligence => 'هوش تاکتیکی';

  @override
  String get gripStrategy => 'استراتژی گرفتن';

  @override
  String get bodyPosition => 'موقعیت بدن';

  @override
  String get tacticalNotes => 'نکات تاکتیکی';

  @override
  String get championsUsingTechnique => 'قهرمانان استفاده‌کننده از این تکنیک';

  @override
  String get favorite => 'علاقه‌مندی';

  @override
  String get training => 'تمرین';

  @override
  String get techniqueMastery => 'تسلط بر تکنیک';

  @override
  String get learningProgress => 'پیشرفت یادگیری';

  @override
  String get theory => 'تئوری';

  @override
  String get technique => 'تکنیک';

  @override
  String get competition => 'مسابقه';

  @override
  String get sensiBotRecommendation => 'پیشنهاد سنسی‌بات';

  @override
  String get singleCameraPoseSummaryTitle => 'خلاصه دیده‌شدن وضعیت بدن';

  @override
  String get experimentalPoseBaseline => 'بررسی آزمایشی وضعیت بدن';

  @override
  String get measuredVideoMetadataLabel => 'فراداده ویدئو · اندازه‌گیری‌شده';

  @override
  String get modelEstimatedPoseCoverageLabel =>
      'پوشش دیده‌شدن بدن · برآورد مدل';

  @override
  String get analyzedFramesLabel => 'فریم‌های بررسی‌شده';

  @override
  String get atLeastOnePoseLabel => 'دیده‌شدن حداقل یک نفر';

  @override
  String get twoPosesLabel => 'دیده‌شدن دو نفر';

  @override
  String get scientificConfidenceUnavailable =>
      'اطمینان علمی برای این نتیجه در دسترس نیست. نرخ پوشش، میزان اطمینان بیومکانیکی نیست.';

  @override
  String get scientificLimitationsTitle => 'محدودیت‌های علمی';

  @override
  String get poseIdentityNotAvailable =>
      'ترتیب افراد فقط مربوط به همان فریم است و هویت پایدار توری یا اوکه را مشخص نمی‌کند.';

  @override
  String get phaseDetectionNotAvailable =>
      'کوزوشی، تسوکوری و کاکه در این نسخه تشخیص داده نمی‌شوند.';

  @override
  String get singleCamera2dOnly =>
      'این نتیجه تک‌دوربین، سه‌بعدی اندازه‌گیری‌شده یا بازسازی‌شده نیست.';

  @override
  String get forceTorqueNotAvailable =>
      'هیچ نیروی واقعی، گشتاور واقعی یا بیومکانیک آزمایشگاهی گزارش نمی‌شود.';

  @override
  String get experimentalPoseLimitation =>
      'پوشش تشخیص وضعیت بدن از یک مدل آزمایشی می‌آید و امتیاز اطمینان علمی نیست.';

  @override
  String get runPoseAnalysis => 'بررسی پوز دوبعدی';

  @override
  String get poseAnalysisRunning => 'در حال بررسی دیده‌شدن پوز...';

  @override
  String get singleAttemptV2ATitle => 'تحلیل تک‌تلاش اوچی‌ماتا · سطح ۱';

  @override
  String get singleAttemptHumanReviewed =>
      'توری، پای اتکا، پای حمله و مرزهای رویداد · بازبینی انسانی';

  @override
  String get singleAttemptProjected2d =>
      'تصویر دوبعدی تک‌دوربین — نه بازسازی سه‌بعدی';

  @override
  String get metricStatusReportable => 'قابل گزارش';

  @override
  String get metricStatusReviewRequired => 'نیازمند بازبینی';

  @override
  String get metricStatusWithheld => 'گزارش‌نشده';

  @override
  String get metricConfidenceLabel => 'قابلیت مشاهده لندمارک مدل';

  @override
  String get metricConfidenceUnavailableLabel => 'شواهد اطمینان در دسترس نیست';

  @override
  String get blueOverlayTitle => 'لایه آبی هندسه';

  @override
  String get singleAttemptMultiPersonInsufficient =>
      'شواهد چندنفره کافی نیست. شاخص‌های تعاملی در دسترس نیستند و استنباط نمی‌شوند.';

  @override
  String get reviewedWorkflowTitle => 'تحلیل دستی و بازبینی‌شده تک‌تلاش';

  @override
  String get reviewedWorkflowDescription =>
      'رابط توسعه برای بازبین است. شواهد فریم منبع و انتخاب‌های تأییدشده انسانی را وارد کنید؛ هیچ‌یک از موارد زیر خودکار تشخیص داده نمی‌شود.';

  @override
  String get reviewedEventSchema => 'طرح‌واره رویداد';

  @override
  String get reviewedAttemptStartFrame => 'فریم شروع تلاش';

  @override
  String get reviewedAttemptStartTimestamp => 'زمان شروع تلاش (میلی‌ثانیه)';

  @override
  String get reviewedAttemptEndFrame => 'فریم پایان تلاش';

  @override
  String get reviewedAttemptEndTimestamp => 'زمان پایان تلاش (میلی‌ثانیه)';

  @override
  String get reviewedAngleFrame => 'فریم بازبینی‌شده زاویه';

  @override
  String get reviewedAngleTimestamp => 'زمان فریم زاویه (میلی‌ثانیه)';

  @override
  String get reviewedNeutralTrack => 'ترک خنثی تأییدشده انسانی (مثلاً Track A)';

  @override
  String get reviewedDetectionIndex => 'شماره تشخیص محلی در فریم';

  @override
  String get reviewedSupportLeg => 'پای اتکای تأییدشده انسانی';

  @override
  String get reviewedAttackingLeg => 'پای حمله تأییدشده انسانی';

  @override
  String get reviewedAngleEventLabel => 'برچسب رویداد فریم زاویه';

  @override
  String get reviewedProjectedViewSuitable =>
      'نما برای زاویه تصویری مناسب است؟';

  @override
  String get reviewedLowRoll => 'چرخش کم دوربین تأیید شده است؟';

  @override
  String get reviewedYes => 'بازبینی‌شده: بله';

  @override
  String get reviewedNo => 'بازبینی‌شده: خیر';

  @override
  String get reviewedInputRequired =>
      'همه فیلدهای الزامی بازبینی انسانی را کامل کنید.';

  @override
  String get reviewedNonNegativeInteger => 'یک عدد صحیح نامنفی وارد کنید.';

  @override
  String get reviewedNeutralTrackInvalid =>
      'از برچسب خنثی مانند Track A استفاده کنید؛ توری/اوکه هویت ترک نیستند.';

  @override
  String get reviewedInputSequenceInvalid =>
      'مرزهای بازبینی‌شده ناسازگارند. پایان باید پس از شروع و فریم زاویه داخل تلاش باشد.';

  @override
  String get reviewedHumanGateNotice =>
      'ترک انتخاب‌شده فقط برای همین رویداد بازبینی‌شده به‌عنوان توری تأیید می‌شود. هویت، فاز و انتخاب پا خودکار نیست.';

  @override
  String get runReviewedAnalysis => 'اجرای تحلیل بازبینی‌شده چهار شاخص';

  @override
  String get reviewedAnalysisRunning => 'در حال تحلیل فریم انتخابی...';

  @override
  String get reviewedAnalysisFailed =>
      'تحلیل تک‌تلاش بازبینی‌شده به‌صورت ایمن متوقف شد.';

  @override
  String get saveAttemptLocally => 'ذخیره محلی';

  @override
  String get savingAttemptLocally => 'در حال ذخیره محلی...';

  @override
  String get attemptSavedOnDevice => 'در این دستگاه ذخیره شد';

  @override
  String get attemptAlreadySaved => 'قبلاً ذخیره شده است';

  @override
  String get attemptSaveFailed => 'ذخیره محلی انجام نشد';

  @override
  String get localAttemptStorageDisclosure =>
      'فقط همین خلاصه مهندسی نسخه‌دارِ اعتبارسنجی در این دستگاه ذخیره می‌شود. ویدئو، مسیر فایل، نمای ترسیمی، امتیاز و داده پروفایل ذخیره نمی‌شوند.';

  @override
  String get athleteProfileTitle => 'پروفایل ورزشکار';

  @override
  String get localProfileDisclosureTitle => 'پروفایل محلی خوداظهاری';

  @override
  String get localProfileDisclosure =>
      'این پروفایل اختیاری فقط روی همین دستگاه ذخیره می‌شود و خوداظهاری است. این هویت تأییدشده، رتبه رسمی یا حساب ابری نیست.';

  @override
  String get selfReportedProfileTitle => 'مشخصات اختیاری';

  @override
  String get selfReportedProfileDescription =>
      'همه فیلدها اختیاری، محلی و خوداظهاری هستند.';

  @override
  String get profileDisplayName => 'نام نمایشی';

  @override
  String get profileBeltRank => 'رده کمربند';

  @override
  String get profileClub => 'باشگاه';

  @override
  String get profileCountry => 'کشور';

  @override
  String get profileBiography => 'معرفی کوتاه';

  @override
  String profileFieldTooLong(int maxLength) {
    return 'حداکثر از $maxLength نویسه استفاده کنید.';
  }

  @override
  String get saveLocalProfile => 'ذخیره پروفایل محلی';

  @override
  String get localProfileSaved => 'پروفایل محلی روی این دستگاه ذخیره شد.';

  @override
  String get localProfileSaveFailed => 'پروفایل محلی ذخیره نشد.';

  @override
  String get localProfileStorageError =>
      'داده پروفایل محلی نامعتبر یا دور از دسترس است. داده موجود بازنویسی نشد.';

  @override
  String get localAnalysisHistoryTitle => 'سابقه اعتبارسنجی محلی';

  @override
  String get localAnalysisHistoryDisclosure =>
      'فقط خلاصه‌های مهندسی نسخه‌دار V2A که صریحاً ذخیره شده‌اند فهرست می‌شوند. وضعیت، منشأ و محدودیت‌های اصلی حفظ می‌شوند و امتیاز عملکرد یا تسلط ساخته نمی‌شود.';

  @override
  String get localHistoryStorageError =>
      'داده تاریخچه محلی نامعتبر یا دور از دسترس است. داده موجود بازنویسی نشد.';

  @override
  String get localHistoryEmptyTitle =>
      'هنوز نتیجه اعتبارسنجی محلی ذخیره نشده است';

  @override
  String get localHistoryEmptyDescription =>
      'پس از ذخیره یک نتیجه بازبینی‌شده، می‌توانید آن را اینجا مرور کنید.';

  @override
  String get profileUnavailableFeaturesTitle => 'پیشرفت و تسلط در دسترس نیست';

  @override
  String get profileUnavailableFeaturesDescription =>
      'رتبه رسمی، افتخارات، تسلط، امتیاز عملکرد، روند و همگام‌سازی ابری در این برش نمایشی موجود نیست.';

  @override
  String savedLocalAnalysesCount(int count) {
    return 'نتایج اعتبارسنجی محلی ذخیره‌شده: $count';
  }

  @override
  String metricStatusCount(String status, int count) {
    return '$status: $count';
  }

  @override
  String savedLocallyAt(String date) {
    return 'زمان ذخیره محلی: $date';
  }

  @override
  String get analysisIdentifier => 'شناسه تحلیل';

  @override
  String get analysisModeLabel => 'حالت تحلیل';

  @override
  String get multiPersonEvidenceLabel => 'شواهد چندنفره';

  @override
  String get interactionMetricsLabel => 'شاخص‌های تعاملی';

  @override
  String get availableLabel => 'در دسترس';

  @override
  String get notAvailableLabel => 'هنوز در دسترس نیست';

  @override
  String get notReportableLabel => 'غیرقابل گزارش';

  @override
  String get unknownLabel => 'نامشخص';

  @override
  String get metricValueLabel => 'مقدار';

  @override
  String get metricStatusLabel => 'وضعیت';

  @override
  String get metricProvenanceLabel => 'منشأ داده';

  @override
  String get metricMethodVersionLabel => 'نسخه روش';

  @override
  String get metricConfidenceAvailabilityLabel => 'شواهد اطمینان';

  @override
  String get metricLimitationLabel => 'محدودیت';

  @override
  String get metricWithheldReasonLabel => 'دلیل گزارش‌نشدن';

  @override
  String get localStorageUnavailableTitle => 'ذخیره‌سازی محلی در دسترس نیست';

  @override
  String get retryLabel => 'تلاش دوباره';

  @override
  String get learningDashboardTitle => 'مسیرهای تکنیک';

  @override
  String get learningDashboardDescription =>
      'یاد بگیرید، تمرین کنید، تحلیل را ببینید، سابقه اعتبارسنجی محلی را مرور کنید و پس از تکمیل الزامات محصول و حریم خصوصی به مربی متصل شوید.';

  @override
  String get journeyLearnTitle => 'یادگیری';

  @override
  String get journeyLearnDescription =>
      'تکنیک را با محتوای آموزشی گزینش‌شده و تجربه‌های آموزشی متمایز درک کنید.';

  @override
  String get journeyTrainTitle => 'تمرین';

  @override
  String get journeyTrainDescription =>
      'فقط از تجربه‌های تمرینی اختصاصیِ در دسترس این تکنیک استفاده کنید.';

  @override
  String get journeyAnalyzeTitle => 'تحلیل';

  @override
  String get journeyAnalyzeDescription =>
      'تحلیل محدود ویدئو را اجرا کنید و توضیح مبتنی بر شواهد را ببینید.';

  @override
  String get journeyTrackProgressTitle => 'مرور تحلیل‌ها';

  @override
  String get journeyTrackProgressDescription =>
      'سابقه اعتبارسنجی محلی را بدون ساخت امتیاز یا ادعای تسلط مرور کنید.';

  @override
  String get journeyConnectCoachTitle => 'ارتباط با مربی';

  @override
  String get journeyConnectCoachDescription =>
      'ارتباط با مربی تا زمان تکمیل الزامات محصول و حریم خصوصی در دسترس نیست.';

  @override
  String get learnLabel => 'یادگیری';

  @override
  String get visualLabel => 'بصری';

  @override
  String get aiLabel => 'هوش مصنوعی';

  @override
  String get singleAttemptAnalysisTitle => 'تحلیل تک‌تلاش';

  @override
  String get groundedSenseiTitle => 'سنسِی مبتنی بر شواهد';

  @override
  String get coachConnectionTitle => 'ارتباط با مربی';

  @override
  String get coachConnectionUnavailable =>
      'ارتباط امن با مربی هنوز فعال نشده است.';

  @override
  String get mistakeReviewPointLabel => 'نکته نیازمند بازبینی';

  @override
  String get safetyGuidanceItemLabel => 'راهنمای ایمنی آموزشی گزینش‌شده';

  @override
  String get flowFromTechniqueLabel => 'گزینه‌های در دسترس مرتبط با';

  @override
  String get continueLearningTitle => 'ادامه مسیر تکنیک';

  @override
  String get continueLearningDescription =>
      'از محتوای آموزشی گزینش‌شده استفاده کنید، یک تلاش محدود را تحلیل کنید و سابقه اعتبارسنجی محلی را ببینید.';

  @override
  String get reviewedAnalysisBadge => 'ورودی‌های بررسی‌شده توسط انسان';

  @override
  String analyzeTechnique(String techniqueName) {
    return 'تحلیل $techniqueName';
  }

  @override
  String get addToFavorites => 'افزودن به علاقه‌مندی‌ها';

  @override
  String get removeFromFavorites => 'حذف از علاقه‌مندی‌ها';

  @override
  String get groundedSenseiDisclosure =>
      'توضیح قطعی و محلیِ نتیجه محدود V2A است که از ورودی‌های بررسی‌شده توسط انسان ساخته شده است. هوش مصنوعی مولدِ باز نیست و هیچ اندازه‌گیری، استنباط یا ارزیابی عملکرد تازه‌ای اضافه نمی‌کند.';

  @override
  String get groundedSenseiBindingLabel => 'اتصال محدود به منبع';

  @override
  String groundedSenseiBindingValue(
    String analysisId,
    String schemaVersion,
    String trackId,
  ) {
    return 'تحلیل $analysisId · طرح‌واره $schemaVersion · $trackId';
  }

  @override
  String get groundedSenseiFindingLabel => 'یافته';

  @override
  String get groundedSenseiEvidenceLabel => 'شواهد';

  @override
  String get groundedSenseiWhyLabel => 'چرایی اهمیت';

  @override
  String get groundedSenseiOverlayLabel => 'ارجاع به هم‌پوشانی آبی';

  @override
  String get groundedSenseiNextActionLabel => 'اقدام بعدی';

  @override
  String get groundedSenseiSafetyLabel => 'راهنمای ایمنی آموزشی گزینش‌شده';

  @override
  String get groundedSenseiLimitationsLabel => 'محدودیت‌های علمی الزام‌آور';

  @override
  String get groundedSenseiLocalVersionLabel => 'نسخه توضیح محلی';

  @override
  String get groundedSenseiMetricDuration => 'زمان سپری‌شده بازه انتخاب‌شده';

  @override
  String get groundedSenseiMetricTrunk => 'تمایل تصویری تنه';

  @override
  String get groundedSenseiMetricSupportKnee => 'زاویه تصویری زانوی پای اتکا';

  @override
  String get groundedSenseiMetricAttackingKnee => 'زاویه تصویری زانوی پای حمله';

  @override
  String get groundedSenseiWhyDuration =>
      'فقط زمان سپری‌شده در یک اجرای انتخاب و تأییدشده توسط بازبین انسانی را توصیف می‌کند؛ جودو مایند اجرا یا فازهای تکنیک را خودکار تشخیص نمی‌دهد.';

  @override
  String get groundedSenseiWhyTrunk =>
      'هندسه دوبعدی تنه را در فریم انتخاب‌شده توسط انسان توصیف می‌کند؛ زاویه دوربین بر تفسیر اثر دارد.';

  @override
  String get groundedSenseiWhySupportKnee =>
      'هندسه دوبعدی زانوی پای اتکا را در فریم انتخاب‌شده توسط انسان توصیف می‌کند؛ شاهد بار مفصل یا خطر آسیب نیست.';

  @override
  String get groundedSenseiWhyAttackingKnee =>
      'هندسه دوبعدی زانوی پای حمله را در فریم انتخاب‌شده توسط انسان توصیف می‌کند؛ شاهد حرکت سه‌بعدی نیست.';

  @override
  String groundedSenseiEvidenceValue(String value, String unit, String status) {
    return '$value $unit · وضعیت اصلی: $status';
  }

  @override
  String get groundedSenseiEvidenceWithheld =>
      'نتیجه محدود این مقدار را گزارش نکرده است. مقدار جایگزین تولید نمی‌شود.';

  @override
  String get groundedSenseiSecondsUnit => 'ثانیه';

  @override
  String get groundedSenseiDegreesUnit => 'درجه';

  @override
  String get groundedSenseiOverlayAvailable =>
      'در هندسه آبیِ نتیجه اصلی موجود است.';

  @override
  String get groundedSenseiOverlayUnavailable =>
      'در نتیجه محدود موجود نیست؛ هندسه‌ای ساخته نمی‌شود.';

  @override
  String get groundedSenseiNoApprovedDrill =>
      'هیچ نگاشت شاخص به تمرین تأیید نشده است؛ پیشنهاد تمرین در دسترس نیست.';

  @override
  String get groundedSenseiSafetyUnavailable =>
      'راهنمای ایمنی تأییدشده به زبان انتخابی در دسترس نیست.';

  @override
  String get groundedSenseiConfidenceAvailable =>
      'شواهد اطمینان نقاط کلیدیِ V2A اصلی حفظ شده است؛ امتیاز اطمینان تازه‌ای ساخته نمی‌شود.';

  @override
  String get groundedSenseiConfidenceUnavailable =>
      'شواهد اطمینان برای این شاخص در دسترس نیست؛ امتیاز اطمینان ساخته نمی‌شود.';

  @override
  String get groundedSenseiProvenanceMeasured => 'اندازه‌گیری‌شده';

  @override
  String get groundedSenseiProvenanceModelEstimated => 'برآوردشده توسط مدل';

  @override
  String get groundedSenseiLimitationHumanRole =>
      'نقش توری فقط از بازبینی انسانی آمده و استنباط نشده است.';

  @override
  String get groundedSenseiLimitationSupportLeg =>
      'پای اتکا فقط از بازبینی انسانی آمده و استنباط نشده است.';

  @override
  String get groundedSenseiLimitationPhase =>
      'فازهای تکنیک به‌طور خودکار تشخیص داده نمی‌شوند.';

  @override
  String get groundedSenseiLimitationProjected =>
      'یافته‌های زاویه‌ای دوبعدی و تصویریِ تک‌دوربین‌اند، نه بازسازی سه‌بعدی.';

  @override
  String get groundedSenseiLimitationPerspective =>
      'زاویه دید دوربین می‌تواند تفسیر زاویه تصویری را تغییر دهد.';

  @override
  String get groundedSenseiLimitationKinetics =>
      'نیرو، گشتاور، توان، ممان، بار و خروجی OpenSim در دسترس نیست.';

  @override
  String get groundedSenseiLimitationDescriptive =>
      'توضیح فقط توصیفی است و عملکرد یا میزان تسلط را طبقه‌بندی نمی‌کند.';

  @override
  String groundedSenseiLimitationOther(String code) {
    return 'نتیجه معتبر این محدودیت را حفظ می‌کند: $code';
  }

  @override
  String get groundedSenseiMultiPersonBoundary =>
      'شواهد چندنفره همچنان ناکافی است. یافته تعاملی در دسترس نیست و استنباط نمی‌شود.';

  @override
  String get groundedSenseiUnavailable =>
      'سنسِی مبتنی بر شواهد در دسترس نیست، زیرا اتصال ورودی‌های بررسی‌شده توسط انسان یا قرارداد محدود قابل تأیید نبود. نتیجه محدود اصلی همچنان در دسترس است.';

  @override
  String get homeHeroTitle => 'مسیر جودوی شما از اینجا آغاز می‌شود';

  @override
  String get homeHeroDescription =>
      'محتوای آموزشی گزینش‌شده تکنیک را بیاموزید، یک تلاش محدود با ورودی‌های بررسی‌شده توسط انسان را تحلیل کنید و نتایج اعتبارسنجی محلی را دوباره ببینید.';

  @override
  String get exploreTechniques => 'کاوش تکنیک‌ها';

  @override
  String get homeJourneysTitle => 'می‌خواهید چه کاری انجام دهید؟';

  @override
  String get homeJourneysDescription => 'مسیر موردنظر خود را انتخاب کنید.';

  @override
  String get homeJourneyLearnDescription =>
      'فهرست در دسترس ۶۷ تکنیک رسمی را با مرجع طلایی اوچی‌ماتا کاوش کنید.';

  @override
  String get homeJourneyTrainUnavailable =>
      'تمرین‌های اختصاصی تکنیک هنوز آماده انتشار نیستند.';

  @override
  String get homeJourneyAnalyzeDescription =>
      'گردش‌کار مهندسی محدود تک‌تلاش اوچی‌ماتا در نسخه‌های ۱ و ۲الف را با ورودی‌های بررسی‌شده توسط انسان باز کنید.';

  @override
  String get homeJourneyTrackProgressDescription =>
      'سابقه اعتبارسنجی محلی شامل خلاصه‌های مهندسی نسخه‌دار را بدون ساخت امتیاز پیشرفت باز کنید.';

  @override
  String get homeJourneyCoachUnavailable =>
      'ارتباط امن با مربی هنوز فعال نشده است.';

  @override
  String get continueSectionTitle => 'ادامه';

  @override
  String get continueUchiMata => 'ادامه یادگیری اوچی‌ماتا';

  @override
  String get reviewLocalAnalysisHistory => 'مرور سابقه اعتبارسنجی محلی';

  @override
  String get exploreAllCapabilities => 'مشاهده همه بخش‌ها';

  @override
  String get moduleDirectoryTitle => 'نمای کلی پلتفرم';

  @override
  String get moduleStatusAvailable => 'در دسترس';

  @override
  String get moduleStatusFoundationPartial => 'در حال تکمیل';

  @override
  String get moduleStatusUnavailableDeferred => 'هنوز در دسترس نیست';

  @override
  String get moduleNoApprovedDestination =>
      'این بخش‌ها هنوز آماده استفاده نیستند.';

  @override
  String get moduleSensiBetDeferredReason =>
      'تا بررسی حقوقی، سنی، اخلاقی و برند فدراسیون به تعویق افتاده است.';

  @override
  String get surfaceAthleteApp => 'اپ ورزشکار';

  @override
  String get surfaceCoachWorkspace => 'فضای کاری مربی';

  @override
  String get surfaceClubFederationConsole => 'کنسول باشگاه / فدراسیون';

  @override
  String get surfaceJudoIntelligenceCore => 'هسته هوشمندی جودو';

  @override
  String get moduleHomeTitle => 'خانه';

  @override
  String get moduleTechniquesTitle => 'تکنیک‌ها — ۶۷ تکنیک';

  @override
  String get moduleSensiBotTitle => 'سنسِی‌بات';

  @override
  String get moduleSensiBetTitle => 'سنسِی‌بِت';

  @override
  String get moduleMonitoringTitle => 'پایش / پیشرفت و تسلط';

  @override
  String get moduleAudioCastTitle => 'آدیوکست';

  @override
  String get moduleAthleteProfileTitle => 'پروفایل ورزشکار';

  @override
  String get moduleTrainingCenterTitle => 'مرکز تمرین';

  @override
  String get moduleChampionsHubTitle => 'مرکز قهرمانان';

  @override
  String get moduleCompetitionsTitle => 'مسابقات و چالش‌ها';

  @override
  String get moduleNewsTitle => 'اخبار';

  @override
  String get moduleStoreSubscriptionsTitle => 'فروشگاه و اشتراک‌ها';

  @override
  String get moduleClubAdministrationTitle => 'مدیریت باشگاه';

  @override
  String get moduleCoachForumTitle => 'انجمن مربیان';

  @override
  String get moduleOnlineCoursesTitle => 'دوره‌های آنلاین';

  @override
  String get moduleCountryJudoHistoryTitle => 'تاریخ جودوی کشورها';

  @override
  String get moduleAppManagementSettingsTitle => 'مدیریت برنامه و تنظیمات';

  @override
  String get moduleTrainingProgramValidatorTitle => 'اعتبارسنج برنامه تمرینی';

  @override
  String get viewLatestAnalysis => 'مشاهده آخرین تحلیل';

  @override
  String exploreReferenceTechnique(String techniqueName) {
    return 'کاوش $techniqueName';
  }

  @override
  String get homeAnalyzeUchiMataTitle => 'تحلیل اجرای اوچی‌ماتا';

  @override
  String get moduleDirectorySurfaceTitle => 'کاوش بر اساس پلتفرم';

  @override
  String get moduleDirectoryAllSurfaces => 'همه سطوح';

  @override
  String get moduleAvailableDestinationsTitle => 'اکنون در دسترس';

  @override
  String get moduleNoAvailableDestinationForSurface =>
      'هنوز مقصد آماده‌ای در این سطح در دسترس نیست.';

  @override
  String get moduleCurrentDestination => 'مقصد فعلی';

  @override
  String get moduleUnavailableDeferredTitle => 'به‌زودی';

  @override
  String moduleUnavailableDeferredSummary(int count) {
    return '$count بخش رسمی بعداً ارائه می‌شود';
  }

  @override
  String get progressOverviewTitle => 'مرور تحلیل‌ها';

  @override
  String get progressOverviewDisclosure =>
      'خلاصه تحلیل‌های ذخیره‌شده را ببینید. این صفحه امتیاز، رتبه یا میزان تسلط تولید نمی‌کند.';

  @override
  String get progressNoEvidenceTitle => 'هنوز تحلیلی برای مرور وجود ندارد';

  @override
  String get progressNoEvidenceDescription =>
      'ابتدا یک نتیجه بازبینی‌شده اوچی‌ماتا را ذخیره کنید.';

  @override
  String get progressInvalidEvidenceTitle => 'شواهد پیشرفت نمایش داده نمی‌شود';

  @override
  String get progressInvalidEvidenceDescription =>
      'داده ذخیره‌شده ناقص یا نامعتبر است؛ بنابراین شمارش و مقایسه نمایش داده نمی‌شود.';

  @override
  String get progressIncompatibleEvidenceTitle => 'نسخه‌های ناسازگار معیارها';

  @override
  String get progressIncompatibleEvidenceDescription =>
      'نسخه‌های ذخیره‌شده معیارها سازگار نیستند. جودو مایند آنها را مقایسه یا ترکیب نمی‌کند.';

  @override
  String get progressSavedAttempts => 'تلاش‌های ذخیره‌شده';

  @override
  String get progressCompletedRecords => 'رکوردهای تکمیل‌شده';

  @override
  String get progressLatestSaved => 'آخرین تحلیل ذخیره‌شده';

  @override
  String get progressMetricEvidenceTitle => 'وضعیت شواهد معیارها';

  @override
  String get progressTechniqueVersionTitle => 'بافت تکنیک و نسخه روش';

  @override
  String get progressTechniqueLabel => 'تکنیک';

  @override
  String get progressNoVersionComparison =>
      'نسخه‌ها فقط به‌عنوان بافت شواهد نمایش داده می‌شوند؛ مقدار معیارها مقایسه نمی‌شود و هیچ روندی استنباط نمی‌شود.';

  @override
  String get progressScientificBoundariesTitle => 'مرزهای علمی';

  @override
  String get progressReviewRequiredBoundary =>
      'UM-ANG-001 همچنان نیازمند بازبینی است و خودکار تأیید نمی‌شود.';

  @override
  String get progressMultiPersonBoundary => 'شواهد چندنفره همچنان ناکافی است.';

  @override
  String get progressInteractionBoundary =>
      'معیارهای تعامل همچنان قابل گزارش نیستند.';

  @override
  String get progressMasteryUnavailableTitle => 'تسلط در دسترس نیست';

  @override
  String get progressMasteryUnavailableDescription =>
      'سامانه علمیِ اعتبارسنجی‌شده برای تسلط، امتیاز، رتبه‌بندی، آمادگی یا سطح مهارت هنوز پیاده‌سازی نشده است.';

  @override
  String get progressOpenHistory => 'مشاهده سابقه اعتبارسنجی محلی';

  @override
  String get progressTimelineTitle => 'خط زمانی شواهد ذخیره‌شده';

  @override
  String get uchiMata => 'اوچی‌ماتا';

  @override
  String techniqueCatalogAvailabilitySummary(
    int availableCount,
    int roadmapCount,
  ) {
    return '$availableCount تکنیک اکنون در دسترس · نقشه راه $roadmapCount تکنیکی';
  }

  @override
  String techniqueCatalogPreviewSummary(int count) {
    return '$count پیش‌نمایش ناقص نمایش داده می‌شود اما قابل ورود نیست';
  }

  @override
  String get techniquePreviewUnavailable =>
      'فقط پیش‌نمایش · تجربه کامل هنوز در دسترس نیست';

  @override
  String get visualLayerMovement => 'حرکت';

  @override
  String get visualLayerControl => 'کنترل';

  @override
  String get visualLayerIllustrativeDirection => 'جهت نمایشی';

  @override
  String get uchiMataBiomechanicsVisualizationTitle => 'نمایش حرکتی اوچی‌ماتا';

  @override
  String get uchiMataBiomechanicsVisualizationDescription =>
      'حالت بدن، جهت نمایشی، تعادل و مفهوم جای‌گیری بدن را در طول پرتاب بررسی کنید.';

  @override
  String get educationalVisualizationNotMeasurement =>
      'نمایش آموزشی است؛ اندازه‌گیری نیست';

  @override
  String get sourceGeneralReferenceDisclosure =>
      'این موارد صفحه اصلی سازمان‌ها و منابع عمومی‌اند؛ نه شاهد مستقیم و اختصاصی این تکنیک.';

  @override
  String get clubAdministrationTitle => 'مدیریت باشگاه';

  @override
  String get clubLocalFoundationNotice =>
      'اطلاعات این بخش فعلاً فقط روی همین دستگاه ذخیره می‌شود. همگام‌سازی ابری، دسترسی چندکاربره و تأیید رسمی هنوز در دسترس نیست.';

  @override
  String get clubEmptyTitle => 'هنوز باشگاه محلی ندارید';

  @override
  String get clubEmptyDescription =>
      'یک باشگاه محلی بسازید تا ورزشکار فعلی، گروه تمرینی، جلسه‌ها و حضور و غیاب را فقط روی این دستگاه سامان دهید.';

  @override
  String get clubCreateAction => 'ثبت باشگاه';

  @override
  String get clubEditAction => 'ویرایش باشگاه';

  @override
  String get clubNameLabel => 'نام باشگاه';

  @override
  String get clubDescriptionLabel => 'توضیح اختیاری';

  @override
  String get clubSaveAction => 'ذخیره باشگاه';

  @override
  String get clubSaveFailed => 'باشگاه محلی ذخیره نشد.';

  @override
  String get clubStorageInvalidTitle => 'رکوردهای باشگاه در دسترس نیست';

  @override
  String get clubStorageInvalidDescription =>
      'داده ذخیره‌شده باشگاه نامعتبر یا ناسازگار است؛ معتبر در نظر گرفته یا بازنویسی نشد.';

  @override
  String get clubDashboardTitle => 'نمای کلی محلی';

  @override
  String clubMembersCount(String count) {
    return 'هنرجویان: $count';
  }

  @override
  String clubGroupsCount(String count) {
    return 'گروه‌ها: $count';
  }

  @override
  String clubSessionsCount(String count) {
    return 'جلسه‌ها: $count';
  }

  @override
  String clubAttendanceCount(String count) {
    return 'رکوردهای حضور و غیاب: $count';
  }

  @override
  String get clubRosterTitle => 'هنرجویان باشگاه';

  @override
  String get clubRosterEmpty =>
      'هیچ ورزشکاری به این باشگاه محلی پیوند نشده است.';

  @override
  String get clubLinkCurrentAthlete => 'افزودن پروفایل فعلی به باشگاه';

  @override
  String get clubCurrentAthleteFallback => 'ورزشکار محلی فعلی';

  @override
  String get clubCurrentAthleteLinked =>
      'به پروفایل ورزشکار فعلی پیوند شده است';

  @override
  String get clubMembershipNumberLabel => 'شماره عضویت اختیاری';

  @override
  String get clubAthleteLinkLimitation =>
      'این بنیاد فقط می‌تواند پروفایل ورزشکار محلی فعلی را پیوند دهد. افزودن ورزشکاران دیگر و هویت تأییدشده در دسترس نیست.';

  @override
  String get clubGroupsTitle => 'گروه‌های تمرینی';

  @override
  String get clubGroupEmpty => 'هنوز گروه تمرینی ساخته نشده است.';

  @override
  String get clubGroupCreateAction => 'افزودن گروه';

  @override
  String get clubGroupNameLabel => 'نام گروه';

  @override
  String get clubGroupDescriptionLabel => 'توضیح اختیاری گروه';

  @override
  String get clubGroupAssignCurrentAthlete => 'افزودن ورزشکار فعلی به این گروه';

  @override
  String clubGroupMemberCount(String count) {
    return 'اعضای گروه: $count';
  }

  @override
  String get clubSessionsTitle => 'جلسه‌های تمرینی';

  @override
  String get clubSessionEmpty => 'هنوز جلسه تمرینی ساخته نشده است.';

  @override
  String get clubSessionCreateAction => 'افزودن جلسه';

  @override
  String get clubSessionGroupLabel => 'گروه تمرینی';

  @override
  String get clubSessionScheduledLabel => 'زمان برنامه‌ریزی‌شده';

  @override
  String get clubSessionDurationLabel => 'مدت اختیاری به دقیقه';

  @override
  String clubSessionDurationValue(String count) {
    return '$count دقیقه';
  }

  @override
  String get clubAttendanceTitle => 'حضور و غیاب';

  @override
  String get clubAttendancePresent => 'حاضر';

  @override
  String get clubAttendanceAbsent => 'غایب';

  @override
  String get clubAttendanceExcused => 'غیبت موجه';

  @override
  String get clubAttendanceNotRecorded => 'ثبت نشده';

  @override
  String get clubOperationFailed => 'تغییر محلی ذخیره نشد.';

  @override
  String get clubRequiredField => 'تکمیل این فیلد الزامی است.';

  @override
  String get clubInvalidDuration => 'یک عدد صحیح از ۱ تا ۱۴۴۰ وارد کنید.';

  @override
  String get clubCreateGroupFirst =>
      'پیش از افزودن جلسه، یک گروه تمرینی بسازید.';

  @override
  String get clubSavedFeedback => 'تغییرات باشگاه روی این دستگاه ذخیره شد.';

  @override
  String get clubAthleteLinkedFeedback => 'پروفایل فعلی به باشگاه افزوده شد.';

  @override
  String get clubGroupSavedFeedback => 'گروه تمرینی ذخیره شد.';

  @override
  String get clubSessionSavedFeedback => 'برنامه جلسه ذخیره شد.';

  @override
  String get clubAttendanceSavedFeedback => 'حضور و غیاب ذخیره شد.';

  @override
  String get clubSessionEditAction => 'ویرایش برنامه جلسه';

  @override
  String get clubSessionTypeLabel => 'نوع جلسه';

  @override
  String get clubSessionTypeRequired => 'نوع جلسه را انتخاب کنید.';

  @override
  String get clubSessionTitleLabel => 'عنوان اختیاری جلسه';

  @override
  String get clubSessionObjectiveLabel => 'هدف اختیاری جلسه';

  @override
  String get clubSessionTypeJudoTechnical => 'تمرین فنی جودو';

  @override
  String get clubSessionTypeRandori => 'راندوری';

  @override
  String get clubSessionTypeTactical => 'تمرین تاکتیکی';

  @override
  String get clubSessionTypePhysicalPreparation => 'آمادگی جسمانی';

  @override
  String get clubSessionTypeRecovery => 'ریکاوری';

  @override
  String get clubSessionTypeAssessment => 'ارزیابی';

  @override
  String get clubSessionTypeMixed => 'ترکیبی';

  @override
  String get clubSessionTypeOther => 'سایر';

  @override
  String get clubSessionTypeUnspecifiedLegacy => 'نوع جلسه مشخص نشده';

  @override
  String get clubLegacySessionTypeNotice =>
      'نوع این جلسه قدیمی ثبت نشده است. برای ذخیره تغییرات، نوع جلسه را انتخاب کنید.';

  @override
  String get clubSessionItemsTitle => 'بخش‌های برنامه‌ریزی‌شده جلسه';

  @override
  String get clubSessionItemsEmpty =>
      'هیچ بخشی به برنامه جلسه افزوده نشده است.';

  @override
  String get clubSessionItemsOptional =>
      'بخش‌های برنامه اختیاری و نوشته مربی هستند و انجام‌شدن آنها توسط ورزشکار را تأیید نمی‌کنند.';

  @override
  String get clubSessionAddItemAction => 'افزودن بخش به برنامه';

  @override
  String get clubSessionEditItemAction => 'ویرایش بخش';

  @override
  String get clubSessionRemoveItemAction => 'حذف بخش';

  @override
  String get clubSessionMoveItemUp => 'انتقال بخش به بالا';

  @override
  String get clubSessionMoveItemDown => 'انتقال بخش به پایین';

  @override
  String get clubSessionItemTypeLabel => 'دسته فعالیت';

  @override
  String get clubSessionCustomTitleLabel => 'عنوان نوشته‌شده توسط مربی';

  @override
  String get clubSessionCoachAuthoredDisclosure =>
      'این مورد را مربی نوشته است و نسخه تمرینی تأییدشده از کتابخانه حرکات نیست.';

  @override
  String get clubSessionItemWarmUp => 'گرم‌کردن';

  @override
  String get clubSessionItemUkemi => 'اوکِمی';

  @override
  String get clubSessionItemTechnicalInstruction => 'آموزش فنی';

  @override
  String get clubSessionItemUchikomi => 'اوچی‌کومی';

  @override
  String get clubSessionItemNagekomi => 'ناگه‌کومی';

  @override
  String get clubSessionItemGripFighting => 'تمرین گارد و کومی‌کاتا';

  @override
  String get clubSessionItemTachiWaza => 'تاچی‌وازا';

  @override
  String get clubSessionItemNeWaza => 'نه‌وازا';

  @override
  String get clubSessionItemRandori => 'راندوری';

  @override
  String get clubSessionItemTacticalPractice => 'تمرین تاکتیکی';

  @override
  String get clubSessionItemCoolDown => 'سردکردن';

  @override
  String get clubSessionItemPhysicalConditioningCustom =>
      'فعالیت آمادگی جسمانی نوشته مربی';

  @override
  String get clubSessionItemCustomCoachAuthored => 'فعالیت دلخواه نوشته مربی';

  @override
  String get clubSessionDosageModeLabel => 'شیوه تعیین مقدار تمرین';

  @override
  String get clubSessionDosageDuration => 'مدت';

  @override
  String get clubSessionDosageRepetitions => 'تکرار';

  @override
  String get clubSessionDosageSetsRepetitions => 'ست × تکرار';

  @override
  String get clubSessionDosageRoundsDuration => 'راند × مدت';

  @override
  String get clubSessionDosageDistance => 'مسافت';

  @override
  String get clubSessionDosageDescriptive => 'توضیح دلخواه';

  @override
  String get clubSessionDurationMinutesField => 'مدت به دقیقه';

  @override
  String get clubSessionRepetitionsField => 'تعداد تکرار';

  @override
  String get clubSessionSetsField => 'تعداد ست';

  @override
  String get clubSessionRoundsField => 'تعداد راند';

  @override
  String get clubSessionRoundDurationField => 'دقیقه هر راند';

  @override
  String get clubSessionDistanceMetersField => 'مسافت به متر';

  @override
  String get clubSessionDosageDescriptionField => 'توضیح مقدار تمرین توسط مربی';

  @override
  String get clubSessionRestSecondsField => 'استراحت اختیاری به ثانیه';

  @override
  String get clubSessionCoachNotesField => 'یادداشت اختیاری مربی';

  @override
  String get clubSessionSaveItemAction => 'ذخیره بخش';

  @override
  String get clubSessionPositiveNumberError => 'یک عدد مثبت وارد کنید.';

  @override
  String get clubSessionNonNegativeNumberError =>
      'عدد صحیح صفر یا بیشتر وارد کنید.';

  @override
  String get clubSessionMeaningfulTextError =>
      'متن معناداری را به‌عنوان مربی وارد کنید.';

  @override
  String clubSessionDosageDurationValue(String value) {
    return '$value دقیقه';
  }

  @override
  String clubSessionDosageRepetitionsValue(String value) {
    return '$value تکرار';
  }

  @override
  String clubSessionDosageSetsValue(String sets, String repetitions) {
    return '$sets × $repetitions';
  }

  @override
  String clubSessionDosageRoundsValue(String rounds, String duration) {
    return '$rounds راند × $duration دقیقه';
  }

  @override
  String clubSessionDosageDistanceValue(String value) {
    return '$value متر';
  }

  @override
  String clubSessionRestValue(String value) {
    return 'استراحت: $value ثانیه';
  }

  @override
  String get clubSessionAddNextItemAction => 'افزودن بخش بعدی';

  @override
  String get clubSessionDuplicateItemAction => 'تکثیر بخش';

  @override
  String get clubSessionSavePlanAction => 'ذخیره برنامه جلسه';

  @override
  String get clubSessionItemIncomplete => 'مقدار تمرین ناقص است';

  @override
  String get clubSessionPlanItemValidationError =>
      'پیش از ذخیره، فیلدهای الزامی این بخش را تکمیل کنید.';

  @override
  String get clubSessionLiveSummaryTitle => 'خلاصه زنده برنامه';

  @override
  String clubSessionSummarySections(String count) {
    return 'بخش‌های برنامه‌ریزی‌شده: $count';
  }

  @override
  String clubSessionSummaryScheduledDuration(String value) {
    return 'مدت برنامه‌ریزی‌شده جلسه: $value دقیقه';
  }

  @override
  String get clubSessionSummaryTimeUnavailable =>
      'مدت برنامه‌ریزی‌شده جلسه: وارد نشده';

  @override
  String clubSessionSummaryCalculableTime(String value) {
    return 'زمان قابل‌محاسبه فعالیت‌ها: $value دقیقه';
  }

  @override
  String clubSessionSummaryCalculablePartial(String value) {
    return 'زمان قابل‌محاسبه فعالیت‌ها: $value دقیقه (بخشی از برنامه)';
  }

  @override
  String get clubSessionSummaryCalculableUnavailable =>
      'زمان قابل‌محاسبه فعالیت‌ها: در دسترس نیست';

  @override
  String get clubSessionUnsavedChangesTitle => 'تغییرات ذخیره‌نشده';

  @override
  String get clubSessionUnsavedChangesDescription =>
      'تغییرات ذخیره‌نشده برنامه جلسه کنار گذاشته شود؟';

  @override
  String get clubSessionDiscardChangesAction => 'کنار گذاشتن تغییرات';

  @override
  String get clubSessionContinueEditingAction => 'ادامه ویرایش';

  @override
  String get exerciseLibraryTitle => 'کتابخانه تمرین‌ها';

  @override
  String get exerciseLibraryOpenAction => 'باز کردن کتابخانه تمرین‌ها';

  @override
  String get exerciseLibraryDescription =>
      'برای برنامه‌ریزی جلسه‌های باشگاه، یک کتابخانه محلی و قابل‌استفاده دوباره بسازید.';

  @override
  String get exerciseLibraryStorageFailure =>
      'خواندن ایمن کتابخانه محلی تمرین‌ها ممکن نشد.';

  @override
  String get exerciseLibraryEmptyTitle => 'هنوز تمرین محلی ثبت نشده است';

  @override
  String get exerciseApprovedLibraryEmptyDisclosure =>
      'مخزن تمرین‌های تأییدشده خالی است. هیچ تمرینی بدون شواهد بازبینی، تأییدشده نمایش داده نمی‌شود.';

  @override
  String get exerciseFilteredEmpty => 'هیچ تمرینی با این فیلترها پیدا نشد.';

  @override
  String get exerciseSearchLabel => 'جست‌وجوی تمرین‌ها';

  @override
  String get exerciseCategoryFilterLabel => 'دسته فعالیت';

  @override
  String get exerciseSourceFilterLabel => 'منبع';

  @override
  String get exerciseReviewFilterLabel => 'وضعیت بازبینی';

  @override
  String get filterAll => 'همه';

  @override
  String get exerciseCreateAction => 'ساخت تمرین مربی';

  @override
  String get exerciseEditAction => 'ویرایش';

  @override
  String get exerciseArchiveAction => 'بایگانی';

  @override
  String get exerciseUnarchiveAction => 'بازیابی';

  @override
  String get exerciseArchived => 'بایگانی‌شده';

  @override
  String get exerciseApprovedBadge => 'مخزن تأییدشده';

  @override
  String get exerciseCoachAuthoredBadge => 'نوشته مربی';

  @override
  String get exerciseCoachAuthoredDisclosure =>
      'نوشته مربی — از نظر علمی بازبینی نشده';

  @override
  String get exerciseSavedFeedback => 'تمرین به‌صورت محلی ذخیره شد.';

  @override
  String get exerciseNameEn => 'نام انگلیسی';

  @override
  String get exerciseNameFa => 'نام فارسی';

  @override
  String get exerciseDescriptionEn => 'توضیح انگلیسی (اختیاری)';

  @override
  String get exerciseDescriptionFa => 'توضیح فارسی (اختیاری)';

  @override
  String get exerciseModalityLabel => 'شیوه تمرین';

  @override
  String get exerciseSupportedDosageModes =>
      'روش‌های دوز تمرین که مربی وارد می‌کند';

  @override
  String get exerciseReviewApproved => 'تأییدشده';

  @override
  String get exerciseReviewRequired => 'نیازمند بازبینی';

  @override
  String get exerciseReviewNotScientific => 'از نظر علمی بازبینی نشده';

  @override
  String get exerciseModalityFreeWeight => 'وزنه آزاد';

  @override
  String get exerciseModalityMachine => 'دستگاه';

  @override
  String get exerciseModalityBodyweight => 'وزن بدن';

  @override
  String get exerciseModalityConditioning => 'آمادگی جسمانی';

  @override
  String get exerciseModalityBand => 'کش مقاومتی';

  @override
  String get exerciseModalityShadow => 'تمرین سایه';

  @override
  String get exerciseModalityMobility => 'تحرک‌پذیری / بازیابی';

  @override
  String get exerciseModalityJudoDrill => 'تمرین اختصاصی جودو';

  @override
  String get exerciseModalityOther => 'سایر';

  @override
  String get exerciseSaveAction => 'ذخیره تمرین';

  @override
  String get exerciseChooseFromLibraryAction => 'انتخاب از کتابخانه تمرین‌ها';

  @override
  String get exerciseWriteManuallyAction => 'نوشتن دستی';

  @override
  String get exerciseLibrarySelectionTitle => 'انتخاب تمرین';

  @override
  String get exerciseLibrarySelectionEmpty =>
      'تمرین فعالی در دسترس نیست. ابتدا در کتابخانه تمرین‌ها یک مورد نوشته مربی بسازید.';

  @override
  String exerciseLinkedReference(String revision) {
    return 'پیوند به نمای ذخیره‌شده کتابخانه · ویرایش $revision';
  }

  @override
  String get exerciseImportCsvAction => 'واردکردن از CSV';

  @override
  String get exerciseMoreFilters => 'فیلترهای بیشتر';

  @override
  String get exerciseRecentTitle => 'انتخاب‌های اخیر';

  @override
  String get exerciseFavoritesTitle => 'برگزیده‌ها';

  @override
  String get exerciseResultsTitle => 'نتایج';

  @override
  String exerciseFavoritesFilter(String count) {
    return 'برگزیده‌ها ($count)';
  }

  @override
  String exerciseRecentFilter(String count) {
    return 'اخیر ($count)';
  }

  @override
  String get exerciseFavoritesEmpty =>
      'هنوز تمرینی به برگزیده‌ها افزوده نشده است.';

  @override
  String get exerciseRecentEmpty => 'هنوز تمرینی به‌تازگی انتخاب نشده است.';

  @override
  String get exerciseTranslationUnavailable =>
      'ترجمه در زبان انتخاب‌شده موجود نیست';

  @override
  String get exerciseAddFavorite => 'افزودن به برگزیده‌ها';

  @override
  String get exerciseRemoveFavorite => 'حذف از برگزیده‌ها';

  @override
  String get exerciseImportPreviewTitle => 'پیش‌نمایش واردکردن CSV';

  @override
  String exerciseImportTotal(String count) {
    return 'ردیف‌ها: $count';
  }

  @override
  String exerciseImportValid(String count) {
    return 'معتبر: $count';
  }

  @override
  String exerciseImportInvalid(String count) {
    return 'نامعتبر: $count';
  }

  @override
  String exerciseImportDuplicates(String count) {
    return 'تکراری: $count';
  }

  @override
  String exerciseImportFileError(String code) {
    return 'خطای فایل: $code';
  }

  @override
  String exerciseImportRowError(String row, String errors) {
    return 'ردیف $row: $errors';
  }

  @override
  String get exerciseImportConfirmAction => 'واردکردن ردیف‌های معتبر';

  @override
  String exerciseImportSaved(String count) {
    return '$count تمرین به‌صورت محلی وارد شد.';
  }

  @override
  String get exerciseImportIssueEmptyFile => 'فایل خالی است';

  @override
  String get exerciseImportIssueInvalidUtf8 =>
      'فایل با UTF-8 معتبر ذخیره نشده است';

  @override
  String get exerciseImportIssueMalformedCsv =>
      'ردیف یا نشانه‌گذاری CSV نامعتبر است';

  @override
  String get exerciseImportIssueHeader =>
      'سرستون استاندارد وجود ندارد یا تغییر کرده است';

  @override
  String get exerciseImportIssueSchema => 'نسخه ساختار پشتیبانی نمی‌شود';

  @override
  String get exerciseImportIssueMissingId => 'شناسه تمرین الزامی است';

  @override
  String get exerciseImportIssueDuplicateFile =>
      'شناسه تمرین در همین فایل تکراری است';

  @override
  String get exerciseImportIssueDuplicateStored =>
      'شناسه تمرین از قبل در دستگاه وجود دارد';

  @override
  String get exerciseImportIssueLocale => 'زبان نگارش باید en یا fa باشد';

  @override
  String get exerciseImportIssueName => 'نام تمرین در زبان نگارش الزامی است';

  @override
  String get exerciseImportIssueCategory => 'دسته فعالیت پشتیبانی نمی‌شود';

  @override
  String get exerciseImportIssueModality => 'شیوه تمرین پشتیبانی نمی‌شود';

  @override
  String get exerciseImportIssueDosage =>
      'روش تعیین مقدار تمرین نامعتبر یا خالی است';

  @override
  String get exerciseImportIssueUrl =>
      'نشانی منبع باید صفحه مستقیم HTTP(S) باشد';

  @override
  String get exerciseImportIssueMediaLicense =>
      'اظهار مجوز رسانه پشتیبانی نمی‌شود';

  @override
  String get exerciseImportIssueMediaDeclaration =>
      'رسانه به اظهار مالکیت یا مجوز نیاز دارد';

  @override
  String get exerciseImportIssueRecord =>
      'ردیف با قرارداد کتابخانه تمرین سازگار نیست';

  @override
  String get scientificTransparencyTitle => 'وضعیت علمی';

  @override
  String get scientificTransparencyStatusIconLabel => 'اطلاعات وضعیت علمی';

  @override
  String get scientificTransparencyHumanReviewPending =>
      'بازبینی انسانی در انتظار است';

  @override
  String get scientificTransparencyNoApproval =>
      'هنوز تأیید علمی صادر نشده است';

  @override
  String get scientificTransparencyVideoValidationOnly =>
      'تحلیل ویدئو: فقط در مرحله اعتبارسنجی';

  @override
  String get scientificTransparencySensitiveLocked =>
      'قابلیت‌های حساس: قفل هستند';

  @override
  String get scientificTransparencyNotReviewed =>
      'از نظر علمی بازبینی نشده است';

  @override
  String get scientificTransparencyViewDetails => 'مشاهده منابع و محدودیت‌ها';

  @override
  String get scientificTransparencyDetailsTitle => 'منابع و محدودیت‌ها';

  @override
  String get scientificTransparencyCurrentStatusSection => 'وضعیت علمی فعلی';

  @override
  String get scientificTransparencyCandidateCoverageSection =>
      'پوشش منابع نامزد';

  @override
  String get scientificTransparencyHumanReviewSection => 'وضعیت بازبینی انسانی';

  @override
  String get scientificTransparencyVideoLimitationsSection =>
      'محدودیت‌های تحلیل ویدئو';

  @override
  String get scientificTransparencySafetyBoundarySection => 'مرز ایمنی';

  @override
  String get scientificTransparencyDoesNotDoSection =>
      'این قابلیت چه کارهایی انجام نمی‌دهد';

  @override
  String get scientificTransparencyHumanReviewLabel => 'بازبینی انسانی';

  @override
  String get scientificTransparencyApprovalLabel => 'تأیید علمی';

  @override
  String get scientificTransparencyCandidateSource => 'منبع نامزد';

  @override
  String get scientificTransparencyReviewPending => 'در انتظار بازبینی';

  @override
  String get scientificTransparencyNotApprovedForClaim =>
      'هنوز برای پشتیبانی از ادعای Judo Mind تأیید نشده است';

  @override
  String get scientificTransparencyHumanReviewDescription =>
      'هر پنج منبع نامزد در انتظار بازبینی انسان واجد صلاحیت هستند. بازبینی هیچ منبعی کامل نشده است.';

  @override
  String get scientificTransparencyMissingDataLocked =>
      'داده حاکمیتی نمایش وجود ندارد یا نامعتبر است. این اطلاعات قفل و از نظر علمی بازبینی‌نشده باقی می‌ماند.';

  @override
  String get scientificTransparencyCapabilityPanelTitle => 'وضعیت قابلیت‌ها';

  @override
  String get scientificTransparencyStatusNotReviewed =>
      'از نظر علمی بازبینی نشده';

  @override
  String get scientificTransparencyStatusHumanReviewPending =>
      'بازبینی انسانی در انتظار';

  @override
  String get scientificTransparencyStatusReviewRequired => 'نیازمند بازبینی';

  @override
  String get scientificTransparencyStatusValidationOnly => 'فقط اعتبارسنجی';

  @override
  String get scientificTransparencyStatusLocked => 'قفل';

  @override
  String get scientificTransparencyStatusFullTextRequired =>
      'متن کامل لازم است';

  @override
  String get scientificTransparencyStatusMethodBlocked => 'روش مسدود است';

  @override
  String get scientificTransparencyStatusSourceMappingRequired =>
      'نگاشت منبع لازم است';

  @override
  String get scientificTransparencyStatusNotApplicable => 'قابل اعمال نیست';

  @override
  String get scientificTransparencySourceTypeConsensus => 'بیانیه اجماع';

  @override
  String get scientificTransparencySourceTypeSystematicReview =>
      'مرور نظام‌مند';

  @override
  String get scientificTransparencySourceTypeMetaAnalysis => 'فراتحلیل';

  @override
  String get scientificTransparencySourceTypeSystematicReviewMetaAnalysis =>
      'مرور نظام‌مند و فراتحلیل';

  @override
  String get scientificTransparencyAccessPublicFullText =>
      'متن کامل عمومی شناسایی شده است';

  @override
  String get scientificTransparencyAccessValidatedRepository =>
      'نسخه مخزن اعتبارسنجی‌شده';

  @override
  String get scientificTransparencyAccessAcceptedManuscript =>
      'دست‌نوشته پذیرفته‌شده و اعتبارسنجی‌شده';

  @override
  String get scientificTransparencyAccessPublisherVersion =>
      'نسخه ناشر اعتبارسنجی‌شده';

  @override
  String get scientificTransparencyCapabilityPoseSummary =>
      'خلاصه پوز تک‌دوربینه';

  @override
  String get scientificTransparencyCapabilityReviewedAttempt =>
      'یک اجرای بازبینی‌شده توسط انسان';

  @override
  String get scientificTransparencyCapabilityProjectedMetrics =>
      'شاخص‌های دوبعدی تصویرشده';

  @override
  String get scientificTransparencyCapabilityProjectedHipAngle =>
      'زاویه تصویرشده ران پای حمله';

  @override
  String get scientificTransparencyCapabilityAutomaticIdentity =>
      'تشخیص خودکار هویت ورزشکار';

  @override
  String get scientificTransparencyCapabilityAutomaticPhases =>
      'تشخیص خودکار مراحل کوزوشی، تسوکوری و کاکه';

  @override
  String get scientificTransparencyCapabilityThreeDimensional =>
      'بازسازی سه‌بعدی';

  @override
  String get scientificTransparencyCapabilityForceKinetics =>
      'نیرو و کینتیک از ویدئوی عادی';

  @override
  String get scientificTransparencyCapabilityTrainingPrescription =>
      'فعال‌سازی نسخه تمرینی';

  @override
  String get scientificTransparencyUnknownCapability =>
      'قابلیت حساس نگاشت‌نشده';

  @override
  String get scientificTransparencyLimitationEngineering =>
      'تخمین پوز فقط مشاهده‌های مهندسی ارائه می‌کند.';

  @override
  String get scientificTransparencyLimitationNoForce =>
      'این روش نیرو یا کینتیک را مستقیماً اندازه‌گیری نمی‌کند.';

  @override
  String get scientificTransparencyLimitationNoThreeDimensional =>
      'این روش به‌عنوان تحلیل قطعی بیومکانیک سه‌بعدی اعتبارسنجی نشده است.';

  @override
  String get scientificTransparencyLimitationNoDiagnosis =>
      'این روش خطای فنی یا آسیب را تشخیص پزشکی نمی‌دهد.';

  @override
  String get scientificTransparencyLimitationNoInjuryPrediction =>
      'این روش آسیب را پیش‌بینی نمی‌کند.';

  @override
  String get scientificTransparencyLimitationNoReferee =>
      'این روش تصمیم داوری صادر نمی‌کند.';

  @override
  String get scientificTransparencyLimitationAssociation =>
      'رابطه آماری نباید به‌عنوان رابطه علّی نمایش داده شود.';

  @override
  String get scientificTransparencyLimitationRisk =>
      'شاخص خطر نباید به‌عنوان پیش‌بینی قطعی نمایش داده شود.';

  @override
  String get scientificTransparencyLimitationMissingEvidence =>
      'نبود شواهد یا تأیید، قابلیت‌های حساس را قفل نگه می‌دارد.';

  @override
  String get scientificTransparencySafetyBoundaryDescription =>
      'این اطلاعات فقط آموزشی و خواندنی است و جای مربی، درمانگر، متخصص طب ورزشی یا داور واجد صلاحیت را نمی‌گیرد.';

  @override
  String get scientificTransparencyDoesNotDoDescription =>
      'این قابلیت عملکرد را امتیازدهی نمی‌کند، آسیب را تشخیص نمی‌دهد، نسخه تمرینی نمی‌سازد، نتیجه را پیش‌بینی نمی‌کند، تصمیم داوری نمی‌گیرد و قابلیت‌های علمی یا هوش مصنوعی قفل‌شده را فعال نمی‌کند.';

  @override
  String get guidedReviewTitle => 'بازبینی هدایت‌شده انسانی';

  @override
  String get guidedReviewDescription =>
      'فریم‌های دقیق رمزگشایی‌شده شروع و پایان و یک فریم بازبینی را انتخاب و بصری تأیید کنید. شماره تشخیص داخلی می‌ماند.';

  @override
  String get guidedAttemptStart => 'شروع تلاش';

  @override
  String get guidedAttemptEnd => 'پایان تلاش';

  @override
  String get guidedAttemptStartFrame => 'فریم شروع تلاش';

  @override
  String get guidedAttemptEndFrame => 'فریم پایان تلاش';

  @override
  String get guidedPreviousFrame => 'یک فریم عقب';

  @override
  String get guidedNextFrame => 'یک فریم جلو';

  @override
  String get guidedConfirmAttemptBoundaries =>
      'تأیید می‌کنم این فریم‌ها مرز تلاش موردنظر هستند';

  @override
  String get guidedSingleAttemptCaptureGuidance =>
      'برای بهترین نتیجه، ویدئوی شامل یک اجرای تکنیک بارگذاری کنید. اگر ویدئو چند اجرا دارد، برای هر تحلیل فقط یک اجرای پیوسته را انتخاب کنید.';

  @override
  String guidedConfirmSingleAttempt(String techniqueName) {
    return 'تأیید می‌کنم این بازه انتخاب‌شده فقط شامل یک اجرای پیوسته $techniqueName است.';
  }

  @override
  String get guidedBoundaryVisualReview =>
      'پیش از تأیید، فریم شروع و پایان را در پیش‌نمایش ویدئو بررسی کنید.';

  @override
  String get guidedSourceTiming => 'وضعیت زمان‌بندی منبع';

  @override
  String get guidedSourceRealTime => 'ویدئوی زمان واقعی';

  @override
  String get guidedSourceTimingUnknown => 'وضعیت زمان‌بندی نامشخص';

  @override
  String get guidedSourceTimingRequired =>
      'یک وضعیت زمان‌بندی پشتیبانی‌شده انتخاب کنید. ورود ضریب زمانی مشخص هنوز در این رابط محدود در دسترس نیست.';

  @override
  String get guidedLoadFrames => 'بارگذاری فریم‌های رمزگشایی‌شده';

  @override
  String guidedTimingEvidence(String mode, String provenance) {
    return 'حالت زمان‌بندی: $mode · $provenance';
  }

  @override
  String get guidedReviewMoment => 'لحظه بازبینی انتخاب‌شده توسط شما';

  @override
  String get guidedPrepareReview => 'آماده‌سازی بازبینی';

  @override
  String get guidedPreparing => 'در حال آماده‌سازی لحظه انتخابی...';

  @override
  String get guidedEditAttemptBoundaries => 'ویرایش مرزهای تلاش';

  @override
  String get guidedSelectTori => 'ورزشکار اجراکننده اوچی‌ماتا را انتخاب کنید';

  @override
  String get guidedToriBoundary =>
      'انتخاب ورزشکار را شما تأیید می‌کنید. جودو مایند هویت ورزشکار را خودکار تشخیص نداده است.';

  @override
  String get guidedFrameCandidateEvidenceBoundary =>
      'این موارد فقط کاندیداهای pose بازگشتی مدل در همین فریم هستند؛ نه شمارش افراد، نه هویت یا نقش، و نه شواهد رهگیری زمانی.';

  @override
  String get guidedCandidateEvidenceReady =>
      'دو کاندیدای فریمی قابل‌انتخاب برای انتخاب انسانی شما در دسترس است.';

  @override
  String guidedCandidateEvidenceInsufficient(
    int detectedCount,
    int selectableCount,
  ) {
    return 'شواهد کاندید برای تأیید انسانی نقش کافی نیست. از میان $detectedCount کاندیدای pose بازگشتی مدل، در این لحظه بازبینی فقط $selectableCount کاندیدای فریم قابل‌استفاده است. این به معنی حضور فقط یک نفر در تصویر نیست. برای ادامه، دو کاندیدای فریم مستقل لازم است.';
  }

  @override
  String guidedNoSelectableCandidateEvidence(int detectedCount) {
    return 'مدل در این فریم $detectedCount کاندیدای pose برگرداند، اما هیچ‌کدام شواهد pose قابل‌انتخاب ندارد. تحلیل مسدود می‌ماند.';
  }

  @override
  String guidedCandidatePoseEvidence(int availableCount, int requiredCount) {
    return 'لندمارک‌های دوبعدی لازم: $availableCount از $requiredCount موجود است (برآورد مدل).';
  }

  @override
  String guidedCandidateVisibilityAvailable(
    int availableCount,
    int requiredCount,
  ) {
    return 'visibility لندمارک مدل: $availableCount از $requiredCount موجود است؛ این دقت pose نیست.';
  }

  @override
  String guidedCandidateVisibilityPartial(
    int availableCount,
    int requiredCount,
  ) {
    return 'visibility لندمارک مدل ناقص است: $availableCount از $requiredCount؛ این دقت pose نیست.';
  }

  @override
  String get guidedCandidateVisibilityUnavailable =>
      'visibility لندمارک مدل موجود نیست؛ هیچ دقت یا confidence استنباط نمی‌شود.';

  @override
  String guidedCandidate(int number) {
    return 'کاندیدای فریم $number';
  }

  @override
  String get guidedConfirmTori =>
      'تأیید می‌کنم کاندیدای فریم انتخاب‌شده برای این تلاش، توری است';

  @override
  String get guidedNotSure => 'مطمئن نیستم';

  @override
  String get guidedNotSureAthlete =>
      'در این فریم نمی‌توانم ورزشکار را با اطمینان تشخیص دهم';

  @override
  String get guidedReviewBoundaryError =>
      'پایان را بعد از شروع بگذارید و لحظه بازبینی را داخل تلاش نگه دارید.';

  @override
  String get guidedReviewUncertainWithheld =>
      'بازبینی متوقف شد: همه انتخاب‌های انسانی الزامی را کامل کنید و فقط در صورت اطمینان ادامه دهید.';

  @override
  String get guidedReviewBackendError =>
      'بازبینی هدایت‌شده به‌صورت ایمن متوقف شد. در صورت مناسب‌بودن، آماده‌سازی را دوباره انجام دهید.';
}
