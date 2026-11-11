import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

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
    Locale('en'),
    Locale('ur'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SignCare AI'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your Voice. Our Care.'**
  String get tagline;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

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

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get navMessages;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeUser(String name);

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name} 👋'**
  String helloUser(String name);

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How can we help you today?'**
  String get homeSubtitle;

  /// No description provided for @menuCardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Communication Cards'**
  String get menuCardsTitle;

  /// No description provided for @menuCardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select cards to create a message'**
  String get menuCardsSubtitle;

  /// No description provided for @menuTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Type Message'**
  String get menuTypeTitle;

  /// No description provided for @menuTypeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write your message and speak it aloud'**
  String get menuTypeSubtitle;

  /// No description provided for @menuSymptomsTitle.
  ///
  /// In en, this message translates to:
  /// **'Symptoms & Pain'**
  String get menuSymptomsTitle;

  /// No description provided for @menuSymptomsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your symptoms and pain level'**
  String get menuSymptomsSubtitle;

  /// No description provided for @menuEmotionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Emotions & Feelings'**
  String get menuEmotionsTitle;

  /// No description provided for @menuEmotionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share how you feel'**
  String get menuEmotionsSubtitle;

  /// No description provided for @menuSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'My Summary'**
  String get menuSummaryTitle;

  /// No description provided for @menuSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review everything you selected and share it'**
  String get menuSummarySubtitle;

  /// No description provided for @menuEmergencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency Help'**
  String get menuEmergencyTitle;

  /// No description provided for @menuEmergencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Instant alert for urgent help'**
  String get menuEmergencySubtitle;

  /// No description provided for @menuSpeechTitle.
  ///
  /// In en, this message translates to:
  /// **'Speech to Text'**
  String get menuSpeechTitle;

  /// No description provided for @menuSpeechSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Turn spoken words into text'**
  String get menuSpeechSubtitle;

  /// No description provided for @menuBodyTitle.
  ///
  /// In en, this message translates to:
  /// **'Body Diagram'**
  String get menuBodyTitle;

  /// No description provided for @menuBodySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Point to where it hurts'**
  String get menuBodySubtitle;

  /// No description provided for @exitTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get exitTitle;

  /// No description provided for @exitMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit SignCare AI?'**
  String get exitMessage;

  /// No description provided for @exitAction.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitAction;

  /// No description provided for @setLanguageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get setLanguageSection;

  /// No description provided for @setAppearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get setAppearanceSection;

  /// No description provided for @setThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get setThemeSystem;

  /// No description provided for @setThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get setThemeLight;

  /// No description provided for @setThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get setThemeDark;

  /// No description provided for @setLayoutSection.
  ///
  /// In en, this message translates to:
  /// **'Home screen layout'**
  String get setLayoutSection;

  /// No description provided for @setLayoutList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get setLayoutList;

  /// No description provided for @setLayoutGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get setLayoutGrid;

  /// No description provided for @setAccountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get setAccountSection;

  /// No description provided for @setLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get setLogout;

  /// No description provided for @setLogoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out from this device'**
  String get setLogoutSubtitle;

  /// No description provided for @setLogoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get setLogoutConfirmTitle;

  /// No description provided for @setLogoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get setLogoutConfirmMessage;

  /// No description provided for @setDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account data'**
  String get setDeleteAccount;

  /// No description provided for @setDeleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove your account data from this device'**
  String get setDeleteSubtitle;

  /// No description provided for @setDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account data?'**
  String get setDeleteConfirmTitle;

  /// No description provided for @setDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'All your data on this device will be removed permanently. This cannot be undone.'**
  String get setDeleteConfirmMessage;

  /// No description provided for @setAboutSection.
  ///
  /// In en, this message translates to:
  /// **'About & support'**
  String get setAboutSection;

  /// No description provided for @setContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get setContactTitle;

  /// No description provided for @setContactMessage.
  ///
  /// In en, this message translates to:
  /// **'For bugs, feedback or support, write to us at:'**
  String get setContactMessage;

  /// No description provided for @setCopyEmail.
  ///
  /// In en, this message translates to:
  /// **'Copy email'**
  String get setCopyEmail;

  /// No description provided for @setEmailCopied.
  ///
  /// In en, this message translates to:
  /// **'Email copied'**
  String get setEmailCopied;

  /// No description provided for @setPortfolioTitle.
  ///
  /// In en, this message translates to:
  /// **'Developer portfolio'**
  String get setPortfolioTitle;

  /// No description provided for @setPortfolioMessage.
  ///
  /// In en, this message translates to:
  /// **'Open the developer website in your browser?'**
  String get setPortfolioMessage;

  /// No description provided for @setVisitWebsite.
  ///
  /// In en, this message translates to:
  /// **'Visit website'**
  String get setVisitWebsite;

  /// No description provided for @setVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get setVersion;

  /// No description provided for @setNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Important note'**
  String get setNoteTitle;

  /// No description provided for @setNoteBody.
  ///
  /// In en, this message translates to:
  /// **'SignCare AI helps you communicate. It does not give medical advice and does not replace a doctor or emergency services.'**
  String get setNoteBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
