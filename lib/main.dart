import 'core/theme/judo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/providers/favorite_provider.dart';
import 'core/providers/local_attempt_history_provider.dart';
import 'core/providers/local_athlete_profile_provider.dart';
import 'core/providers/local_club_administration_provider.dart';
import 'core/providers/local_exercise_library_provider.dart';
import 'core/dependency_injection/injection_container.dart';
import 'core/language/language_provider.dart';
import 'core/providers/technique_provider.dart';
import 'core/routes/app_routes.dart';
import 'l10n/app_localizations.dart';
import 'core/providers/recent_techniques_provider.dart';
import 'data/repositories/local_attempt_history_repository.dart';
import 'data/repositories/local_athlete_profile_repository.dart';
import 'data/repositories/local_club_administration_repository.dart';
import 'data/repositories/local_exercise_library_repository.dart';
import 'data/storage/user_preferences_storage.dart';
import 'data/storage/local_exercise_library_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageProvider>(
          create: (_) =>
              LanguageProvider(storage: sl<UserPreferencesStorage>())
                ..initialize(),
        ),

        ChangeNotifierProvider<TechniqueProvider>(
          create: (_) => TechniqueProvider(),
        ),

        ChangeNotifierProvider<FavoriteProvider>(
          create: (_) => FavoriteProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => RecentTechniquesProvider()..initialize(),
        ),
        ChangeNotifierProvider<LocalAttemptHistoryProvider>(
          create: (_) => LocalAttemptHistoryProvider(
            repository: sl<LocalAttemptHistoryRepository>(),
          )..initialize(),
        ),
        ChangeNotifierProvider<LocalAthleteProfileProvider>(
          create: (_) => LocalAthleteProfileProvider(
            repository: sl<LocalAthleteProfileRepository>(),
          )..initialize(),
        ),
        ChangeNotifierProvider<LocalClubAdministrationProvider>(
          create: (_) => LocalClubAdministrationProvider(
            repository: sl<ClubAdministrationRepository>(),
          )..initialize(),
        ),
        ChangeNotifierProvider<LocalExerciseLibraryProvider>(
          create: (_) => LocalExerciseLibraryProvider(
            repository: sl<ExerciseLibraryRepository>(),
            usageStorage: sl<LocalExerciseLibraryUsageStorage>(),
          )..initialize(),
        ),
      ],
      child: const JudoMindApp(),
    ),
  );
}

class JudoMindApp extends StatelessWidget {
  const JudoMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageProvider languageProvider = context.watch<LanguageProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Judo Mind',
      theme: JudoTheme.dark,
      darkTheme: JudoTheme.dark,
      themeMode: ThemeMode.dark,
      locale: Locale(languageProvider.languageCode),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
