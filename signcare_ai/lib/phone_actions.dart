import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Number se space, dash waghera hata deta hai (sirf digits aur +)
String cleanNumber(String raw) => raw.replaceAll(RegExp(r'[^0-9+]'), '');

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