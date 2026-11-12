// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SignCare AI';

  @override
  String get tagline => 'Your Voice. Our Care.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get close => 'Close';

  @override
  String get retry => 'Try again';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get navHome => 'Home';

  @override
  String get navMessages => 'Messages';

  @override
  String get navProfile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name';
  }

  @override
  String helloUser(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get homeSubtitle => 'How can we help you today?';

  @override
  String get menuCardsTitle => 'Communication Cards';

  @override
  String get menuCardsSubtitle => 'Select cards to create a message';

  @override
  String get menuTypeTitle => 'Type Message';

  @override
  String get menuTypeSubtitle => 'Write your message and speak it aloud';

  @override
  String get menuSymptomsTitle => 'Symptoms & Pain';

  @override
  String get menuSymptomsSubtitle =>
      'Tell us about your symptoms and pain level';

  @override
  String get menuEmotionsTitle => 'Emotions & Feelings';

  @override
  String get menuEmotionsSubtitle => 'Share how you feel';

  @override
  String get menuSummaryTitle => 'My Summary';

  @override
  String get menuSummarySubtitle =>
      'Review everything you selected and share it';

  @override
  String get menuEmergencyTitle => 'Emergency Help';

  @override
  String get menuEmergencySubtitle => 'Instant alert for urgent help';

  @override
  String get menuSpeechTitle => 'Speech to Text';

  @override
  String get menuSpeechSubtitle => 'Turn spoken words into text';

  @override
  String get menuBodyTitle => 'Body Diagram';

  @override
  String get menuBodySubtitle => 'Point to where it hurts';

  @override
  String get exitTitle => 'Exit App';

  @override
  String get exitMessage => 'Are you sure you want to exit SignCare AI?';

  @override
  String get exitAction => 'Exit';

  @override
  String get setLanguageSection => 'Language';

  @override
  String get setAppearanceSection => 'Appearance';

  @override
  String get setThemeSystem => 'Follow system';

  @override
  String get setThemeLight => 'Light mode';

  @override
  String get setThemeDark => 'Dark mode';

  @override
  String get setLayoutSection => 'Home screen layout';

  @override
  String get setLayoutList => 'List';

  @override
  String get setLayoutGrid => 'Grid';

  @override
  String get setAccountSection => 'Account';

  @override
  String get setLogout => 'Log out';

  @override
  String get setLogoutSubtitle => 'Sign out from this device';

  @override
  String get setLogoutConfirmTitle => 'Log out?';

  @override
  String get setLogoutConfirmMessage =>
      'Are you sure you want to log out of your account?';

  @override
  String get setDeleteAccount => 'Delete account data';

  @override
  String get setDeleteSubtitle => 'Remove your account data from this device';

  @override
  String get setDeleteConfirmTitle => 'Delete account data?';

  @override
  String get setDeleteConfirmMessage =>
      'All your data on this device will be removed permanently. This cannot be undone.';

  @override
  String get setAboutSection => 'About & support';

  @override
  String get setContactTitle => 'Contact support';

  @override
  String get setContactMessage =>
      'For bugs, feedback or support, write to us at:';

  @override
  String get setCopyEmail => 'Copy email';

  @override
  String get setEmailCopied => 'Email copied';

  @override
  String get setPortfolioTitle => 'Developer portfolio';

  @override
  String get setPortfolioMessage =>
      'Open the developer website in your browser?';

  @override
  String get setVisitWebsite => 'Visit website';

  @override
  String get setVersion => 'App version';

  @override
  String get setNoteTitle => 'Important note';

  @override
  String get setNoteBody =>
      'SignCare AI helps you communicate. It does not give medical advice and does not replace a doctor or emergency services.';

  @override
  String get profileTitle => 'My profile';

  @override
  String get profileEditHint => 'Edit your name, date of birth and gender';

  @override
  String get profileName => 'Full name';

  @override
  String get profilePhoneNote => 'Your phone number cannot be changed.';

  @override
  String get profileDob => 'Date of birth';

  @override
  String get profileDobHint => 'Select date';

  @override
  String profileAge(int years) {
    return 'Age: $years';
  }

  @override
  String get profileGender => 'Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get profileGenderNote => 'Your body diagram is shown based on this.';

  @override
  String get profileSave => 'Save changes';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get profileSavedLocalOnly =>
      'Saved on this device. Could not reach the server.';

  @override
  String get profileNameError => 'Please enter your name (at least 2 letters).';

  @override
  String get profileDobError => 'Please select your date of birth.';

  @override
  String get profileGenderError => 'Please select your gender.';

  @override
  String get dobDialogTitle => 'Select date of birth';

  @override
  String get dobYear => 'Year';

  @override
  String get dobMonth => 'Month';

  @override
  String get dobDay => 'Day';

  @override
  String get dobConfirm => 'Confirm';
}
