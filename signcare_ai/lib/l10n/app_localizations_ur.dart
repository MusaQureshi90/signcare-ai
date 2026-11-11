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
}
