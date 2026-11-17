from django.core.cache import cache
from django.test import TestCase, override_settings
from rest_framework.test import APIClient

from .models import Account

REG = {
    'phone_number': '0300-1234567',
    'password': 'secret123',
    'name': 'Test User',
    'age': '26 years',
    'gender': 'Female',
}


@override_settings(
    PASSWORD_HASHERS=['django.contrib.auth.hashers.MD5PasswordHasher']
)
class AuthFlowTests(TestCase):
    def setUp(self):
        cache.clear()  # throttle ka count har test mein saaf
        self.c = APIClient()

    def register(self, **extra):
        return self.c.post('/api/auth/register/', {**REG, **extra}, format='json')

    def login(self, password='secret123', phone='03001234567', client=None):
        return (client or self.c).post(
            '/api/auth/login/',
            {'phone_number': phone, 'password': password},
            format='json',
        )

    def authed(self, token):
        client = APIClient()
        client.credentials(HTTP_AUTHORIZATION='Bearer ' + token)
        return client

    def test_register_ok_and_password_is_hashed(self):
        r = self.register()
        self.assertEqual(r.status_code, 201)
        self.assertIn('token', r.data)
        self.assertEqual(len(r.data['recovery_code']), 14)
        self.assertEqual(r.data['profile']['phone_number'], '03001234567')
        self.assertNotIn('password', r.data['profile'])
        acc = Account.objects.get(phone_number='03001234567')
        self.assertNotEqual(acc.password_hash, 'secret123')
        self.assertNotIn('secret123', acc.password_hash)

    def test_same_phone_in_any_format_is_duplicate(self):
        self.assertEqual(self.register().status_code, 201)
        for fmt in ['+92 300 1234567', '03001234567', '923001234567']:
            r = self.register(phone_number=fmt)
            self.assertEqual(r.status_code, 409, fmt)
            self.assertEqual(r.data['error'], 'phone_exists')
        self.assertEqual(Account.objects.count(), 1)

    def test_bad_phone_and_short_password_rejected(self):
        self.assertEqual(self.register(phone_number='12345').status_code, 400)
        self.assertEqual(self.register(password='123').status_code, 400)

    def test_login_ok_and_wrong_password(self):
        self.register()
        ok = self.login()
        self.assertEqual(ok.status_code, 200)
        self.assertIn('token', ok.data)
        bad = self.login(password='nope')
        self.assertEqual(bad.status_code, 401)
        self.assertEqual(bad.data['error'], 'invalid_credentials')
        self.assertEqual(self.login(phone='03009999999').status_code, 401)

    def test_lockout_after_five_wrong_attempts(self):
        self.register()
        for _ in range(5):
            self.assertEqual(self.login(password='bad').status_code, 401)
        r = self.login()  # ab sahi password bhi nahi chalega
        self.assertEqual(r.status_code, 429)
        self.assertEqual(r.data['error'], 'locked')

    def test_me_needs_token_and_never_shows_password(self):
        token = self.register().data['token']
        self.assertEqual(APIClient().get('/api/me/').status_code, 401)
        r = self.authed(token).get('/api/me/')
        self.assertEqual(r.status_code, 200)
        self.assertEqual(r.data['profile']['name'], 'Test User')
        self.assertNotIn('password', str(r.data).lower())

    def test_update_profile(self):
        token = self.register().data['token']
        c = self.authed(token)
        r = c.patch(
            '/api/me/', {'language': 'Urdu', 'theme_mode': 'dark'}, format='json'
        )
        self.assertEqual(r.status_code, 200)
        self.assertEqual(r.data['profile']['language'], 'Urdu')
        self.assertEqual(r.data['profile']['name'], 'Test User')
        bad = c.patch('/api/me/', {'theme_mode': 'pink'}, format='json')
        self.assertEqual(bad.status_code, 400)

    def test_two_phones_logout_one(self):
        self.register()
        t1 = self.login().data['token']
        t2 = self.login().data['token']
        self.assertEqual(self.authed(t1).get('/api/me/').status_code, 200)
        self.assertEqual(self.authed(t2).get('/api/me/').status_code, 200)
        self.assertEqual(self.authed(t1).post('/api/auth/logout/').status_code, 200)
        self.assertEqual(self.authed(t1).get('/api/me/').status_code, 401)
        self.assertEqual(self.authed(t2).get('/api/me/').status_code, 200)

    def test_change_password_logs_out_other_phones(self):
        t1 = self.register().data['token']
        t2 = self.login().data['token']
        r = self.authed(t1).post(
            '/api/auth/change-password/',
            {'old_password': 'secret123', 'new_password': 'brandnew1'},
            format='json',
        )
        self.assertEqual(r.status_code, 200)
        self.assertEqual(self.authed(t1).get('/api/me/').status_code, 200)
        self.assertEqual(self.authed(t2).get('/api/me/').status_code, 401)
        self.assertEqual(self.login().status_code, 401)
        self.assertEqual(self.login(password='brandnew1').status_code, 200)

    def test_reset_password_with_recovery_code(self):
        reg = self.register()
        code = reg.data['recovery_code']
        r = self.c.post(
            '/api/auth/reset-password/',
            {
                'phone_number': '03001234567',
                'recovery_code': code.lower(),
                'new_password': 'afterreset1',
            },
            format='json',
        )
        self.assertEqual(r.status_code, 200)
        self.assertNotEqual(r.data['recovery_code'], code)
        self.assertEqual(
            self.authed(reg.data['token']).get('/api/me/').status_code, 401
        )
        self.assertEqual(self.login().status_code, 401)
        self.assertEqual(self.login(password='afterreset1').status_code, 200)
        again = self.c.post(
            '/api/auth/reset-password/',
            {
                'phone_number': '03001234567',
                'recovery_code': code,
                'new_password': 'another123',
            },
            format='json',
        )
        self.assertEqual(again.status_code, 400)

    def test_delete_account(self):
        token = self.register().data['token']
        c = self.authed(token)
        wrong = c.post('/api/me/delete/', {'password': 'bad'}, format='json')
        self.assertEqual(wrong.status_code, 400)
        ok = c.post('/api/me/delete/', {'password': 'secret123'}, format='json')
        self.assertEqual(ok.status_code, 200)
        self.assertEqual(Account.objects.count(), 0)
        self.assertEqual(self.login().status_code, 401)
        self.assertEqual(self.register().status_code, 201)  # number dobara free

    def test_old_open_endpoint_is_gone(self):
        self.register()
        self.assertEqual(self.c.get('/api/preferences/03001234567/').status_code, 404)