import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Number se space, dash waghera hata deta hai (sirf digits aur +)
String cleanNumber(String raw) => raw.replaceAll(RegExp(r'[^0-9+]'), '');

/// WhatsApp ko country code wala number chahiye (Pakistan: 92).
/// 0300... -> 92300..., +92300... -> 92300..., 0092... -> 92...
String whatsappNumber(String raw) {
  final n = cleanNumber(raw);
  if (n.startsWith('+')) return n.substring(1);
  if (n.startsWith('00')) return n.substring(2);
  if (n.startsWith('0')) return '92${n.substring(1)}';
  if (n.length == 10 && n.startsWith('3')) return '92$n';
  return n;
}

/// Phone ka dialer us number ke saath kholta hai (call khud nahi lagata)
Future<bool> openDialer(String number) async {
  try {
    return await launchUrl(
      Uri.parse('tel:${cleanNumber(number)}'),
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    debugPrint('openDialer error: $e');
    return false;
  }
}

/// SMS app us number aur tayyar message ke saath kholta hai
Future<bool> openSms(String number, String body) async {
  try {
    return await launchUrl(
      Uri.parse('sms:${cleanNumber(number)}?body=${Uri.encodeComponent(body)}'),
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    debugPrint('openSms error: $e');
    return false;
  }
}

/// WhatsApp chat us number aur tayyar message ke saath kholta hai
Future<bool> openWhatsApp(String number, String body) async {
  try {
    return await launchUrl(
      Uri.parse(
        'https://wa.me/${whatsappNumber(number)}?text=${Uri.encodeComponent(body)}',
      ),
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    debugPrint('openWhatsApp error: $e');
    return false;
  }
}
