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

  @override
  String get typeTitle => 'Type & Speak';

  @override
  String get typeInstruction =>
      'Type what you want to tell the doctor or helper:';

  @override
  String get typeHint => 'Type your message here...';

  @override
  String get typeSpeak => 'Speak aloud';

  @override
  String get typeStop => 'Stop';

  @override
  String get typeAddToSummary => 'Add to my summary';

  @override
  String get typeClear => 'Clear';

  @override
  String get typeEmptyError => 'Please type a message first.';

  @override
  String get typeAdded => 'Added to your summary';

  @override
  String get ttsVoiceMissingTitle => 'Urdu voice not installed';

  @override
  String get ttsVoiceMissingBody =>
      'Your phone has no Urdu voice for text-to-speech. Open phone Settings, search for Text-to-speech output, choose Google Speech Services, and install the Urdu voice data. Then try again.';

  @override
  String get ttsError => 'Could not speak right now. Please try again.';

  @override
  String get sumTitle => 'My summary';

  @override
  String get sumHistory => 'History';

  @override
  String get sumEmptyTitle => 'Nothing added yet';

  @override
  String get sumEmptyBody =>
      'Cards, symptoms, emotions and messages you add will appear here as one clear summary for the doctor.';

  @override
  String get sumReportTitle => 'Patient summary';

  @override
  String get sumDisclaimer => 'Patient-reported information. Not a diagnosis.';

  @override
  String get sumCreatedWith => 'Created with SignCare AI';

  @override
  String sumCreated(String date) {
    return 'Created $date';
  }

  @override
  String get catCards => 'Communication cards';

  @override
  String get catTyped => 'Typed messages';

  @override
  String get catSymptom => 'Symptoms and pain';

  @override
  String get catBody => 'Body diagram';

  @override
  String get catEmotion => 'Emotions';

  @override
  String get catEmergency => 'Emergency';

  @override
  String get catSpeech => 'Conversation';

  @override
  String get catNote => 'Notes';

  @override
  String get catOther => 'Other';

  @override
  String get sumShowMode => 'Show to doctor';

  @override
  String get sumShare => 'Share';

  @override
  String get sumShareImage => 'Share as image';

  @override
  String get sumShareText => 'Share as text';

  @override
  String get sumSaveHistory => 'Save to history';

  @override
  String get sumSaved => 'Saved to history';

  @override
  String get sumClear => 'Clear all';

  @override
  String get sumClearTitle => 'Clear summary?';

  @override
  String get sumClearBody => 'All items in this summary will be removed.';

  @override
  String get sumAddNote => 'Add a note';

  @override
  String get sumNoteHint => 'Write a note for the doctor...';

  @override
  String get sumShareFailed => 'Could not share right now. Please try again.';

  @override
  String get sumHistoryTitle => 'Saved summaries';

  @override
  String get sumHistoryEmpty =>
      'No saved summaries yet. Tap Save to history on your summary.';

  @override
  String sumHistoryCount(int count) {
    return '$count items';
  }

  @override
  String get sumDeleteReportTitle => 'Delete this summary?';

  @override
  String get sumDeleteReportBody =>
      'This saved summary will be removed from this device.';

  @override
  String get sumReadAloud => 'Read aloud';

  @override
  String get sumRemoveItem => 'Remove';

  @override
  String get emTitle => 'Emergency Help';

  @override
  String get emHelpButton => 'I NEED HELP NOW';

  @override
  String get emHelpHint => 'Flashes the screen and speaks for you';

  @override
  String get emContactsSection => 'My emergency contacts';

  @override
  String get emAddContact => 'Add contact';

  @override
  String get emNoContacts =>
      'No contacts yet. Add the people who should be called in an emergency.';

  @override
  String get emAddTitle => 'Add emergency contact';

  @override
  String get emEditTitle => 'Edit contact';

  @override
  String get emContactName => 'Name';

  @override
  String get emContactPhone => 'Phone number';

  @override
  String get emContactRelation => 'Relationship (optional)';

  @override
  String get emNameError => 'Please enter a name.';

  @override
  String get emPhoneError => 'Please enter a valid phone number.';

  @override
  String get emMaxContacts => 'You can save up to 5 contacts.';

  @override
  String get emCall => 'Call';

  @override
  String get emSms => 'Send SMS';

  @override
  String get emEdit => 'Edit';

  @override
  String get emDeleteContactTitle => 'Remove this contact?';

  @override
  String emDeleteContactBody(String name) {
    return '$name will be removed from your emergency contacts.';
  }

  @override
  String get emNumbersSection => 'Emergency numbers';

  @override
  String get emRescue => 'Rescue / Ambulance';

  @override
  String get emPolice => 'Police';

  @override
  String get emFire => 'Fire brigade';

  @override
  String get emNumbersNote =>
      'Numbers for Pakistan. Tap one to open the phone dialer.';

  @override
  String get emPhrasesSection => 'Say it quickly';

  @override
  String get emAddToSummary => 'Add to summary';

  @override
  String get emCallFailed => 'Could not open the phone dialer.';

  @override
  String emSmsBody(String name) {
    return 'EMERGENCY: $name needs urgent help. Please call or come immediately. Sent from SignCare AI.';
  }

  @override
  String get emSmsBodyNoName =>
      'EMERGENCY: I need urgent help. Please call or come immediately. Sent from SignCare AI.';

  @override
  String get emAlertHeadline => 'I NEED URGENT HELP';

  @override
  String get emAlertSub => 'I cannot speak. Please help me.';

  @override
  String get emAlertSubFemale => 'I cannot speak. Please help me.';

  @override
  String get emAlertSpeech =>
      'I need urgent medical help. I cannot speak. Please help me.';

  @override
  String get emAlertSpeechFemale =>
      'I need urgent medical help. I cannot speak. Please help me.';

  @override
  String get emStopAlert => 'Stop alert';

  @override
  String get emCallRescue => 'Call 1122';

  @override
  String get emWhatsApp => 'WhatsApp';

  @override
  String get emAppFailed => 'Could not open the app. Please check the number.';

  @override
  String get cardsTitle => 'Quick Cards';

  @override
  String get cardsSearchHint => 'Search cards';

  @override
  String get cardsAll => 'All';

  @override
  String get cardsFavourites => 'Favourites';

  @override
  String get cardsRecent => 'Recent';

  @override
  String get cardsMine => 'My cards';

  @override
  String get cardsEmpty => 'No cards here yet.';

  @override
  String get cardsEmptyFav => 'Tap the star on a card to save it here.';

  @override
  String get cardsEmptyRecent => 'Cards you use will appear here.';

  @override
  String get cardsEmptyMine => 'Add your own cards with the + button.';

  @override
  String get cardsNoResults => 'No cards match your search.';

  @override
  String get cardsAddOwn => 'Add my own card';

  @override
  String get cardsNewTitle => 'New card';

  @override
  String get cardsTextLabel => 'What should it say?';

  @override
  String get cardsTextError => 'Please type something.';

  @override
  String get cardsPickEmoji => 'Pick a picture';

  @override
  String get cardsMaxCustom => 'You can save up to 30 of your own cards.';

  @override
  String get cardsDeleteTitle => 'Delete this card?';

  @override
  String get cardsHoldHint => 'Press and hold one of your cards to delete it.';

  @override
  String get cardsSpeakOn => 'Cards will speak when tapped.';

  @override
  String get cardsSpeakOff => 'Cards will stay silent when tapped.';

  @override
  String get cardsSpeakTooltip => 'Speak when tapped';

  @override
  String get cardsAddSummary => 'Add to summary';
}
