import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://signcare-ai.onrender.com/api';

  static Future<bool> sendRequest(String category, String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/requests/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'category': category,
          'message': message,
        }),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      debugPrint('sendRequest error: $e');
      return false;
    }
  }

  static Future<List<dynamic>> getRequests() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/requests/'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
    } catch (e) {
      debugPrint('getRequests error: $e');
    }
    return [];
  }

  static Future<void> savePreferences(
    String phone,
    String language,
    String theme,
    String layout,
  ) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/preferences/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone_number': phone,
          'language': language,
          'theme_mode': theme,
          'home_layout': layout,
        }),
      );
    } catch (e) {
      debugPrint('savePreferences error: $e');
    }
  }

  static Future<Map<String, dynamic>?> getPreferences(String phone) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/preferences/$phone/'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('getPreferences error: $e');
    }
    return null;
  }
}