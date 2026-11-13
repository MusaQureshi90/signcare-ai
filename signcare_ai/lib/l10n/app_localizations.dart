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

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get profileTitle;

  /// No description provided for @profileEditHint.
  ///
  /// In en, this message translates to:
  /// **'Edit your name, date of birth and gender'**
  String get profileEditHint;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get profileName;

  /// No description provided for @profilePhoneNote.
  ///
  /// In en, this message translates to:
  /// **'Your phone number cannot be changed.'**
  String get profilePhoneNote;

  /// No description provided for @profileDob.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get profileDob;

  /// No description provided for @profileDobHint.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get profileDobHint;

  /// No description provided for @profileAge.
  ///
  /// In en, this message translates to:
  /// **'Age: {years}'**
  String profileAge(int years);

  /// No description provided for @profileGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileGender;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @profileGenderNote.
  ///
  /// In en, this message translates to:
  /// **'Your body diagram is shown based on this.'**
  String get profileGenderNote;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profileSave;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

  /// No description provided for @profileSavedLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Saved on this device. Could not reach the server.'**
  String get profileSavedLocalOnly;

  /// No description provided for @profileNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name (at least 2 letters).'**
  String get profileNameError;

  /// No description provided for @profileDobError.
  ///
  /// In en, this message translates to:
  /// **'Please select your date of birth.'**
  String get profileDobError;

  /// No description provided for @profileGenderError.
  ///
  /// In en, this message translates to:
  /// **'Please select your gender.'**
  String get profileGenderError;

  /// No description provided for @dobDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Select date of birth'**
  String get dobDialogTitle;

  /// No description provided for @dobYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get dobYear;

  /// No description provided for @dobMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get dobMonth;

  /// No description provided for @dobDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dobDay;

  /// No description provided for @dobConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get dobConfirm;

  /// No description provided for @typeTitle.
  ///
  /// In en, this message translates to:
  /// **'Type & Speak'**
  String get typeTitle;

  /// No description provided for @typeInstruction.
  ///
  /// In en, this message translates to:
  /// **'Type what you want to tell the doctor or helper:'**
  String get typeInstruction;

  /// No description provided for @typeHint.
  ///
  /// In en, this message translates to:
  /// **'Type your message here...'**
  String get typeHint;

  /// No description provided for @typeSpeak.
  ///
  /// In en, this message translates to:
  /// **'Speak aloud'**
  String get typeSpeak;

  /// No description provided for @typeStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get typeStop;

  /// No description provided for @typeAddToSummary.
  ///
  /// In en, this message translates to:
  /// **'Add to my summary'**
  String get typeAddToSummary;

  /// No description provided for @typeClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get typeClear;

  /// No description provided for @typeEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please type a message first.'**
  String get typeEmptyError;

  /// No description provided for @typeAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to your summary'**
  String get typeAdded;

  /// No description provided for @ttsVoiceMissingTitle.
  ///
  /// In en, this message translates to:
  /// **'Urdu voice not installed'**
  String get ttsVoiceMissingTitle;

  /// No description provided for @ttsVoiceMissingBody.
  ///
  /// In en, this message translates to:
  /// **'Your phone has no Urdu voice for text-to-speech. Open phone Settings, search for Text-to-speech output, choose Google Speech Services, and install the Urdu voice data. Then try again.'**
  String get ttsVoiceMissingBody;

  /// No description provided for @ttsError.
  ///
  /// In en, this message translates to:
  /// **'Could not speak right now. Please try again.'**
  String get ttsError;

  /// No description provided for @sumTitle.
  ///
  /// In en, this message translates to:
  /// **'My summary'**
  String get sumTitle;

  /// No description provided for @sumHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get sumHistory;

  /// No description provided for @sumEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing added yet'**
  String get sumEmptyTitle;

  /// No description provided for @sumEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Cards, symptoms, emotions and messages you add will appear here as one clear summary for the doctor.'**
  String get sumEmptyBody;

  /// No description provided for @sumReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Patient summary'**
  String get sumReportTitle;

  /// No description provided for @sumDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Patient-reported information. Not a diagnosis.'**
  String get sumDisclaimer;

  /// No description provided for @sumCreatedWith.
  ///
  /// In en, this message translates to:
  /// **'Created with SignCare AI'**
  String get sumCreatedWith;

  /// No description provided for @sumCreated.
  ///
  /// In en, this message translates to:
  /// **'Created {date}'**
  String sumCreated(String date);

  /// No description provided for @catCards.
  ///
  /// In en, this message translates to:
  /// **'Communication cards'**
  String get catCards;

  /// No description provided for @catTyped.
  ///
  /// In en, this message translates to:
  /// **'Typed messages'**
  String get catTyped;

  /// No description provided for @catSymptom.
  ///
  /// In en, this message translates to:
  /// **'Symptoms and pain'**
  String get catSymptom;

  /// No description provided for @catBody.
  ///
  /// In en, this message translates to:
  /// **'Body diagram'**
  String get catBody;

  /// No description provided for @catEmotion.
  ///
  /// In en, this message translates to:
  /// **'Emotions'**
  String get catEmotion;

  /// No description provided for @catEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get catEmergency;

  /// No description provided for @catSpeech.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get catSpeech;

  /// No description provided for @catNote.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get catNote;

  /// No description provided for @catOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catOther;

  /// No description provided for @sumShowMode.
  ///
  /// In en, this message translates to:
  /// **'Show to doctor'**
  String get sumShowMode;

  /// No description provided for @sumShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get sumShare;

  /// No description provided for @sumShareImage.
  ///
  /// In en, this message translates to:
  /// **'Share as image'**
  String get sumShareImage;

  /// No description provided for @sumShareText.
  ///
  /// In en, this message translates to:
  /// **'Share as text'**
  String get sumShareText;

  /// No description provided for @sumSaveHistory.
  ///
  /// In en, this message translates to:
  /// **'Save to history'**
  String get sumSaveHistory;

  /// No description provided for @sumSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to history'**
  String get sumSaved;

  /// No description provided for @sumClear.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get sumClear;

  /// No description provided for @sumClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear summary?'**
  String get sumClearTitle;

  /// No description provided for @sumClearBody.
  ///
  /// In en, this message translates to:
  /// **'All items in this summary will be removed.'**
  String get sumClearBody;

  /// No description provided for @sumAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get sumAddNote;

  /// No description provided for @sumNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Write a note for the doctor...'**
  String get sumNoteHint;

  /// No description provided for @sumShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not share right now. Please try again.'**
  String get sumShareFailed;

  /// No description provided for @sumHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved summaries'**
  String get sumHistoryTitle;

  /// No description provided for @sumHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved summaries yet. Tap Save to history on your summary.'**
  String get sumHistoryEmpty;

  /// No description provided for @sumHistoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String sumHistoryCount(int count);

  /// No description provided for @sumDeleteReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this summary?'**
  String get sumDeleteReportTitle;

  /// No description provided for @sumDeleteReportBody.
  ///
  /// In en, this message translates to:
  /// **'This saved summary will be removed from this device.'**
  String get sumDeleteReportBody;

  /// No description provided for @sumReadAloud.
  ///
  /// In en, this message translates to:
  /// **'Read aloud'**
  String get sumReadAloud;

  /// No description provided for @sumRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get sumRemoveItem;

  /// No description provided for @emTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency Help'**
  String get emTitle;

  /// No description provided for @emHelpButton.
  ///
  /// In en, this message translates to:
  /// **'I NEED HELP NOW'**
  String get emHelpButton;

  /// No description provided for @emHelpHint.
  ///
  /// In en, this message translates to:
  /// **'Flashes the screen and speaks for you'**
  String get emHelpHint;

  /// No description provided for @emContactsSection.
  ///
  /// In en, this message translates to:
  /// **'My emergency contacts'**
  String get emContactsSection;

  /// No description provided for @emAddContact.
  ///
  /// In en, this message translates to:
  /// **'Add contact'**
  String get emAddContact;

  /// No description provided for @emNoContacts.
  ///
  /// In en, this message translates to:
  /// **'No contacts yet. Add the people who should be called in an emergency.'**
  String get emNoContacts;

  /// No description provided for @emAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add emergency contact'**
  String get emAddTitle;

  /// No description provided for @emEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit contact'**
  String get emEditTitle;

  /// No description provided for @emContactName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get emContactName;

  /// No description provided for @emContactPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get emContactPhone;

  /// No description provided for @emContactRelation.
  ///
  /// In en, this message translates to:
  /// **'Relationship (optional)'**
  String get emContactRelation;

  /// No description provided for @emNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name.'**
  String get emNameError;

  /// No description provided for @emPhoneError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number.'**
  String get emPhoneError;

  /// No description provided for @emMaxContacts.
  ///
  /// In en, this message translates to:
  /// **'You can save up to 5 contacts.'**
  String get emMaxContacts;

  /// No description provided for @emCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get emCall;

  /// No description provided for @emSms.
  ///
  /// In en, this message translates to:
  /// **'Send SMS'**
  String get emSms;

  /// No description provided for @emEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get emEdit;

  /// No description provided for @emDeleteContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this contact?'**
  String get emDeleteContactTitle;

  /// No description provided for @emDeleteContactBody.
  ///
  /// In en, this message translates to:
  /// **'{name} will be removed from your emergency contacts.'**
  String emDeleteContactBody(String name);

  /// No description provided for @emNumbersSection.
  ///
  /// In en, this message translates to:
  /// **'Emergency numbers'**
  String get emNumbersSection;

  /// No description provided for @emRescue.
  ///
  /// In en, this message translates to:
  /// **'Rescue / Ambulance'**
  String get emRescue;

  /// No description provided for @emPolice.
  ///
  /// In en, this message translates to:
  /// **'Police'**
  String get emPolice;

  /// No description provided for @emFire.
  ///
  /// In en, this message translates to:
  /// **'Fire brigade'**
  String get emFire;

  /// No description provided for @emNumbersNote.
  ///
  /// In en, this message translates to:
  /// **'Numbers for Pakistan. Tap one to open the phone dialer.'**
  String get emNumbersNote;

  /// No description provided for @emPhrasesSection.
  ///
  /// In en, this message translates to:
  /// **'Say it quickly'**
  String get emPhrasesSection;

  /// No description provided for @emAddToSummary.
  ///
  /// In en, this message translates to:
  /// **'Add to summary'**
  String get emAddToSummary;

  /// No description provided for @emCallFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the phone dialer.'**
  String get emCallFailed;

  /// No description provided for @emSmsBody.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY: {name} needs urgent help. Please call or come immediately. Sent from SignCare AI.'**
  String emSmsBody(String name);

  /// No description provided for @emSmsBodyNoName.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY: I need urgent help. Please call or come immediately. Sent from SignCare AI.'**
  String get emSmsBodyNoName;

  /// No description provided for @emAlertHeadline.
  ///
  /// In en, this message translates to:
  /// **'I NEED URGENT HELP'**
  String get emAlertHeadline;

  /// No description provided for @emAlertSub.
  ///
  /// In en, this message translates to:
  /// **'I cannot speak. Please help me.'**
  String get emAlertSub;

  /// No description provided for @emAlertSubFemale.
  ///
  /// In en, this message translates to:
  /// **'I cannot speak. Please help me.'**
  String get emAlertSubFemale;

  /// No description provided for @emAlertSpeech.
  ///
  /// In en, this message translates to:
  /// **'I need urgent medical help. I cannot speak. Please help me.'**
  String get emAlertSpeech;

  /// No description provided for @emAlertSpeechFemale.
  ///
  /// In en, this message translates to:
  /// **'I need urgent medical help. I cannot speak. Please help me.'**
  String get emAlertSpeechFemale;

  /// No description provided for @emStopAlert.
  ///
  /// In en, this message translates to:
  /// **'Stop alert'**
  String get emStopAlert;

  /// No description provided for @emCallRescue.
  ///
  /// In en, this message translates to:
  /// **'Call 1122'**
  String get emCallRescue;

  /// No description provided for @emWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get emWhatsApp;

  /// No description provided for @emAppFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the app. Please check the number.'**
  String get emAppFailed;

  /// No description provided for @cardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Cards'**
  String get cardsTitle;

  /// No description provided for @cardsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search cards'**
  String get cardsSearchHint;

  /// No description provided for @cardsAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get cardsAll;

  /// No description provided for @cardsFavourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get cardsFavourites;

  /// No description provided for @cardsRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get cardsRecent;

  /// No description provided for @cardsMine.
  ///
  /// In en, this message translates to:
  /// **'My cards'**
  String get cardsMine;

  /// No description provided for @cardsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No cards here yet.'**
  String get cardsEmpty;

  /// No description provided for @cardsEmptyFav.
  ///
  /// In en, this message translates to:
  /// **'Tap the star on a card to save it here.'**
  String get cardsEmptyFav;

  /// No description provided for @cardsEmptyRecent.
  ///
  /// In en, this message translates to:
  /// **'Cards you use will appear here.'**
  String get cardsEmptyRecent;

  /// No description provided for @cardsEmptyMine.
  ///
  /// In en, this message translates to:
  /// **'Add your own cards with the + button.'**
  String get cardsEmptyMine;

  /// No description provided for @cardsNoResults.
  ///
  /// In en, this message translates to:
  /// **'No cards match your search.'**
  String get cardsNoResults;

  /// No description provided for @cardsAddOwn.
  ///
  /// In en, this message translates to:
  /// **'Add my own card'**
  String get cardsAddOwn;

  /// No description provided for @cardsNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New card'**
  String get cardsNewTitle;

  /// No description provided for @cardsTextLabel.
  ///
  /// In en, this message translates to:
  /// **'What should it say?'**
  String get cardsTextLabel;

  /// No description provided for @cardsTextError.
  ///
  /// In en, this message translates to:
  /// **'Please type something.'**
  String get cardsTextError;

  /// No description provided for @cardsPickEmoji.
  ///
  /// In en, this message translates to:
  /// **'Pick a picture'**
  String get cardsPickEmoji;

  /// No description provided for @cardsMaxCustom.
  ///
  /// In en, this message translates to:
  /// **'You can save up to 30 of your own cards.'**
  String get cardsMaxCustom;

  /// No description provided for @cardsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this card?'**
  String get cardsDeleteTitle;

  /// No description provided for @cardsHoldHint.
  ///
  /// In en, this message translates to:
  /// **'Press and hold one of your cards to delete it.'**
  String get cardsHoldHint;

  /// No description provided for @cardsSpeakOn.
  ///
  /// In en, this message translates to:
  /// **'Cards will speak when tapped.'**
  String get cardsSpeakOn;

  /// No description provided for @cardsSpeakOff.
  ///
  /// In en, this message translates to:
  /// **'Cards will stay silent when tapped.'**
  String get cardsSpeakOff;

  /// No description provided for @cardsSpeakTooltip.
  ///
  /// In en, this message translates to:
  /// **'Speak when tapped'**
  String get cardsSpeakTooltip;

  /// No description provided for @cardsAddSummary.
  ///
  /// In en, this message translates to:
  /// **'Add to summary'**
  String get cardsAddSummary;
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
