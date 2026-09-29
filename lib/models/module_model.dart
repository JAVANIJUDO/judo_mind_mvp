import 'package:flutter/material.dart';

enum JudoMindPlatformSurface {
  athleteApp,
  coachWorkspace,
  clubFederationConsole,
  judoIntelligenceCore,
}

enum JudoMindModuleAvailability { available, unavailable, deferred }

enum JudoMindModuleReadiness {
  implemented,
  demoOnly,
  foundationOnly,
  notImplemented,
  deferred,
}

class ModuleModel {
  final String id;
  final String canonicalName;
  final String localizedDisplayKey;
  final Set<JudoMindPlatformSurface> surfaces;
  final IconData? icon;
  final String? route;
  final Color color;
  final JudoMindModuleAvailability availability;
  final JudoMindModuleReadiness readiness;
  final String? unavailableReason;
  final bool showOnAthleteHome;

  const ModuleModel({
    required this.id,
    required this.canonicalName,
    required this.localizedDisplayKey,
    required this.surfaces,
    this.icon,
    this.route,
    required this.color,
    required this.availability,
    required this.readiness,
    this.unavailableReason,
    this.showOnAthleteHome = false,
  }) : assert(id != ''),
       assert(canonicalName != ''),
       assert(localizedDisplayKey != ''),
       assert(
         availability == JudoMindModuleAvailability.available ||
             unavailableReason != null,
       ),
       assert(!showOnAthleteHome || icon != null);

  /// Compatibility alias for the existing module-card presentation.
  String get title => canonicalName;

  bool get isAvailable => availability == JudoMindModuleAvailability.available;

  bool get isReachable =>
      isAvailable && route != null && route!.trim().isNotEmpty;
}
