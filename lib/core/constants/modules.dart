import 'package:flutter/material.dart';

import '../design_system/icons/judo_icons.dart';
import '../../models/module_model.dart';

class JudoMindModules {
  static const String _notImplemented =
      'No approved destination is implemented for this module yet.';

  /// The single authoritative registry for the 18 official product modules.
  /// Registration is not an availability grant: unfinished modules retain a
  /// null route and an explicit fail-closed reason.
  static const List<ModuleModel> modules = [
    ModuleModel(
      id: 'home',
      canonicalName: 'Home',
      localizedDisplayKey: 'moduleHomeTitle',
      surfaces: {JudoMindPlatformSurface.athleteApp},
      icon: JudoIcons.overview,
      route: '/home',
      color: Color(0xFF0066FF),
      availability: JudoMindModuleAvailability.available,
      readiness: JudoMindModuleReadiness.implemented,
    ),
    ModuleModel(
      id: 'techniques',
      canonicalName: 'Techniques — 67 Techniques',
      localizedDisplayKey: 'moduleTechniquesTitle',
      surfaces: {
        JudoMindPlatformSurface.athleteApp,
        JudoMindPlatformSurface.coachWorkspace,
        JudoMindPlatformSurface.judoIntelligenceCore,
      },
      icon: JudoIcons.throwTechnique,
      route: '/techniques',
      color: Color(0xFFD4AF37),
      availability: JudoMindModuleAvailability.available,
      readiness: JudoMindModuleReadiness.demoOnly,
      showOnAthleteHome: true,
    ),
    ModuleModel(
      id: 'sensi-bot',
      canonicalName: 'Sensi Bot',
      localizedDisplayKey: 'moduleSensiBotTitle',
      surfaces: {
        JudoMindPlatformSurface.athleteApp,
        JudoMindPlatformSurface.coachWorkspace,
        JudoMindPlatformSurface.judoIntelligenceCore,
      },
      icon: JudoIcons.aiCoach,
      color: Color(0xFF0066FF),
      availability: JudoMindModuleAvailability.unavailable,
      readiness: JudoMindModuleReadiness.foundationOnly,
      unavailableReason: _notImplemented,
    ),
    ModuleModel(
      id: 'sensi-bet',
      canonicalName: 'Sensi Bet',
      localizedDisplayKey: 'moduleSensiBetTitle',
      surfaces: {JudoMindPlatformSurface.athleteApp},
      icon: JudoIcons.prediction,
      color: Color(0xFFD4AF37),
      availability: JudoMindModuleAvailability.deferred,
      readiness: JudoMindModuleReadiness.deferred,
      unavailableReason:
          'Deferred pending legal, age, ethical and federation-brand review.',
    ),
    ModuleModel(
      id: 'monitoring-progress-mastery',
      canonicalName: 'Monitoring / Progress & Mastery',
      localizedDisplayKey: 'moduleMonitoringTitle',
      surfaces: {
        JudoMindPlatformSurface.athleteApp,
        JudoMindPlatformSurface.coachWorkspace,
        JudoMindPlatformSurface.clubFederationConsole,
        JudoMindPlatformSurface.judoIntelligenceCore,
      },
      icon: JudoIcons.mastery,
      route: '/progress-overview',
      color: Color(0xFF0066FF),
      availability: JudoMindModuleAvailability.available,
      readiness: JudoMindModuleReadiness.foundationOnly,
    ),
    ModuleModel(
      id: 'audiocast',
      canonicalName: 'AudioCast',
      localizedDisplayKey: 'moduleAudioCastTitle',
      surfaces: {JudoMindPlatformSurface.athleteApp},
      icon: JudoIcons.mediaLibrary,
      color: Color(0xFFD4AF37),
      availability: JudoMindModuleAvailability.unavailable,
      readiness: JudoMindModuleReadiness.notImplemented,
      unavailableReason: _notImplemented,
    ),
    ModuleModel(
      id: 'athlete-profile',
      canonicalName: 'Athlete Profile',
      localizedDisplayKey: 'moduleAthleteProfileTitle',
      surfaces: {
        JudoMindPlatformSurface.athleteApp,
        JudoMindPlatformSurface.coachWorkspace,
      },
      icon: JudoIcons.athlete,
      route: '/profile',
      color: Color(0xFF0066FF),
      availability: JudoMindModuleAvailability.available,
      readiness: JudoMindModuleReadiness.demoOnly,
      showOnAthleteHome: true,
    ),
    ModuleModel(
      id: 'training-center',
      canonicalName: 'Training Center',
      localizedDisplayKey: 'moduleTrainingCenterTitle',
      surfaces: {
        JudoMindPlatformSurface.athleteApp,
        JudoMindPlatformSurface.coachWorkspace,
        JudoMindPlatformSurface.judoIntelligenceCore,
      },
      icon: JudoIcons.training,
      color: Color(0xFFD4AF37),
      availability: JudoMindModuleAvailability.unavailable,
      readiness: JudoMindModuleReadiness.notImplemented,
      unavailableReason: _notImplemented,
    ),
    ModuleModel(
      id: 'champions-hub',
      canonicalName: 'Champions Hub',
      localizedDisplayKey: 'moduleChampionsHubTitle',
      surfaces: {
        JudoMindPlatformSurface.athleteApp,
        JudoMindPlatformSurface.coachWorkspace,
      },
      icon: JudoIcons.champions,
      color: Color(0xFF0066FF),
      availability: JudoMindModuleAvailability.unavailable,
      readiness: JudoMindModuleReadiness.notImplemented,
      unavailableReason: _notImplemented,
    ),
    ModuleModel(
      id: 'competitions-challenges',
      canonicalName: 'Competitions & Challenges',
      localizedDisplayKey: 'moduleCompetitionsTitle',
      surfaces: {
        JudoMindPlatformSurface.athleteApp,
        JudoMindPlatformSurface.coachWorkspace,
        JudoMindPlatformSurface.clubFederationConsole,
        JudoMindPlatformSurface.judoIntelligenceCore,
      },
      icon: JudoIcons.ippon,
      color: Color(0xFFD4AF37),
      availability: JudoMindModuleAvailability.unavailable,
      readiness: JudoMindModuleReadiness.notImplemented,
      unavailableReason: _notImplemented,
    ),
    ModuleModel(
      id: 'news',
      canonicalName: 'News',
      localizedDisplayKey: 'moduleNewsTitle',
      surfaces: {JudoMindPlatformSurface.athleteApp},
      icon: JudoIcons.sources,
      color: Color(0xFF0066FF),
      availability: JudoMindModuleAvailability.unavailable,
      readiness: JudoMindModuleReadiness.notImplemented,
      unavailableReason: _notImplemented,
    ),
    ModuleModel(
      id: 'store-subscriptions',
      canonicalName: 'Store & Subscriptions',
      localizedDisplayKey: 'moduleStoreSubscriptionsTitle',
      surfaces: {JudoMindPlatformSurface.athleteApp},
      icon: JudoIcons.training,
      color: Color(0xFFD4AF37),
      availability: JudoMindModuleAvailability.unavailable,
      readiness: JudoMindModuleReadiness.notImplemented,
      unavailableReason: _notImplemented,
    ),
    ModuleModel(
      id: 'club-administration',
      canonicalName: 'Club Administration',
      localizedDisplayKey: 'moduleClubAdministrationTitle',
      surfaces: {
        JudoMindPlatformSurface.clubFederationConsole,
        JudoMindPlatformSurface.judoIntelligenceCore,
      },
      icon: JudoIcons.club,
      route: '/club-administration',
      color: Color(0xFF0066FF),
      availability: JudoMindModuleAvailability.available,
      readiness: JudoMindModuleReadiness.foundationOnly,
    ),
    ModuleModel(
      id: 'coach-forum',
      canonicalName: 'Coach Forum',
      localizedDisplayKey: 'moduleCoachForumTitle',
      surfaces: {JudoMindPlatformSurface.coachWorkspace},
      icon: JudoIcons.coach,
      color: Color(0xFFD4AF37),
      availability: JudoMindModuleAvailability.unavailable,
      readiness: JudoMindModuleReadiness.notImplemented,
      unavailableReason: _notImplemented,
    ),
    ModuleModel(
      id: 'online-courses',
      canonicalName: 'Online Courses',
      localizedDisplayKey: 'moduleOnlineCoursesTitle',
      surfaces: {
        JudoMindPlatformSurface.athleteApp,
        JudoMindPlatformSurface.coachWorkspace,
      },
      icon: JudoIcons.quiz,
      color: Color(0xFF0066FF),
      availability: JudoMindModuleAvailability.unavailable,
      readiness: JudoMindModuleReadiness.notImplemented,
      unavailableReason: _notImplemented,
    ),
    ModuleModel(
      id: 'country-judo-history',
      canonicalName: 'Country Judo History',
      localizedDisplayKey: 'moduleCountryJudoHistoryTitle',
      surfaces: {
        JudoMindPlatformSurface.athleteApp,
        JudoMindPlatformSurface.clubFederationConsole,
      },
      icon: JudoIcons.sources,
      color: Color(0xFFD4AF37),
      availability: JudoMindModuleAvailability.unavailable,
      readiness: JudoMindModuleReadiness.notImplemented,
      unavailableReason: _notImplemented,
    ),
    ModuleModel(
      id: 'app-management-settings',
      canonicalName: 'App Management & Settings',
      localizedDisplayKey: 'moduleAppManagementSettingsTitle',
      surfaces: {
        JudoMindPlatformSurface.athleteApp,
        JudoMindPlatformSurface.clubFederationConsole,
      },
      icon: JudoIcons.overview,
      route: '/settings',
      color: Color(0xFF0066FF),
      availability: JudoMindModuleAvailability.available,
      readiness: JudoMindModuleReadiness.foundationOnly,
    ),
    ModuleModel(
      id: 'training-program-validator',
      canonicalName: 'Training Program Validator',
      localizedDisplayKey: 'moduleTrainingProgramValidatorTitle',
      surfaces: {
        JudoMindPlatformSurface.athleteApp,
        JudoMindPlatformSurface.coachWorkspace,
        JudoMindPlatformSurface.judoIntelligenceCore,
      },
      icon: JudoIcons.technicalAnalysis,
      color: Color(0xFFD4AF37),
      availability: JudoMindModuleAvailability.unavailable,
      readiness: JudoMindModuleReadiness.foundationOnly,
      unavailableReason: _notImplemented,
    ),
  ];

  static List<ModuleModel> get reachableModules =>
      List<ModuleModel>.unmodifiable(
        modules.where((module) => module.isReachable),
      );

  static List<ModuleModel> get athleteHomeModules =>
      List<ModuleModel>.unmodifiable(
        modules.where(
          (module) => module.showOnAthleteHome && module.isReachable,
        ),
      );

  static List<ModuleModel> get unavailableModules =>
      List<ModuleModel>.unmodifiable(
        modules.where((module) => !module.isAvailable),
      );
}
