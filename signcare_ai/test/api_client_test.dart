import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:signcare_ai/api_client.dart';

http.Response json(int status, Map<String, dynamic> body) =>
    http.Response(jsonEncode(body), status,
        headers: {'content-type': 'application/json'});

ApiClient clientReturning(http.Response Function(http.Request) handler,
    {Duration? timeout}) {
  return ApiClient(
    client: MockClient((req) async => handler(req)),
    timeout: timeout,
    baseUrl: 'https://example.test/api',
  );
}

void main() {
  test('success: token aur profile milte hain', () async {
    final api = clientReturning((_) => json(200, {
          'token': 'abc',
          'profile': {'name': 'Zainab'},
        }));
    final res = await api.post('/auth/login/', body: {});
    expect(res.ok, true);
    expect(res.token, 'abc');
    expect(res.profile!['name'], 'Zainab');
  });

  test('wrong password -> invalidCredentials', () async {
    final api = clientReturning(
        (_) => json(401, {'error': 'invalid_credentials', 'message': 'x'}));
    final res = await api.post('/auth/login/', body: {});
    expect(res.ok, false);
    expect(res.error, ApiError.invalidCredentials);
  });

  test('409 -> phoneExists', () async {
    final api = clientReturning((_) => json(409, {'error': 'phone_exists'}));
    expect((await api.post('/auth/register/', body: {})).error,
        ApiError.phoneExists);
  });

  test('validation 400', () async {
    final api = clientReturning((_) => json(400, {'error': 'validation'}));
    expect((await api.post('/x/', body: {})).error, ApiError.validation);
  });

  test('token galat (detail) -> unauthorized', () async {
    final api = clientReturning((_) => json(401, {'detail': 'invalid_token'}));
    expect((await api.get('/me/', token: 't')).error, ApiError.unauthorized);
  });

  test('lock aur throttle alag alag', () async {
    final locked = clientReturning((_) => json(429, {'error': 'locked'}));
    expect((await locked.post('/x/', body: {})).error, ApiError.locked);
    final throttled =
        clientReturning((_) => json(429, {'detail': 'Request was throttled.'}));
    expect((await throttled.post('/x/', body: {})).error, ApiError.throttled);
  });

  test('Render ka HTML error page -> server', () async {
    final api = clientReturning(
        (_) => http.Response('<html>Bad Gateway</html>', 502));
    expect((await api.get('/me/')).error, ApiError.server);
  });

  test('internet nahi -> network', () async {
    final api = ApiClient(
      client: MockClient((_) async => throw const SocketException('no net')),
      baseUrl: 'https://example.test/api',
    );
    expect((await api.get('/me/')).error, ApiError.network);
  });

  test('der lagi -> timeout', () async {
    final api = ApiClient(
      client: MockClient((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 300));
        return json(200, {});
      }),
      timeout: const Duration(milliseconds: 50),
      baseUrl: 'https://example.test/api',
    );
    expect((await api.get('/me/')).error, ApiError.timeout);
  });

  test('token Bearer header mein jata hai', () async {
    String? seen;
    final api = clientReturning((req) {
      seen = req.headers['Authorization'];
      return json(200, {'profile': {}});
    });
    await api.get('/me/', token: 'secret');
    expect(seen, 'Bearer secret');
  });
}