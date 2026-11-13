class SymptomItem {
  final String id;
  final String emoji;
  final String en;
  final String ur;
  final bool custom;

  const SymptomItem(this.id, this.emoji, this.en, this.ur,
      {this.custom = false});

  String name(bool isUrdu) => isUrdu ? ur : en;
}

const List<SymptomItem> symptomList = [
  SymptomItem('fever', '🤒', 'Fever', 'بخار'),
  SymptomItem('cough', '🤧', 'Cough', 'کھانسی'),
  SymptomItem('headache', '🤕', 'Headache', 'سر درد'),
  SymptomItem('dizzy', '😵', 'Dizziness', 'چکر آنا'),
  SymptomItem('weak', '🥱', 'Weakness', 'کمزوری'),
  SymptomItem('nausea', '🤢', 'Nausea', 'متلی'),
  SymptomItem('vomit', '🤮', 'Vomiting', 'قے'),
  SymptomItem('breath', '😮', 'Shortness of breath', 'سانس کی تکلیف'),
  SymptomItem('chest', '💔', 'Chest pain', 'سینے میں درد'),
  SymptomItem('stomach', '😖', 'Stomach pain', 'پیٹ میں درد'),
  SymptomItem('diarrhoea', '🚽', 'Diarrhoea', 'دست'),
  SymptomItem('aches', '😣', 'Body aches', 'جسم میں درد'),
  SymptomItem('throat', '😷', 'Sore throat', 'گلے میں خراش'),
  SymptomItem('chills', '🥶', 'Chills', 'کپکپی'),
  SymptomItem('appetite', '🍽️', 'Loss of appetite', 'بھوک نہ لگنا'),
  SymptomItem('vision', '👁️', 'Blurred vision', 'نظر دھندلی ہونا'),
  SymptomItem('joint', '🦵', 'Joint pain', 'جوڑوں میں درد'),
  SymptomItem('numb', '🖐️', 'Numbness', 'سن ہونا'),
  SymptomItem('sleep', '😴', 'Trouble sleeping', 'نیند نہ آنا'),
  SymptomItem('urine', '💧', 'Burning urination', 'پیشاب میں جلن'),
];

class DurationOption {
  final String id;
  final String en;
  final String ur;
  const DurationOption(this.id, this.en, this.ur);

  String text(bool isUrdu) => isUrdu ? ur : en;
}

const List<DurationOption> durationOptions = [
  DurationOption('now', 'just now', 'ابھی ابھی'),
  DurationOption('minutes', 'a few minutes ago', 'کچھ منٹ پہلے'),
  DurationOption('hours', 'a few hours ago', 'کچھ گھنٹے پہلے'),
  DurationOption('today', 'today', 'آج'),
  DurationOption('yesterday', 'yesterday', 'کل'),
  DurationOption('days', 'a few days ago', 'کچھ دن پہلے'),
  DurationOption('week', 'about a week ago', 'تقریباً ایک ہفتہ پہلے'),
  DurationOption('weeks', 'more than two weeks ago', 'دو ہفتے سے زیادہ پہلے'),
];

String capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

/// Ek symptom ki ek line. sep summary ke liye ' — ', bolne ke liye ', '
String symptomLine(
  SymptomItem s,
  int? intensity,
  DurationOption? duration,
  bool isUrdu,
  String sep,
) {
  final parts = <String>[s.name(isUrdu)];
  if (intensity != null) {
    parts.add(isUrdu ? 'شدت: 10 میں سے $intensity' : 'severity $intensity out of 10');
  }
  if (duration != null) {
    parts.add(isUrdu ? 'شروع ہوا: ${duration.ur}' : 'started ${duration.en}');
  }
  return parts.join(sep);
}