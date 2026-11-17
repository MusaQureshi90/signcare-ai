import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Server se aane wale masle, screens inhi par switch karengi.
enum ApiError {
  network, // internet nahi / server tak pahunch nahi
  timeout, // bohat der lag gayi
  server, // server ka apna masla (5xx)
  unauthorized, // token khatam ya galat, dobara login chahiye
  invalidCredentials, // phone ya password galat
  phoneExists, // ye number pehle se registered hai
  locked, // bohat galat koshishein, 15 minute ruko
  throttled, // bohat zyada requests
  validation, // koi field galat bhari
  wrongPassword, // maujooda password galat (change / delete par)
  invalidRecovery, // phone ya recovery code galat
  unknown,
}

class ApiResult {
  const ApiResult({required this.status, this.data = const {}, this.error});

  final int status;
  final Map<String, dynamic> data;
  final ApiError? error;

  bool get ok => error == null;
  String? get token => data['token'] as String?;
  String? get recoveryCode => data['recovery_code'] as String?;

  Map<String, dynamic>? get profile {
    final p = data['profile'];
    return p is Map ? Map<String, dynamic>.from(p) : null;
  }
}

class ApiClient {
  ApiClient({http.Client? client, Duration? timeout, String? baseUrl})
      : _client = client ?? http.Client(),
        timeout = timeout ?? const Duration(seconds: 45),
        baseUrl = baseUrl ?? defaultBaseUrl;

  static const String defaultBaseUrl = 'https://signcare-ai.onrender.com/api';

  /// Poori app yahi use karti hai. Test mein apna bana kar badal sakte hain.
  static ApiClient instance = ApiClient();

  final http.Client _client;
  final Duration timeout;
  final String baseUrl;

  /// Render ka server so raha ho to app khulte hi jaga do (jawab ignore).
  Future<void> wakeUp() async {
    try {
      final root = baseUrl.replaceFirst(RegExp(r'/api/?$'), '/');
      await _client.get(Uri.parse(root)).timeout(timeout);
    } catch (_) {
      // koi baat nahi, bas jagane ki koshish thi
    }
  }

  Future<ApiResult> get(String path, {String? token}) =>
      _send('GET', path, token: token);

  Future<ApiResult> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) =>
      _send('POST', path, body: body, token: token);

  Future<ApiResult> patch(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) =>
      _send('PATCH', path, body: body, token: token);

  Future<http.Response> _request(
    String method,
    Uri uri,
    Map<String, String> headers,
    Map<String, dynamic>? body,
  ) {
    switch (method) {
      case 'GET':
        return _client.get(uri, headers: headers);
      case 'PATCH':
        return _client.patch(uri, headers: headers, body: jsonEncode(body ?? {}));
      default:
        return _client.post(uri, headers: headers, body: jsonEncode(body ?? {}));
    }
  }

  Future<ApiResult> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    try {
      final res = await _request(method, uri, headers, body).timeout(timeout);
      return _parse(res);
    } on TimeoutException {
      return const ApiResult(status: 0, error: ApiError.timeout);
    } on SocketException {
      return const ApiResult(status: 0, error: ApiError.network);
    } on http.ClientException {
      return const ApiResult(status: 0, error: ApiError.network);
    } catch (e) {
      debugPrint('ApiClient error: $e');
      return const ApiResult(status: 0, error: ApiError.unknown);
    }
  }

  ApiResult _parse(http.Response res) {
    var data = <String, dynamic>{};
    try {
      final decoded = jsonDecode(utf8.decode(res.bodyBytes));
      if (decoded is Map) data = Map<String, dynamic>.from(decoded);
    } catch (_) {
      // body JSON nahi (jaise Render ka HTML error page), data khali rahega
    }
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return ApiResult(status: res.statusCode, data: data);
    }
    return ApiResult(
      status: res.statusCode,
      data: data,
      error: _errorFor(res.statusCode, data),
    );
  }

  ApiError _errorFor(int status, Map<String, dynamic> data) {
    switch (data['error']) {
      case 'invalid_credentials':
        return ApiError.invalidCredentials;
      case 'phone_exists':
        return ApiError.phoneExists;
      case 'locked':
        return ApiError.locked;
      case 'validation':
        return ApiError.validation;
      case 'wrong_password':
        return ApiError.wrongPassword;
      case 'invalid_recovery':
        return ApiError.invalidRecovery;
    }
    if (status == 401) return ApiError.unauthorized;
    if (status == 429) return ApiError.throttled;
    if (status >= 500) return ApiError.server;
    return ApiError.unknown;
  }
}