import 'package:flutter/material.dart';

import '../../screens/home/home_screen.dart';
import '../../screens/techniques/techniques_screen.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/profile/athlete_profile_screen.dart';
import '../../screens/profile/local_analysis_history_screen.dart';
import '../../screens/progress/progress_overview_screen.dart';
import '../../screens/club/club_administration_screen.dart';

class AppRoutes {
  static const String splash = "/";

  static const String home = "/home";

  static const String techniques = "/techniques";

  static const String settings = "/settings";

  static const String profile = "/profile";

  static const String localAnalysisHistory = "/local-analysis-history";

  static const String progressOverview = "/progress-overview";

  static const String clubAdministration = "/club-administration";

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),

    home: (context) => const HomeScreen(),

    techniques: (context) => const TechniquesScreen(),

    settings: (context) => const SettingsScreen(),

    profile: (context) => const AthleteProfileScreen(),

    localAnalysisHistory: (context) => const LocalAnalysisHistoryScreen(),

    progressOverview: (context) => const ProgressOverviewScreen(),

    clubAdministration: (context) => const ClubAdministrationScreen(),
  };
}
