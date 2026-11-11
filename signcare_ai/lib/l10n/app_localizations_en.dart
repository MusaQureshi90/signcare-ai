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
}
