import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/providers/favorite_provider.dart';
import 'core/dependency_injection/injection_container.dart';
import 'core/language/language_provider.dart';
import 'core/providers/technique_provider.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies();

  runApp(
    MultiProvider(
      providers: [
  ChangeNotifierProvider<LanguageProvider>(
    create: (_) => LanguageProvider(),
  ),

  ChangeNotifierProvider<TechniqueProvider>(
    create: (_) => TechniqueProvider(),
  ),

  ChangeNotifierProvider<FavoriteProvider>(
    create: (_) => FavoriteProvider()..initialize(),
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
    final LanguageProvider languageProvider =
        context.watch<LanguageProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Judo Mind',
      theme: AppTheme.darkTheme,
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