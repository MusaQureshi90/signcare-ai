import 'cards_data.dart';

/// Har card ka Roman Urdu (sirf search ke kaam aata hai, screen par nahi dikhta)
const Map<String, String> cardRoman = {
  // Basic needs
  'n1': 'mujhe pani chahiye',
  'n2': 'mujhe bhook lagi hai',
  'n3': 'mujhe washroom jana hai',
  'n4': 'mujhe sona hai',
  'n5': 'meherbani karke letne mein meri madad karein',
  'n6': 'meherbani karke baithne mein meri madad karein',
  'n7': 'mujhe sardi lag rahi hai',
  'n8': 'mujhe garmi lag rahi hai',
  // Pain & symptoms
  'p1': 'mere sar mein dard hai',
  'p2': 'mujhe qay ulti aa rahi hai',
  'p3': 'mujhe bukhar hai',
  'p4': 'mujhe saans lene mein dushwari hai',
  'p5': 'mujhe chakkar aa rahe hain',
  'p6': 'mere poore jism mein dard hai',
  'p7': 'mujhe khansi hai',
  'p8': 'mera khoon beh raha hai',
  // Doctor & hospital
  'd1': 'mujhe doctor se milna hai',
  'd2': 'meherbani karke nurse ko bulayein',
  'd3': 'kya mujhe injection lagega',
  'd4': 'meri reports kab ayengi',
  'd5': 'meherbani karke ahista samjhayein',
  'd6': 'meherbani karke likh kar batayein',
  'd7': 'mujhe ghar kab jane denge',
  'd8': 'meherbani karke dobara batayein',
  // Medicine
  'm1': 'mujhe apni dawa chahiye dawai',
  'm2': 'kya meri dawa ka waqt ho gaya hai',
  'm3': 'mujhe is dawa se allergy hai',
  'm4': 'yeh dawa kis liye hai',
  'm5': 'is dawa se meri tabiyat kharab hoti hai',
  'm6': 'meherbani karke dawa ke sath pani dein',
  'm7': 'mujhe dard ki dawa chahiye painkiller',
  'm8': 'main ne dawa le li hai',
  // People & replies
  'h1': 'meherbani karke meri madad karein',
  'h2': 'meherbani karke mere ghar walon ko bulayein',
  'h3': 'meherbani karke mere sath rahein',
  'h4': 'shukriya',
  'h5': 'ji haan',
  'h6': 'ji nahi',
  'h7': 'meherbani karke intezar karein',
  'h8': 'mujhe nahi maloom',
  // Comfort
  'c1': 'mujhe aik aur takiya chahiye',
  'c2': 'mujhe kambal chahiye',
  'c3': 'meherbani karke light jala dein',
  'c4': 'meherbani karke light band kar dein',
  'c5': 'meherbani karke khirki khol dein',
  'c6': 'meherbani karke pankha chala dein',
  'c7': 'yahan bohat shor hai',
  'c8': 'mujhe thora chalna hai',
  // Food & drink
  'f1': 'mujhe chai chahiye',
  'f2': 'mujhe doodh chahiye',
  'f3': 'mujhe roti chahiye',
  'f4': 'mujhe chawal chahiye',
  'f5': 'mujhe phal chahiye',
  'f6': 'mujhe soup chahiye',
  'f7': 'khane mein namak zyada hai',
  'f8': 'mujhe yeh khana nahi khana',
  // Talking with me
  't1': 'mujhe theek se sunai nahi deta',
  't2': 'mujhe bolne mein dushwari hai meherbani karke sabr karein',
  't3': 'meherbani karke yeh screen parhein',
  't4': 'baat karte waqt meri taraf dekhein',
  't5': 'meherbani karke ishare se samjhayein',
  't6': 'mujhe qalam aur kagaz dein',
  't7': 'meherbani karke zor se na bolein',
  't8': 'mujhe samajh aa gayi hai',
};

/// Milte-julte Urdu harf aik jaise bana deta hai (keyboard ke farq se bachne ke liye)
const Map<String, String> _urduFix = {
  'ي': 'ی',
  'ى': 'ی',
  'ې': 'ی',
  'ك': 'ک',
  'ه': 'ہ',
  'ة': 'ہ',
  'ۃ': 'ہ',
  'ھ': 'ہ',
  'ۓ': 'ے',
  'آ': 'ا',
  'أ': 'ا',
  'إ': 'ا',
  'ٱ': 'ا',
};

/// Search ke liye text saaf: chhote harf, Urdu variants barabar, zer/zabar khatam,
/// doharay English harf aik (paani = pani)
String normalizeForSearch(String input) {
  var s = input.toLowerCase();
  _urduFix.forEach((from, to) {
    s = s.replaceAll(from, to);
  });
  s = s.replaceAll(RegExp('[\u064B-\u065F\u0670\u0640\u200B-\u200F]'), '');
  s = s.replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), ' ');
  s = s.replaceAllMapped(RegExp(r'([a-z])\1+'), (m) => m[1]!);
  return s.replaceAll(RegExp(r'\s+'), ' ').trim();
}

/// Sirf consonants (vowels aur h, y, w hata kar), dheele match ke liye
String _skeleton(String s) =>
    s.replaceAll(RegExp(r'[^a-z]'), '').replaceAll(RegExp(r'[aeiouyhw]'), '');

/// English, Urdu aur Roman Urdu teeno mein dhoondta hai
List<CardItem> searchCards(List<CardItem> all, String query) {
  final q = normalizeForSearch(query);
  if (q.isEmpty) return all;
  final tokens = q.split(' ');

  final hays = <String, String>{
    for (final c in all)
      c.id: normalizeForSearch('${c.en} ${c.ur} ${cardRoman[c.id] ?? ''}'),
  };

  // 1) Seedha match: har lafz card ke text mein hona chahiye
  final strict = all
      .where((c) => tokens.every((t) => hays[c.id]!.contains(t)))
      .toList();
  if (strict.isNotEmpty) return strict;

  // 2) Kuch na mile to dheela match (Roman spelling ke farq ke liye)
  final latin = RegExp(r'^[a-z]+$');
  return all.where((c) {
    final hay = hays[c.id]!;
    final hs = _skeleton(hay);
    return tokens.every((t) {
      if (hay.contains(t)) return true;
      final ts = _skeleton(t);
      return latin.hasMatch(t) && ts.length >= 2 && hs.contains(ts);
    });
  }).toList();
}