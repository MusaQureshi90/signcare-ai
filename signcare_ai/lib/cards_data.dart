class CardItem {
  final String id;
  final String emoji;
  final String en;
  final String ur;
  final String category;
  final bool custom;

  const CardItem(
    this.id,
    this.emoji,
    this.en,
    this.ur,
    this.category, {
    this.custom = false,
  });

  String text(bool isUrdu) => isUrdu ? ur : en;

  /// Apne banaye hue card sirf ek text save karte hain
  Map<String, dynamic> toJson() => {'id': id, 'emoji': emoji, 'text': en};

  factory CardItem.fromJson(Map<String, dynamic> json) {
    final text = json['text']?.toString() ?? '';
    return CardItem(
      json['id']?.toString() ?? '',
      json['emoji']?.toString() ?? '💬',
      text,
      text,
      'custom',
      custom: true,
    );
  }
}

class CardCategory {
  final String code;
  final String en;
  final String ur;
  const CardCategory(this.code, this.en, this.ur);
}

const List<CardCategory> cardCategories = [
  CardCategory('needs', 'Basic needs', 'بنیادی ضروریات'),
  CardCategory('pain', 'Pain & symptoms', 'درد اور علامات'),
  CardCategory('doctor', 'Doctor & hospital', 'ڈاکٹر اور ہسپتال'),
  CardCategory('medicine', 'Medicine', 'دوا'),
  CardCategory('help', 'People & replies', 'لوگ اور جوابات'),
  CardCategory('comfort', 'Comfort', 'آرام'),
  CardCategory('food', 'Food & drink', 'کھانا پینا'),
  CardCategory('talk', 'Talking with me', 'مجھ سے بات کرنا'),
];

const List<CardItem> builtInCards = [
  // ---- Basic needs ----
  CardItem('n1', '💧', 'I need water', 'مجھے پانی چاہیے', 'needs'),
  CardItem('n2', '🍽️', 'I am hungry', 'مجھے بھوک لگی ہے', 'needs'),
  CardItem('n3', '🚻', 'I need the washroom', 'مجھے واش روم جانا ہے', 'needs'),
  CardItem('n4', '😴', 'I want to sleep', 'مجھے سونا ہے', 'needs'),
  CardItem('n5', '🛏️', 'Please help me lie down',
      'براہ کرم لیٹنے میں میری مدد کریں', 'needs'),
  CardItem('n6', '🧍', 'Please help me sit up',
      'براہ کرم بیٹھنے میں میری مدد کریں', 'needs'),
  CardItem('n7', '🥶', 'I feel cold', 'مجھے سردی لگ رہی ہے', 'needs'),
  CardItem('n8', '🥵', 'I feel hot', 'مجھے گرمی لگ رہی ہے', 'needs'),

  // ---- Pain & symptoms ----
  CardItem('p1', '🤕', 'I have a headache', 'میرے سر میں درد ہے', 'pain'),
  CardItem('p2', '🤢', 'I feel like vomiting', 'مجھے قے آ رہی ہے', 'pain'),
  CardItem('p3', '🤒', 'I have a fever', 'مجھے بخار ہے', 'pain'),
  CardItem('p4', '😮', 'I have difficulty breathing',
      'مجھے سانس لینے میں دشواری ہے', 'pain'),
  CardItem('p5', '😵', 'I feel dizzy', 'مجھے چکر آ رہے ہیں', 'pain'),
  CardItem('p6', '🦴', 'My whole body is aching',
      'میرے پورے جسم میں درد ہے', 'pain'),
  CardItem('p7', '🤧', 'I have a cough', 'مجھے کھانسی ہے', 'pain'),
  CardItem('p8', '🩸', 'I am bleeding', 'میرا خون بہہ رہا ہے', 'pain'),

  // ---- Doctor & hospital ----
  CardItem('d1', '🩺', 'I want to see a doctor', 'مجھے ڈاکٹر سے ملنا ہے', 'doctor'),
  CardItem('d2', '🔔', 'Please call the nurse', 'براہ کرم نرس کو بلائیں', 'doctor'),
  CardItem('d3', '💉', 'Will I get an injection?', 'کیا مجھے انجیکشن لگے گا؟',
      'doctor'),
  CardItem('d4', '🧪', 'When will my test results come?',
      'میری رپورٹس کب آئیں گی؟', 'doctor'),
  CardItem('d5', '🐢', 'Please explain slowly', 'براہ کرم آہستہ سمجھائیں', 'doctor'),
  CardItem('d6', '✍️', 'Please write it down', 'براہ کرم لکھ کر بتائیں', 'doctor'),
  CardItem('d7', '🏠', 'When can I go home?', 'مجھے گھر کب جانے دیں گے؟',
      'doctor'),
  CardItem('d8', '🔁', 'Please repeat that', 'براہ کرم دوبارہ بتائیں', 'doctor'),

  // ---- Medicine ----
  CardItem('m1', '💊', 'I need my medicine', 'مجھے اپنی دوا چاہیے', 'medicine'),
  CardItem('m2', '🕐', 'Is it time for my medicine?',
      'کیا میری دوا کا وقت ہو گیا ہے؟', 'medicine'),
  CardItem('m3', '🚫', 'I am allergic to this medicine',
      'مجھے اس دوا سے الرجی ہے', 'medicine'),
  CardItem('m4', '❓', 'What is this medicine for?', 'یہ دوا کس لیے ہے؟',
      'medicine'),
  CardItem('m5', '🤮', 'This medicine makes me feel sick',
      'اس دوا سے میری طبیعت خراب ہوتی ہے', 'medicine'),
  CardItem('m6', '🥤', 'Please give me water with the medicine',
      'براہ کرم دوا کے ساتھ پانی دیں', 'medicine'),
  CardItem('m7', '💊', 'I need a painkiller', 'مجھے درد کی دوا چاہیے', 'medicine'),
  CardItem('m8', '✅', 'I have already taken my medicine', 'میں نے دوا لے لی ہے',
      'medicine'),

  // ---- People & replies ----
  CardItem('h1', '🙏', 'Please help me', 'براہ کرم میری مدد کریں', 'help'),
  CardItem('h2', '👪', 'Please call my family',
      'براہ کرم میرے گھر والوں کو بلائیں', 'help'),
  CardItem('h3', '🤝', 'Please stay with me', 'براہ کرم میرے ساتھ رہیں', 'help'),
  CardItem('h4', '😊', 'Thank you', 'شکریہ', 'help'),
  CardItem('h5', '✅', 'Yes', 'جی ہاں', 'help'),
  CardItem('h6', '❌', 'No', 'جی نہیں', 'help'),
  CardItem('h7', '⏳', 'Please wait', 'براہ کرم انتظار کریں', 'help'),
  CardItem('h8', '🤷', 'I do not know', 'مجھے نہیں معلوم', 'help'),

  // ---- Comfort ----
  CardItem('c1', '🛌', 'I need another pillow', 'مجھے ایک اور تکیہ چاہیے',
      'comfort'),
  CardItem('c2', '🧣', 'I need a blanket', 'مجھے کمبل چاہیے', 'comfort'),
  CardItem('c3', '💡', 'Please turn the light on', 'براہ کرم لائٹ جلا دیں',
      'comfort'),
  CardItem('c4', '🌙', 'Please turn the light off', 'براہ کرم لائٹ بند کر دیں',
      'comfort'),
  CardItem('c5', '🌬️', 'Please open the window', 'براہ کرم کھڑکی کھول دیں',
      'comfort'),
  CardItem('c6', '🌀', 'Please turn the fan on', 'براہ کرم پنکھا چلا دیں',
      'comfort'),
  CardItem('c7', '🔇', 'It is too noisy here', 'یہاں بہت شور ہے', 'comfort'),
  CardItem('c8', '🚶', 'I want to walk a little', 'مجھے تھوڑا چلنا ہے', 'comfort'),

  // ---- Food & drink ----
  CardItem('f1', '🍵', 'I would like tea', 'مجھے چائے چاہیے', 'food'),
  CardItem('f2', '🥛', 'I would like milk', 'مجھے دودھ چاہیے', 'food'),
  CardItem('f3', '🍞', 'I would like bread', 'مجھے روٹی چاہیے', 'food'),
  CardItem('f4', '🍚', 'I would like rice', 'مجھے چاول چاہئیں', 'food'),
  CardItem('f5', '🍎', 'I would like fruit', 'مجھے پھل چاہیے', 'food'),
  CardItem('f6', '🥣', 'I would like soup', 'مجھے سوپ چاہیے', 'food'),
  CardItem('f7', '🧂', 'The food has too much salt', 'کھانے میں نمک زیادہ ہے',
      'food'),
  CardItem('f8', '🙅', 'I do not want to eat this', 'مجھے یہ کھانا نہیں کھانا',
      'food'),

  // ---- Talking with me ----
  CardItem('t1', '👂', 'I cannot hear well', 'مجھے ٹھیک سے سنائی نہیں دیتا',
      'talk'),
  CardItem('t2', '🤐', 'I have difficulty speaking, please be patient',
      'مجھے بولنے میں دشواری ہے، براہ کرم صبر کریں', 'talk'),
  CardItem('t3', '📱', 'Please read this screen', 'براہ کرم یہ اسکرین پڑھیں',
      'talk'),
  CardItem('t4', '👀', 'Please face me when you talk',
      'بات کرتے وقت میری طرف دیکھیں', 'talk'),
  CardItem('t5', '✋', 'Please use gestures', 'براہ کرم اشاروں سے سمجھائیں',
      'talk'),
  CardItem('t6', '📝', 'Please give me a pen and paper',
      'مجھے قلم اور کاغذ دیں', 'talk'),
  CardItem('t7', '🔉', 'Please do not shout', 'براہ کرم زور سے نہ بولیں',
      'talk'),
  CardItem('t8', '👍', 'I understand', 'مجھے سمجھ آ گئی ہے', 'talk'),
];