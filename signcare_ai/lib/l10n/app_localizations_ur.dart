// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'SignCare AI';

  @override
  String get tagline => 'آپ کی آواز، ہماری دیکھ بھال';

  @override
  String get ok => 'ٹھیک ہے';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get back => 'واپس';

  @override
  String get next => 'آگے';

  @override
  String get save => 'محفوظ کریں';

  @override
  String get delete => 'حذف کریں';

  @override
  String get close => 'بند کریں';

  @override
  String get retry => 'دوبارہ کوشش کریں';

  @override
  String get yes => 'جی ہاں';

  @override
  String get no => 'نہیں';

  @override
  String get navHome => 'ہوم';

  @override
  String get navMessages => 'پیغامات';

  @override
  String get navProfile => 'پروفائل';

  @override
  String get settings => 'سیٹنگز';

  @override
  String welcomeUser(String name) {
    return 'خوش آمدید، $name';
  }

  @override
  String helloUser(String name) {
    return 'ہیلو، $name 👋';
  }

  @override
  String get homeSubtitle => 'آج ہم آپ کی کیا مدد کر سکتے ہیں؟';

  @override
  String get menuCardsTitle => 'مواصلاتی کارڈز';

  @override
  String get menuCardsSubtitle => 'پیغام بنانے کے لیے کارڈز منتخب کریں';

  @override
  String get menuTypeTitle => 'پیغام لکھیں';

  @override
  String get menuTypeSubtitle => 'اپنا پیغام لکھیں اور بلند آواز میں سنائیں';

  @override
  String get menuSymptomsTitle => 'علامات اور درد';

  @override
  String get menuSymptomsSubtitle => 'اپنی علامات اور درد کی شدت بتائیں';

  @override
  String get menuEmotionsTitle => 'جذبات اور احساسات';

  @override
  String get menuEmotionsSubtitle => 'بتائیں کہ آپ کیسا محسوس کر رہے ہیں';

  @override
  String get menuSummaryTitle => 'میرا خلاصہ';

  @override
  String get menuSummarySubtitle => 'جو کچھ منتخب کیا اسے دیکھیں اور شیئر کریں';

  @override
  String get menuEmergencyTitle => 'ہنگامی مدد';

  @override
  String get menuEmergencySubtitle => 'فوری مدد کے لیے الرٹ';

  @override
  String get menuSpeechTitle => 'آواز سے تحریر';

  @override
  String get menuSpeechSubtitle => 'بولے گئے الفاظ کو تحریر میں بدلیں';

  @override
  String get menuBodyTitle => 'جسم کا نقشہ';

  @override
  String get menuBodySubtitle => 'بتائیں کہ درد کہاں ہے';

  @override
  String get exitTitle => 'ایپ بند کریں';

  @override
  String get exitMessage => 'کیا آپ واقعی SignCare AI بند کرنا چاہتے ہیں؟';

  @override
  String get exitAction => 'بند کریں';

  @override
  String get setLanguageSection => 'زبان';

  @override
  String get setAppearanceSection => 'ظاہری شکل';

  @override
  String get setThemeSystem => 'سسٹم کے مطابق';

  @override
  String get setThemeLight => 'لائٹ موڈ';

  @override
  String get setThemeDark => 'ڈارک موڈ';

  @override
  String get setLayoutSection => 'ہوم اسکرین کا انداز';

  @override
  String get setLayoutList => 'فہرست';

  @override
  String get setLayoutGrid => 'گرڈ';

  @override
  String get setAccountSection => 'اکاؤنٹ';

  @override
  String get setLogout => 'لاگ آؤٹ';

  @override
  String get setLogoutSubtitle => 'اس ڈیوائس سے سائن آؤٹ کریں';

  @override
  String get setLogoutConfirmTitle => 'لاگ آؤٹ کریں؟';

  @override
  String get setLogoutConfirmMessage =>
      'کیا آپ واقعی اپنے اکاؤنٹ سے لاگ آؤٹ کرنا چاہتے ہیں؟';

  @override
  String get setDeleteAccount => 'اکاؤنٹ ڈیٹا حذف کریں';

  @override
  String get setDeleteSubtitle => 'اس ڈیوائس سے اپنا اکاؤنٹ ڈیٹا ہٹائیں';

  @override
  String get setDeleteConfirmTitle => 'اکاؤنٹ ڈیٹا حذف کریں؟';

  @override
  String get setDeleteConfirmMessage =>
      'اس ڈیوائس پر آپ کا تمام ڈیٹا مستقل طور پر ہٹا دیا جائے گا۔ یہ عمل واپس نہیں ہو سکتا۔';

  @override
  String get setAboutSection => 'معلومات اور معاونت';

  @override
  String get setContactTitle => 'معاونت سے رابطہ';

  @override
  String get setContactMessage =>
      'خرابیوں، رائے یا مدد کے لیے ہمیں اس پتے پر لکھیں:';

  @override
  String get setCopyEmail => 'ای میل کاپی کریں';

  @override
  String get setEmailCopied => 'ای میل کاپی ہو گئی';

  @override
  String get setPortfolioTitle => 'ڈویلپر پورٹ فولیو';

  @override
  String get setPortfolioMessage =>
      'کیا ڈویلپر کی ویب سائٹ براؤزر میں کھولنی ہے؟';

  @override
  String get setVisitWebsite => 'ویب سائٹ کھولیں';

  @override
  String get setVersion => 'ایپ ورژن';

  @override
  String get setNoteTitle => 'اہم نوٹ';

  @override
  String get setNoteBody =>
      'SignCare AI آپ کو بات چیت میں مدد دیتی ہے۔ یہ طبی مشورہ نہیں دیتی اور نہ ہی ڈاکٹر یا ہنگامی خدمات کا متبادل ہے۔';

  @override
  String get profileTitle => 'میری پروفائل';

  @override
  String get profileEditHint => 'اپنا نام، تاریخ پیدائش اور جنس تبدیل کریں';

  @override
  String get profileName => 'پورا نام';

  @override
  String get profilePhoneNote => 'آپ کا فون نمبر تبدیل نہیں ہو سکتا۔';

  @override
  String get profileDob => 'تاریخ پیدائش';

  @override
  String get profileDobHint => 'تاریخ منتخب کریں';

  @override
  String profileAge(int years) {
    return 'عمر: $years سال';
  }

  @override
  String get profileGender => 'جنس';

  @override
  String get genderMale => 'مرد';

  @override
  String get genderFemale => 'عورت';

  @override
  String get genderOther => 'دیگر';

  @override
  String get profileGenderNote =>
      'آپ کا جسمانی نقشہ اسی کے مطابق دکھایا جاتا ہے۔';

  @override
  String get profileSave => 'تبدیلیاں محفوظ کریں';

  @override
  String get profileSaved => 'پروفائل محفوظ ہو گئی';

  @override
  String get profileSavedLocalOnly =>
      'اس ڈیوائس پر محفوظ ہو گئی، سرور سے رابطہ نہیں ہو سکا۔';

  @override
  String get profileNameError => 'براہ کرم اپنا نام لکھیں (کم از کم 2 حروف)۔';

  @override
  String get profileDobError => 'براہ کرم تاریخ پیدائش منتخب کریں۔';

  @override
  String get profileGenderError => 'براہ کرم اپنی جنس منتخب کریں۔';

  @override
  String get dobDialogTitle => 'تاریخ پیدائش منتخب کریں';

  @override
  String get dobYear => 'سال';

  @override
  String get dobMonth => 'مہینہ';

  @override
  String get dobDay => 'دن';

  @override
  String get dobConfirm => 'تصدیق کریں';

  @override
  String get typeTitle => 'لکھیں اور سنائیں';

  @override
  String get typeInstruction => 'جو بات ڈاکٹر یا مددگار کو بتانی ہے وہ لکھیں:';

  @override
  String get typeHint => 'اپنا پیغام یہاں لکھیں...';

  @override
  String get typeSpeak => 'بلند آواز میں سنائیں';

  @override
  String get typeStop => 'روکیں';

  @override
  String get typeAddToSummary => 'میرے خلاصے میں شامل کریں';

  @override
  String get typeClear => 'صاف کریں';

  @override
  String get typeEmptyError => 'براہ کرم پہلے پیغام لکھیں۔';

  @override
  String get typeAdded => 'آپ کے خلاصے میں شامل ہو گیا';

  @override
  String get ttsVoiceMissingTitle => 'اردو آواز انسٹال نہیں ہے';

  @override
  String get ttsVoiceMissingBody =>
      'آپ کے فون میں ٹیکسٹ ٹو اسپیچ کے لیے اردو آواز موجود نہیں۔ فون کی سیٹنگز میں Text-to-speech output تلاش کریں، Google Speech Services چنیں اور اردو وائس ڈیٹا انسٹال کریں۔ پھر دوبارہ کوشش کریں۔';

  @override
  String get ttsError => 'ابھی آواز نہیں چل سکی۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get sumTitle => 'میرا خلاصہ';

  @override
  String get sumHistory => 'تاریخچہ';

  @override
  String get sumEmptyTitle => 'ابھی کچھ شامل نہیں کیا';

  @override
  String get sumEmptyBody =>
      'آپ جو کارڈز، علامات، جذبات اور پیغامات شامل کریں گے وہ یہاں ڈاکٹر کے لیے ایک واضح خلاصے کی صورت میں نظر آئیں گے۔';

  @override
  String get sumReportTitle => 'مریض کا خلاصہ';

  @override
  String get sumDisclaimer =>
      'یہ معلومات مریض کی بتائی ہوئی ہیں۔ یہ طبی تشخیص نہیں ہے۔';

  @override
  String get sumCreatedWith => 'SignCare AI سے بنایا گیا';

  @override
  String sumCreated(String date) {
    return 'بنایا گیا $date';
  }

  @override
  String get catCards => 'مواصلاتی کارڈز';

  @override
  String get catTyped => 'لکھے ہوئے پیغامات';

  @override
  String get catSymptom => 'علامات اور درد';

  @override
  String get catBody => 'جسم کا نقشہ';

  @override
  String get catEmotion => 'جذبات';

  @override
  String get catEmergency => 'ہنگامی';

  @override
  String get catSpeech => 'گفتگو';

  @override
  String get catNote => 'نوٹس';

  @override
  String get catOther => 'دیگر';

  @override
  String get sumShowMode => 'ڈاکٹر کو دکھائیں';

  @override
  String get sumShare => 'شیئر کریں';

  @override
  String get sumShareImage => 'تصویر کی صورت میں شیئر کریں';

  @override
  String get sumShareText => 'تحریر کی صورت میں شیئر کریں';

  @override
  String get sumSaveHistory => 'تاریخچے میں محفوظ کریں';

  @override
  String get sumSaved => 'تاریخچے میں محفوظ ہو گیا';

  @override
  String get sumClear => 'سب صاف کریں';

  @override
  String get sumClearTitle => 'خلاصہ صاف کریں؟';

  @override
  String get sumClearBody => 'اس خلاصے کی تمام چیزیں ہٹا دی جائیں گی۔';

  @override
  String get sumAddNote => 'نوٹ شامل کریں';

  @override
  String get sumNoteHint => 'ڈاکٹر کے لیے نوٹ لکھیں...';

  @override
  String get sumShareFailed =>
      'ابھی شیئر نہیں ہو سکا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get sumHistoryTitle => 'محفوظ شدہ خلاصے';

  @override
  String get sumHistoryEmpty =>
      'ابھی کوئی خلاصہ محفوظ نہیں۔ اپنے خلاصے پر تاریخچے میں محفوظ کریں دبائیں۔';

  @override
  String sumHistoryCount(int count) {
    return '$count اندراجات';
  }

  @override
  String get sumDeleteReportTitle => 'یہ خلاصہ حذف کریں؟';

  @override
  String get sumDeleteReportBody =>
      'یہ محفوظ شدہ خلاصہ اس ڈیوائس سے ہٹا دیا جائے گا۔';

  @override
  String get sumReadAloud => 'بلند آواز میں سنیں';

  @override
  String get sumRemoveItem => 'ہٹائیں';

  @override
  String get emTitle => 'ہنگامی مدد';

  @override
  String get emHelpButton => 'مجھے فوری مدد چاہیے';

  @override
  String get emHelpHint => 'اسکرین چمکتی ہے اور آپ کی جگہ بولتی ہے';

  @override
  String get emContactsSection => 'میرے ہنگامی رابطے';

  @override
  String get emAddContact => 'رابطہ شامل کریں';

  @override
  String get emNoContacts =>
      'ابھی کوئی رابطہ نہیں۔ ان لوگوں کو شامل کریں جنہیں ہنگامی صورت میں فون کیا جائے۔';

  @override
  String get emAddTitle => 'ہنگامی رابطہ شامل کریں';

  @override
  String get emEditTitle => 'رابطہ تبدیل کریں';

  @override
  String get emContactName => 'نام';

  @override
  String get emContactPhone => 'فون نمبر';

  @override
  String get emContactRelation => 'رشتہ (اختیاری)';

  @override
  String get emNameError => 'براہ کرم نام لکھیں۔';

  @override
  String get emPhoneError => 'براہ کرم درست فون نمبر لکھیں۔';

  @override
  String get emMaxContacts => 'آپ زیادہ سے زیادہ 5 رابطے محفوظ کر سکتے ہیں۔';

  @override
  String get emCall => 'کال کریں';

  @override
  String get emSms => 'ایس ایم ایس بھیجیں';

  @override
  String get emEdit => 'تبدیل کریں';

  @override
  String get emDeleteContactTitle => 'یہ رابطہ ہٹائیں؟';

  @override
  String emDeleteContactBody(String name) {
    return '$name آپ کے ہنگامی رابطوں سے ہٹا دیا جائے گا۔';
  }

  @override
  String get emNumbersSection => 'ہنگامی نمبر';

  @override
  String get emRescue => 'ریسکیو / ایمبولینس';

  @override
  String get emPolice => 'پولیس';

  @override
  String get emFire => 'فائر بریگیڈ';

  @override
  String get emNumbersNote =>
      'یہ پاکستان کے نمبر ہیں۔ فون ڈائلر کھولنے کے لیے کسی پر دبائیں۔';

  @override
  String get emPhrasesSection => 'فوری بات کہیں';

  @override
  String get emAddToSummary => 'خلاصے میں شامل کریں';

  @override
  String get emCallFailed => 'فون ڈائلر نہیں کھل سکا۔';

  @override
  String emSmsBody(String name) {
    return 'ہنگامی صورتحال: $name کو فوری مدد چاہیے۔ براہ کرم فوراً فون کریں یا آ جائیں۔ SignCare AI سے بھیجا گیا۔';
  }

  @override
  String get emSmsBodyNoName =>
      'ہنگامی صورتحال: مجھے فوری مدد چاہیے۔ براہ کرم فوراً فون کریں یا آ جائیں۔ SignCare AI سے بھیجا گیا۔';

  @override
  String get emAlertHeadline => 'مجھے فوری مدد چاہیے';

  @override
  String get emAlertSub => 'میں بول نہیں سکتا۔ براہ کرم میری مدد کریں۔';

  @override
  String get emAlertSubFemale => 'میں بول نہیں سکتی۔ براہ کرم میری مدد کریں۔';

  @override
  String get emAlertSpeech =>
      'مجھے فوری طبی مدد چاہیے۔ میں بول نہیں سکتا۔ براہ کرم میری مدد کریں۔';

  @override
  String get emAlertSpeechFemale =>
      'مجھے فوری طبی مدد چاہیے۔ میں بول نہیں سکتی۔ براہ کرم میری مدد کریں۔';

  @override
  String get emStopAlert => 'الرٹ بند کریں';

  @override
  String get emCallRescue => '1122 پر کال کریں';
}
