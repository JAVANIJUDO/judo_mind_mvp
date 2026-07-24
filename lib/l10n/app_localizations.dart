import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('fa'),
    Locale('fr'),
    Locale('ja'),
    Locale('ru'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Judo Mind'**
  String get appName;

  /// No description provided for @appSlogan.
  ///
  /// In en, this message translates to:
  /// **'Train Smarter. Fight Stronger. Rise Higher.'**
  String get appSlogan;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @seeDetails.
  ///
  /// In en, this message translates to:
  /// **'See Details'**
  String get seeDetails;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @internetConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection'**
  String get internetConnectionError;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get tryAgain;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeJudoka.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Judoka'**
  String get welcomeJudoka;

  /// No description provided for @exploreJudoMind.
  ///
  /// In en, this message translates to:
  /// **'Explore Judo Mind'**
  String get exploreJudoMind;

  /// No description provided for @startTraining.
  ///
  /// In en, this message translates to:
  /// **'Start Training'**
  String get startTraining;

  /// No description provided for @continueTraining.
  ///
  /// In en, this message translates to:
  /// **'Continue Training'**
  String get continueTraining;

  /// No description provided for @dailyProgress.
  ///
  /// In en, this message translates to:
  /// **'Daily Progress'**
  String get dailyProgress;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @featuredContent.
  ///
  /// In en, this message translates to:
  /// **'Featured Content'**
  String get featuredContent;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @techniques.
  ///
  /// In en, this message translates to:
  /// **'Techniques'**
  String get techniques;

  /// No description provided for @sensiBot.
  ///
  /// In en, this message translates to:
  /// **'Sensi Bot'**
  String get sensiBot;

  /// No description provided for @sensiBet.
  ///
  /// In en, this message translates to:
  /// **'Sensi Bet'**
  String get sensiBet;

  /// No description provided for @monitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get monitoring;

  /// No description provided for @audioCast.
  ///
  /// In en, this message translates to:
  /// **'Judo Cast'**
  String get audioCast;

  /// No description provided for @athleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Athlete Profile'**
  String get athleteProfile;

  /// No description provided for @trainingCenter.
  ///
  /// In en, this message translates to:
  /// **'Training Center'**
  String get trainingCenter;

  /// No description provided for @championsHub.
  ///
  /// In en, this message translates to:
  /// **'Champions Hub'**
  String get championsHub;

  /// No description provided for @competitions.
  ///
  /// In en, this message translates to:
  /// **'Competitions'**
  String get competitions;

  /// No description provided for @challenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get challenges;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @clubAdmin.
  ///
  /// In en, this message translates to:
  /// **'Club Admin'**
  String get clubAdmin;

  /// No description provided for @coachForum.
  ///
  /// In en, this message translates to:
  /// **'Coach Forum'**
  String get coachForum;

  /// No description provided for @onlineCourses.
  ///
  /// In en, this message translates to:
  /// **'Online Courses'**
  String get onlineCourses;

  /// No description provided for @countryJudoHistory.
  ///
  /// In en, this message translates to:
  /// **'Country Judo History'**
  String get countryJudoHistory;

  /// No description provided for @techniqueDetails.
  ///
  /// In en, this message translates to:
  /// **'Technique Details'**
  String get techniqueDetails;

  /// No description provided for @judoTechnique.
  ///
  /// In en, this message translates to:
  /// **'Judo Technique'**
  String get judoTechnique;

  /// No description provided for @techniqueName.
  ///
  /// In en, this message translates to:
  /// **'Technique Name'**
  String get techniqueName;

  /// No description provided for @japaneseName.
  ///
  /// In en, this message translates to:
  /// **'Japanese Name'**
  String get japaneseName;

  /// No description provided for @classification.
  ///
  /// In en, this message translates to:
  /// **'Classification'**
  String get classification;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @technicalExplanation.
  ///
  /// In en, this message translates to:
  /// **'Technical Explanation'**
  String get technicalExplanation;

  /// No description provided for @technicalAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Technical Analysis'**
  String get technicalAnalysis;

  /// No description provided for @keyPoints.
  ///
  /// In en, this message translates to:
  /// **'Key Points'**
  String get keyPoints;

  /// No description provided for @commonMistakes.
  ///
  /// In en, this message translates to:
  /// **'Common Mistakes'**
  String get commonMistakes;

  /// No description provided for @safetyTips.
  ///
  /// In en, this message translates to:
  /// **'Safety Tips'**
  String get safetyTips;

  /// No description provided for @executionSteps.
  ///
  /// In en, this message translates to:
  /// **'Execution Steps'**
  String get executionSteps;

  /// No description provided for @setup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get setup;

  /// No description provided for @entry.
  ///
  /// In en, this message translates to:
  /// **'Entry'**
  String get entry;

  /// No description provided for @throwingPhase.
  ///
  /// In en, this message translates to:
  /// **'Throwing Phase'**
  String get throwingPhase;

  /// No description provided for @controlPhase.
  ///
  /// In en, this message translates to:
  /// **'Control Phase'**
  String get controlPhase;

  /// No description provided for @combinations.
  ///
  /// In en, this message translates to:
  /// **'Combinations'**
  String get combinations;

  /// No description provided for @counters.
  ///
  /// In en, this message translates to:
  /// **'Counters'**
  String get counters;

  /// No description provided for @variations.
  ///
  /// In en, this message translates to:
  /// **'Variations'**
  String get variations;

  /// No description provided for @prerequisites.
  ///
  /// In en, this message translates to:
  /// **'Prerequisites'**
  String get prerequisites;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @belt.
  ///
  /// In en, this message translates to:
  /// **'Belt'**
  String get belt;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @officialMedia.
  ///
  /// In en, this message translates to:
  /// **'Official Media'**
  String get officialMedia;

  /// No description provided for @videoLibrary.
  ///
  /// In en, this message translates to:
  /// **'Video Library'**
  String get videoLibrary;

  /// No description provided for @trainingVideo.
  ///
  /// In en, this message translates to:
  /// **'Training Video'**
  String get trainingVideo;

  /// No description provided for @competitionVideo.
  ///
  /// In en, this message translates to:
  /// **'Competition Video'**
  String get competitionVideo;

  /// No description provided for @competitionAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Competition Analysis'**
  String get competitionAnalysis;

  /// No description provided for @watchVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch Video'**
  String get watchVideo;

  /// No description provided for @openVideo.
  ///
  /// In en, this message translates to:
  /// **'Open Video'**
  String get openVideo;

  /// No description provided for @videoUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Video is currently unavailable'**
  String get videoUnavailable;

  /// No description provided for @quiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quiz;

  /// No description provided for @startQuiz.
  ///
  /// In en, this message translates to:
  /// **'Start Quiz'**
  String get startQuiz;

  /// No description provided for @nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get nextQuestion;

  /// No description provided for @previousQuestion.
  ///
  /// In en, this message translates to:
  /// **'Previous Question'**
  String get previousQuestion;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answer;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct Answer'**
  String get correctAnswer;

  /// No description provided for @wrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'Wrong Answer'**
  String get wrongAnswer;

  /// No description provided for @yourScore.
  ///
  /// In en, this message translates to:
  /// **'Your Score'**
  String get yourScore;

  /// No description provided for @quizCompleted.
  ///
  /// In en, this message translates to:
  /// **'Quiz Completed'**
  String get quizCompleted;

  /// No description provided for @retakeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Retake Quiz'**
  String get retakeQuiz;

  /// No description provided for @showResult.
  ///
  /// In en, this message translates to:
  /// **'Show Result'**
  String get showResult;

  /// No description provided for @nageWaza.
  ///
  /// In en, this message translates to:
  /// **'Nage-waza'**
  String get nageWaza;

  /// No description provided for @katameWaza.
  ///
  /// In en, this message translates to:
  /// **'Katame-waza'**
  String get katameWaza;

  /// No description provided for @teWaza.
  ///
  /// In en, this message translates to:
  /// **'Te-waza'**
  String get teWaza;

  /// No description provided for @koshiWaza.
  ///
  /// In en, this message translates to:
  /// **'Koshi-waza'**
  String get koshiWaza;

  /// No description provided for @ashiWaza.
  ///
  /// In en, this message translates to:
  /// **'Ashi-waza'**
  String get ashiWaza;

  /// No description provided for @maSutemiWaza.
  ///
  /// In en, this message translates to:
  /// **'Ma-sutemi-waza'**
  String get maSutemiWaza;

  /// No description provided for @yokoSutemiWaza.
  ///
  /// In en, this message translates to:
  /// **'Yoko-sutemi-waza'**
  String get yokoSutemiWaza;

  /// No description provided for @osaekomiWaza.
  ///
  /// In en, this message translates to:
  /// **'Osaekomi-waza'**
  String get osaekomiWaza;

  /// No description provided for @shimeWaza.
  ///
  /// In en, this message translates to:
  /// **'Shime-waza'**
  String get shimeWaza;

  /// No description provided for @kansetsuWaza.
  ///
  /// In en, this message translates to:
  /// **'Kansetsu-waza'**
  String get kansetsuWaza;

  /// No description provided for @rightSide.
  ///
  /// In en, this message translates to:
  /// **'Right Side'**
  String get rightSide;

  /// No description provided for @leftSide.
  ///
  /// In en, this message translates to:
  /// **'Left Side'**
  String get leftSide;

  /// No description provided for @forward.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get forward;

  /// No description provided for @backward.
  ///
  /// In en, this message translates to:
  /// **'Backward'**
  String get backward;

  /// No description provided for @aiCoach.
  ///
  /// In en, this message translates to:
  /// **'AI Coach'**
  String get aiCoach;

  /// No description provided for @chatWithSensi.
  ///
  /// In en, this message translates to:
  /// **'Chat with Sensi'**
  String get chatWithSensi;

  /// No description provided for @askQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a Question'**
  String get askQuestion;

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message'**
  String get typeYourMessage;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @newConversation.
  ///
  /// In en, this message translates to:
  /// **'New Conversation'**
  String get newConversation;

  /// No description provided for @conversationHistory.
  ///
  /// In en, this message translates to:
  /// **'Conversation History'**
  String get conversationHistory;

  /// No description provided for @recommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation'**
  String get recommendation;

  /// No description provided for @trainingRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Training Recommendation'**
  String get trainingRecommendation;

  /// No description provided for @techniqueRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Technique Recommendation'**
  String get techniqueRecommendation;

  /// No description provided for @personalizedAdvice.
  ///
  /// In en, this message translates to:
  /// **'Personalized Advice'**
  String get personalizedAdvice;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzing;

  /// No description provided for @sensiBotWelcome.
  ///
  /// In en, this message translates to:
  /// **'How can I help you improve your judo today?'**
  String get sensiBotWelcome;

  /// No description provided for @healthMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Health Monitoring'**
  String get healthMonitoring;

  /// No description provided for @sleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleep;

  /// No description provided for @sleepQuality.
  ///
  /// In en, this message translates to:
  /// **'Sleep Quality'**
  String get sleepQuality;

  /// No description provided for @sleepDuration.
  ///
  /// In en, this message translates to:
  /// **'Sleep Duration'**
  String get sleepDuration;

  /// No description provided for @nutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutrition;

  /// No description provided for @fatigue.
  ///
  /// In en, this message translates to:
  /// **'Fatigue'**
  String get fatigue;

  /// No description provided for @fatigueLevel.
  ///
  /// In en, this message translates to:
  /// **'Fatigue Level'**
  String get fatigueLevel;

  /// No description provided for @bodyMetrics.
  ///
  /// In en, this message translates to:
  /// **'Body Metrics'**
  String get bodyMetrics;

  /// No description provided for @heartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get heartRate;

  /// No description provided for @restingHeartRate.
  ///
  /// In en, this message translates to:
  /// **'Resting Heart Rate'**
  String get restingHeartRate;

  /// No description provided for @recovery.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get recovery;

  /// No description provided for @recoveryScore.
  ///
  /// In en, this message translates to:
  /// **'Recovery Score'**
  String get recoveryScore;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @mentalHealth.
  ///
  /// In en, this message translates to:
  /// **'Mental Health'**
  String get mentalHealth;

  /// No description provided for @stressLevel.
  ///
  /// In en, this message translates to:
  /// **'Stress Level'**
  String get stressLevel;

  /// No description provided for @mood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get mood;

  /// No description provided for @hydration.
  ///
  /// In en, this message translates to:
  /// **'Hydration'**
  String get hydration;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @bodyFat.
  ///
  /// In en, this message translates to:
  /// **'Body Fat'**
  String get bodyFat;

  /// No description provided for @muscleMass.
  ///
  /// In en, this message translates to:
  /// **'Muscle Mass'**
  String get muscleMass;

  /// No description provided for @recordData.
  ///
  /// In en, this message translates to:
  /// **'Record Data'**
  String get recordData;

  /// No description provided for @viewReport.
  ///
  /// In en, this message translates to:
  /// **'View Report'**
  String get viewReport;

  /// No description provided for @dailyReport.
  ///
  /// In en, this message translates to:
  /// **'Daily Report'**
  String get dailyReport;

  /// No description provided for @weeklyReport.
  ///
  /// In en, this message translates to:
  /// **'Weekly Report'**
  String get weeklyReport;

  /// No description provided for @monthlyReport.
  ///
  /// In en, this message translates to:
  /// **'Monthly Report'**
  String get monthlyReport;

  /// No description provided for @athleteInformation.
  ///
  /// In en, this message translates to:
  /// **'Athlete Information'**
  String get athleteInformation;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @club.
  ///
  /// In en, this message translates to:
  /// **'Club'**
  String get club;

  /// No description provided for @coach.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get coach;

  /// No description provided for @beltRank.
  ///
  /// In en, this message translates to:
  /// **'Belt Rank'**
  String get beltRank;

  /// No description provided for @weightCategory.
  ///
  /// In en, this message translates to:
  /// **'Weight Category'**
  String get weightCategory;

  /// No description provided for @ranking.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get ranking;

  /// No description provided for @worldRanking.
  ///
  /// In en, this message translates to:
  /// **'World Ranking'**
  String get worldRanking;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @medals.
  ///
  /// In en, this message translates to:
  /// **'Medals'**
  String get medals;

  /// No description provided for @goldMedals.
  ///
  /// In en, this message translates to:
  /// **'Gold Medals'**
  String get goldMedals;

  /// No description provided for @silverMedals.
  ///
  /// In en, this message translates to:
  /// **'Silver Medals'**
  String get silverMedals;

  /// No description provided for @bronzeMedals.
  ///
  /// In en, this message translates to:
  /// **'Bronze Medals'**
  String get bronzeMedals;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @matches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matches;

  /// No description provided for @wins.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get wins;

  /// No description provided for @losses.
  ///
  /// In en, this message translates to:
  /// **'Losses'**
  String get losses;

  /// No description provided for @winRate.
  ///
  /// In en, this message translates to:
  /// **'Win Rate'**
  String get winRate;

  /// No description provided for @trainingPrograms.
  ///
  /// In en, this message translates to:
  /// **'Training Programs'**
  String get trainingPrograms;

  /// No description provided for @physicalTraining.
  ///
  /// In en, this message translates to:
  /// **'Physical Training'**
  String get physicalTraining;

  /// No description provided for @technicalTraining.
  ///
  /// In en, this message translates to:
  /// **'Technical Training'**
  String get technicalTraining;

  /// No description provided for @tacticalTraining.
  ///
  /// In en, this message translates to:
  /// **'Tactical Training'**
  String get tacticalTraining;

  /// No description provided for @mentalTraining.
  ///
  /// In en, this message translates to:
  /// **'Mental Training'**
  String get mentalTraining;

  /// No description provided for @judoTheory.
  ///
  /// In en, this message translates to:
  /// **'Judo Theory'**
  String get judoTheory;

  /// No description provided for @judoRules.
  ///
  /// In en, this message translates to:
  /// **'Judo Rules'**
  String get judoRules;

  /// No description provided for @trainingPlan.
  ///
  /// In en, this message translates to:
  /// **'Training Plan'**
  String get trainingPlan;

  /// No description provided for @todayTraining.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Training'**
  String get todayTraining;

  /// No description provided for @trainingHistory.
  ///
  /// In en, this message translates to:
  /// **'Training History'**
  String get trainingHistory;

  /// No description provided for @trainingDuration.
  ///
  /// In en, this message translates to:
  /// **'Training Duration'**
  String get trainingDuration;

  /// No description provided for @trainingIntensity.
  ///
  /// In en, this message translates to:
  /// **'Training Intensity'**
  String get trainingIntensity;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @notStarted.
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get notStarted;

  /// No description provided for @champions.
  ///
  /// In en, this message translates to:
  /// **'Champions'**
  String get champions;

  /// No description provided for @worldChampions.
  ///
  /// In en, this message translates to:
  /// **'World Champions'**
  String get worldChampions;

  /// No description provided for @olympicChampions.
  ///
  /// In en, this message translates to:
  /// **'Olympic Champions'**
  String get olympicChampions;

  /// No description provided for @legendaryJudoka.
  ///
  /// In en, this message translates to:
  /// **'Legendary Judoka'**
  String get legendaryJudoka;

  /// No description provided for @championProfile.
  ///
  /// In en, this message translates to:
  /// **'Champion Profile'**
  String get championProfile;

  /// No description provided for @careerHighlights.
  ///
  /// In en, this message translates to:
  /// **'Career Highlights'**
  String get careerHighlights;

  /// No description provided for @biography.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get biography;

  /// No description provided for @upcomingCompetitions.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Competitions'**
  String get upcomingCompetitions;

  /// No description provided for @pastCompetitions.
  ///
  /// In en, this message translates to:
  /// **'Past Competitions'**
  String get pastCompetitions;

  /// No description provided for @competitionDetails.
  ///
  /// In en, this message translates to:
  /// **'Competition Details'**
  String get competitionDetails;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @registered.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get registered;

  /// No description provided for @registrationClosed.
  ///
  /// In en, this message translates to:
  /// **'Registration Closed'**
  String get registrationClosed;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// No description provided for @latestNews.
  ///
  /// In en, this message translates to:
  /// **'Latest News'**
  String get latestNews;

  /// No description provided for @featuredNews.
  ///
  /// In en, this message translates to:
  /// **'Featured News'**
  String get featuredNews;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// No description provided for @publishedAt.
  ///
  /// In en, this message translates to:
  /// **'Published At'**
  String get publishedAt;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @episodes.
  ///
  /// In en, this message translates to:
  /// **'Episodes'**
  String get episodes;

  /// No description provided for @latestEpisodes.
  ///
  /// In en, this message translates to:
  /// **'Latest Episodes'**
  String get latestEpisodes;

  /// No description provided for @podcasts.
  ///
  /// In en, this message translates to:
  /// **'Podcasts'**
  String get podcasts;

  /// No description provided for @nowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get nowPlaying;

  /// No description provided for @episodeDetails.
  ///
  /// In en, this message translates to:
  /// **'Episode Details'**
  String get episodeDetails;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @removeFromCart.
  ///
  /// In en, this message translates to:
  /// **'Remove from Cart'**
  String get removeFromCart;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get paymentSuccessful;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get paymentFailed;

  /// No description provided for @subscriptionPlans.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plans'**
  String get subscriptionPlans;

  /// No description provided for @basicPlan.
  ///
  /// In en, this message translates to:
  /// **'Basic Plan'**
  String get basicPlan;

  /// No description provided for @proPlan.
  ///
  /// In en, this message translates to:
  /// **'Pro Plan'**
  String get proPlan;

  /// No description provided for @elitePlan.
  ///
  /// In en, this message translates to:
  /// **'Elite Plan'**
  String get elitePlan;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @upgradePlan.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Plan'**
  String get upgradePlan;

  /// No description provided for @cancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get cancelSubscription;

  /// No description provided for @clubInformation.
  ///
  /// In en, this message translates to:
  /// **'Club Information'**
  String get clubInformation;

  /// No description provided for @clubMembers.
  ///
  /// In en, this message translates to:
  /// **'Club Members'**
  String get clubMembers;

  /// No description provided for @coaches.
  ///
  /// In en, this message translates to:
  /// **'Coaches'**
  String get coaches;

  /// No description provided for @athletes.
  ///
  /// In en, this message translates to:
  /// **'Athletes'**
  String get athletes;

  /// No description provided for @manageMembers.
  ///
  /// In en, this message translates to:
  /// **'Manage Members'**
  String get manageMembers;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @clubReports.
  ///
  /// In en, this message translates to:
  /// **'Club Reports'**
  String get clubReports;

  /// No description provided for @forum.
  ///
  /// In en, this message translates to:
  /// **'Forum'**
  String get forum;

  /// No description provided for @topics.
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get topics;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @createPost.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get createPost;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// No description provided for @courseDetails.
  ///
  /// In en, this message translates to:
  /// **'Course Details'**
  String get courseDetails;

  /// No description provided for @instructor.
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get instructor;

  /// No description provided for @lessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessons;

  /// No description provided for @enroll.
  ///
  /// In en, this message translates to:
  /// **'Enroll'**
  String get enroll;

  /// No description provided for @enrolled.
  ///
  /// In en, this message translates to:
  /// **'Enrolled'**
  String get enrolled;

  /// No description provided for @courseProgress.
  ///
  /// In en, this message translates to:
  /// **'Course Progress'**
  String get courseProgress;

  /// No description provided for @certificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get certificate;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @judoHistory.
  ///
  /// In en, this message translates to:
  /// **'Judo History'**
  String get judoHistory;

  /// No description provided for @importantEvents.
  ///
  /// In en, this message translates to:
  /// **'Important Events'**
  String get importantEvents;

  /// No description provided for @famousJudoka.
  ///
  /// In en, this message translates to:
  /// **'Famous Judoka'**
  String get famousJudoka;

  /// No description provided for @nationalFederation.
  ///
  /// In en, this message translates to:
  /// **'National Federation'**
  String get nationalFederation;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @persian.
  ///
  /// In en, this message translates to:
  /// **'Persian'**
  String get persian;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @japanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get japanese;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System Theme'**
  String get systemTheme;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'fa',
    'fr',
    'ja',
    'ru',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
