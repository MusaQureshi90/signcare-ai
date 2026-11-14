import 'dart:math' as math;
import 'package:flutter/material.dart';

class SubPart {
  final String id;
  final String en;
  final String ur;
  const SubPart(this.id, this.en, this.ur);

  String text(bool isUrdu) => isUrdu ? ur : en;
}

class BodyPart {
  final String id;
  final String en;
  final String ur;

  /// Urdu mein isme "دائیں/بائیں" lagta hai ("دایاں/بایاں" nahi)
  final bool urFem;
  final List<SubPart> subs;

  const BodyPart(this.id, this.en, this.ur,
      {this.urFem = false, required this.subs});
}

// ---- Aam options jo kai hisson mein hain ----
const _pain = SubPart('pain', 'Pain', 'درد');
const _swell = SubPart('swell', 'Swelling', 'سوجن');
const _numb = SubPart('numb', 'Numbness or tingling', 'سن ہونا یا جھنجھناہٹ');
const _weak = SubPart('weak', 'Weakness', 'کمزوری');
const _wound = SubPart('wound', 'Injury or wound', 'چوٹ یا زخم');
const _cramp = SubPart('cramp', 'Cramps', 'کھنچاؤ');
const _muscle = SubPart('muscle', 'Muscle pain', 'پٹھوں میں درد');
const _stiff = SubPart('stiff', 'Stiffness', 'اکڑن');
const _dizzy = SubPart('dizzy', 'Dizziness', 'چکر آنا');
const _legPain =
    SubPart('legpain', 'Pain going down the leg', 'درد ٹانگ تک جانا');

const _periodPain = SubPart('period', 'Period pain', 'ماہواری کا درد');
const _testicular = SubPart('testicle', 'Testicular pain', 'خصیے میں درد');

// ---------------- Samne ka view ----------------
const _head = BodyPart('head', 'Head', 'سر', subs: [
  _pain,
  SubPart('headache', 'Headache', 'سر درد'),
  SubPart('migraine', 'Migraine (one-sided)', 'آدھے سر کا درد'),
  _dizzy,
  SubPart('hinjury', 'Head injury', 'سر پر چوٹ'),
  SubPart('eye', 'Eye pain or vision problem', 'آنکھ میں درد یا نظر کا مسئلہ'),
  SubPart('ear', 'Ear pain', 'کان میں درد'),
  SubPart('tooth', 'Toothache', 'دانت میں درد'),
  SubPart('sinus', 'Sinus pressure', 'ناک اور ماتھے پر دباؤ'),
  SubPart('jaw', 'Mouth or jaw pain', 'منہ یا جبڑے میں درد'),
]);

const _neck = BodyPart('neck', 'Neck', 'گردن', urFem: true, subs: [
  _pain,
  SubPart('throat', 'Sore throat', 'گلے میں خراش'),
  SubPart('swallow', 'Difficulty swallowing', 'نگلنے میں دشواری'),
  SubPart('nstiff', 'Stiff neck', 'گردن اکڑ جانا'),
  SubPart('glands', 'Swollen glands', 'گلٹیاں سوج جانا'),
  SubPart('voice', 'Voice problem', 'آواز کا مسئلہ'),
]);

const _chest = BodyPart('chest', 'Chest', 'سینہ', subs: [
  _pain,
  SubPart('tight', 'Tightness or pressure', 'سینے میں دباؤ یا جکڑن'),
  SubPart('sharp', 'Sharp pain', 'تیز چبھنے والا درد'),
  SubPart('palp', 'Racing heartbeat', 'دل کی تیز دھڑکن'),
  SubPart('breath', 'Difficulty breathing', 'سانس لینے میں دشواری'),
  SubPart('coughpain', 'Pain when coughing', 'کھانسی میں درد'),
  SubPart('wheeze', 'Wheezing', 'سانس میں سیٹی کی آواز'),
]);

const _abdomen = BodyPart('abdomen', 'Abdomen (stomach)', 'پیٹ', subs: [
  _pain,
  SubPart('ache', 'Stomach ache', 'پیٹ میں درد'),
  _cramp,
  SubPart('acid', 'Acidity or burning', 'تیزابیت یا جلن'),
  SubPart('bloat', 'Bloating or gas', 'پیٹ پھولنا یا گیس'),
  SubPart('nausea', 'Nausea or vomiting', 'متلی یا قے'),
  SubPart('bowel', 'Diarrhoea or constipation', 'دست یا قبض'),
  SubPart('upright', 'Pain on the upper right side', 'اوپر دائیں طرف درد'),
  SubPart('lowright', 'Pain on the lower right side', 'نیچے دائیں طرف درد'),
]);

const _pelvis = BodyPart('pelvis', 'Pelvis and groin', 'پیڑو اور کولہے', subs: [
  _pain,
  SubPart('urine', 'Burning urination', 'پیشاب میں جلن'),
  SubPart('freq', 'Frequent urination', 'بار بار پیشاب آنا'),
  SubPart('lowabd', 'Lower abdominal pain', 'پیٹ کے نچلے حصے میں درد'),
  SubPart('groin', 'Groin pain', 'ران اور پیڑو کے درمیان درد'),
  SubPart('hip', 'Hip pain', 'کولہے میں درد'),
]);

const _arm = BodyPart('arm', 'Arm', 'بازو', subs: [
  _pain,
  SubPart('shoulder', 'Shoulder pain', 'کندھے میں درد'),
  SubPart('elbow', 'Elbow pain', 'کہنی میں درد'),
  _muscle,
  _numb,
  _weak,
  _swell,
  _wound,
]);

const _hand = BodyPart('hand', 'Hand', 'ہاتھ', subs: [
  _pain,
  SubPart('wrist', 'Wrist pain', 'کلائی میں درد'),
  SubPart('finger', 'Finger pain', 'انگلی میں درد'),
  SubPart('grip', 'Weak grip', 'پکڑ کمزور ہونا'),
  _numb,
  _swell,
  _wound,
]);

const _thigh = BodyPart('thigh', 'Thigh', 'ران', urFem: true, subs: [
  _pain,
  _muscle,
  _cramp,
  _weak,
  _numb,
  _swell,
  _wound,
]);

const _knee = BodyPart('knee', 'Knee', 'گھٹنا', subs: [
  _pain,
  _swell,
  _stiff,
  SubPart('bend', 'Cannot bend or straighten', 'مڑتا یا سیدھا نہیں ہوتا'),
  SubPart('lock', 'Clicking or locking', 'آواز آنا یا پھنس جانا'),
  _wound,
]);

const _shin = BodyPart('shin', 'Lower leg', 'ٹانگ کا نچلا حصہ', urFem: true, subs: [
  _pain,
  _cramp,
  _swell,
  SubPart('walkpain', 'Pain when walking', 'چلنے میں درد'),
  _numb,
  _wound,
]);

const _foot = BodyPart('foot', 'Foot', 'پاؤں', subs: [
  _pain,
  SubPart('ankle', 'Ankle pain', 'ٹخنے میں درد'),
  SubPart('heel', 'Heel pain', 'ایڑی میں درد'),
  SubPart('toe', 'Toe pain', 'پاؤں کی انگلی میں درد'),
  _swell,
  _numb,
  _wound,
]);

// ---------------- Pichle view ----------------
const _backHead =
    BodyPart('backhead', 'Back of head', 'سر کا پچھلا حصہ', subs: [
  _pain,
  SubPart('bheadache', 'Headache at the back', 'سر کے پچھلے حصے میں درد'),
  _dizzy,
  SubPart('binjury', 'Head injury', 'سر پر چوٹ'),
]);

const _backNeck =
    BodyPart('backneck', 'Back of neck', 'گردن کا پچھلا حصہ', urFem: true, subs: [
  _pain,
  _stiff,
  _muscle,
  SubPart('turn', 'Pain when turning the head', 'سر موڑنے میں درد'),
]);

const _upperBack = BodyPart('upperback', 'Upper back', 'اوپری کمر', urFem: true, subs: [
  _pain,
  SubPart('blade', 'Shoulder blade pain', 'کندھے کی ہڈی کے پاس درد'),
  SubPart('ustiff', 'Muscle stiffness', 'پٹھوں کی اکڑن'),
  SubPart('breathpain', 'Pain when breathing', 'سانس لینے میں درد'),
  SubPart('burn', 'Burning sensation', 'جلن'),
]);

const _lowerBack = BodyPart('lowerback', 'Lower back', 'نچلی کمر', urFem: true, subs: [
  _pain,
  SubPart('strain', 'Muscle strain', 'پٹھوں میں کھنچاؤ'),
  SubPart('spine', 'Spine pain', 'ریڑھ کی ہڈی میں درد'),
  SubPart('kidney', 'Kidney area pain', 'گردے کی جگہ درد'),
  _legPain,
  SubPart('bendhard', 'Difficulty bending', 'جھکنے میں دشواری'),
]);

const _buttocks = BodyPart('buttocks', 'Buttocks and hips', 'کولہے', subs: [
  _pain,
  SubPart('tail', 'Tailbone pain', 'دم کی ہڈی میں درد'),
  SubPart('sitpain', 'Pain when sitting', 'بیٹھنے میں درد'),
  _legPain,
]);

const _backArm =
    BodyPart('backarm', 'Arm (back)', 'بازو کا پچھلا حصہ', subs: [
  _pain,
  SubPart('belbow', 'Elbow pain', 'کہنی میں درد'),
  _muscle,
  _numb,
  _weak,
  _swell,
  _wound,
]);

const _backThigh =
    BodyPart('backthigh', 'Thigh (back)', 'ران کا پچھلا حصہ', urFem: true, subs: [
  _pain,
  SubPart('hamstring', 'Hamstring pain', 'ران کے پچھلے پٹھوں میں درد'),
  _cramp,
  _weak,
  _wound,
]);

const _backKnee =
    BodyPart('backknee', 'Knee (back)', 'گھٹنا (پچھلا حصہ)', subs: [
  _pain,
  _swell,
  _stiff,
]);

const _calf = BodyPart('calf', 'Calf', 'پنڈلی', urFem: true, subs: [
  _pain,
  _cramp,
  _swell,
  SubPart('bwalk', 'Pain when walking', 'چلنے میں درد'),
  _numb,
  _wound,
]);

const _heel = BodyPart('heel', 'Heel', 'ایڑی', urFem: true, subs: [
  _pain,
  SubPart('sole', 'Sole pain', 'تلوے میں درد'),
  _swell,
  _numb,
  _wound,
]);

const List<BodyPart> _allParts = [
  _head, _neck, _chest, _abdomen, _pelvis, _arm, _hand, _thigh, _knee, _shin,
  _foot, _backHead, _backNeck, _upperBack, _lowerBack, _buttocks, _backArm,
  _backThigh, _backKnee, _calf, _heel,
];

final Map<String, BodyPart> bodyParts = {
  for (final p in _allParts) p.id: p,
};

/// Is hisse ke options (gender ke hisaab se kuch alag)
List<SubPart> subsFor(BodyPart part, String model) {
  if (part.id == 'pelvis') {
    return [...part.subs, model == 'female' ? _periodPain : _testicular];
  }
  return part.subs;
}

class BodyRegion {
  final String id;
  final BodyPart part;

  /// 'r' (dayan), 'l' (bayan) ya null
  final String? side;
  final Path path;

  BodyRegion(this.id, this.part, this.side, this.path);
}

String regionLabel(BodyRegion r, bool isUrdu) {
  final p = r.part;
  if (r.side == null) return isUrdu ? p.ur : p.en;
  final right = r.side == 'r';
  if (isUrdu) {
    final word = right
        ? (p.urFem ? 'دائیں' : 'دایاں')
        : (p.urFem ? 'بائیں' : 'بایاں');
    return '$word ${p.ur}';
  }
  return '${right ? 'Right' : 'Left'} ${p.en.toLowerCase()}';
}

/// Jism ke hisse (200 x 440 ke khayali naqshe mein)
List<BodyRegion> buildRegions(String model, bool back) {
  const cx = 100.0;
  final female = model == 'female';
  final sh = female ? 33.0 : 38.0; // kandhay ki aadhi chaurai
  final wa = female ? 27.0 : 33.0; // kamar
  final hp = female ? 37.0 : 33.0; // kulhay

  Path rr(double l, double t, double r, double b, double rad) =>
      Path()..addRRect(RRect.fromLTRBR(l, t, r, b, Radius.circular(rad)));

  // Beech se a se b doori par, upar se neeche
  Path sideRR(String side, double a, double b, double top, double bottom,
      double rad) {
    // Samne se dekhein to dayan hissa screen ke bayen taraf hota hai
    final d = (side == 'r') == !back ? -1.0 : 1.0;
    final x1 = cx + d * a;
    final x2 = cx + d * b;
    return rr(math.min(x1, x2), top, math.max(x1, x2), bottom, rad);
  }

  final regions = <BodyRegion>[];

  void add(String partId, Path path, [String? side]) {
    final part = bodyParts[partId]!;
    final id = '${back ? 'b' : 'f'}_$partId${side == null ? '' : '_$side'}';
    regions.add(BodyRegion(id, part, side, path));
  }

  add(back ? 'backhead' : 'head',
      Path()..addOval(const Rect.fromLTRB(80, 8, 120, 58)));
  add(back ? 'backneck' : 'neck', rr(91, 58, 109, 78, 5));
  add(back ? 'upperback' : 'chest', rr(cx - sh, 78, cx + sh, 140, 12));
  add(back ? 'lowerback' : 'abdomen', rr(cx - wa, 142, cx + wa, 192, 10));
  add(back ? 'buttocks' : 'pelvis', rr(cx - hp, 194, cx + hp, 232, 12));

  for (final s in const ['r', 'l']) {
    add(back ? 'backarm' : 'arm', sideRR(s, sh + 2, sh + 18, 80, 204, 8), s);
    add('hand', sideRR(s, sh + 3, sh + 17, 207, 240, 7), s);
    add(back ? 'backthigh' : 'thigh', sideRR(s, 3, hp, 236, 322, 12), s);
    add(back ? 'backknee' : 'knee', sideRR(s, 4, hp - 3, 324, 348, 10), s);
    add(back ? 'calf' : 'shin', sideRR(s, 5, hp - 6, 350, 414, 11), s);
    add(back ? 'heel' : 'foot', sideRR(s, 4, hp + 4, 416, 436, 8), s);
  }
  return regions;
}