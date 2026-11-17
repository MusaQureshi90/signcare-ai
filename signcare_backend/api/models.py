import hashlib
import secrets
from datetime import timedelta

from django.contrib.auth.hashers import check_password, make_password
from django.db import models
from django.utils import timezone

# Recovery code mein 0, O, 1, I jaise confusing harf nahi hote.
RECOVERY_ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'

MAX_FAILED_ATTEMPTS = 5
LOCK_MINUTES = 15


def hash_token(raw):
    """Token ko database mein seedha nahi, uska hash rakhte hain."""
    return hashlib.sha256(raw.encode()).hexdigest()


def new_recovery_code():
    chars = ''.join(secrets.choice(RECOVERY_ALPHABET) for _ in range(12))
    return f'{chars[:4]}-{chars[4:8]}-{chars[8:]}'


def canonical_recovery(raw):
    """'abcd efgh-jkmn' jaisa kuch bhi aaye, ABCD-EFGH-JKMN bana do."""
    c = ''.join(ch for ch in str(raw).upper() if ch.isalnum())
    if len(c) == 12:
        return f'{c[:4]}-{c[4:8]}-{c[8:]}'
    return str(raw)


class Account(models.Model):
    phone_number = models.CharField(max_length=15, unique=True)
    # Abhi hamesha False. Jab asli OTP lagayenge tab True hoga.
    phone_verified = models.BooleanField(default=False)
    name = models.CharField(max_length=100, blank=True, default='')
    age = models.CharField(max_length=50, blank=True, default='')
    gender = models.CharField(max_length=20, blank=True, default='')
    password_hash = models.CharField(max_length=256)
    recovery_hash = models.CharField(max_length=256, blank=True, default='')
    language = models.CharField(max_length=20, default='English')
    theme_mode = models.CharField(max_length=20, default='light')
    home_layout = models.CharField(max_length=20, default='List')
    failed_attempts = models.PositiveSmallIntegerField(default=0)
    locked_until = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    # DRF ko request.user ke liye ye do cheezein chahiye hoti hain.
    is_authenticated = True
    is_anonymous = False

    def __str__(self):
        return f'{self.name or "User"} - {self.phone_number}'

    # ---- password ----
    def set_password(self, raw):
        self.password_hash = make_password(raw)

    def check_password(self, raw):
        return bool(self.password_hash) and check_password(raw, self.password_hash)

    # ---- recovery code ----
    def issue_recovery_code(self):
        code = new_recovery_code()
        self.recovery_hash = make_password(code)
        return code

    def check_recovery_code(self, raw):
        return bool(self.recovery_hash) and check_password(
            canonical_recovery(raw), self.recovery_hash
        )

    # ---- galat koshishon par lock ----
    def is_locked(self):
        return self.locked_until is not None and self.locked_until > timezone.now()

    def register_failure(self):
        self.failed_attempts += 1
        if self.failed_attempts >= MAX_FAILED_ATTEMPTS:
            self.locked_until = timezone.now() + timedelta(minutes=LOCK_MINUTES)
            self.failed_attempts = 0
        self.save(update_fields=['failed_attempts', 'locked_until'])

    def clear_failures(self):
        if self.failed_attempts or self.locked_until:
            self.failed_attempts = 0
            self.locked_until = None
            self.save(update_fields=['failed_attempts', 'locked_until'])


class AuthToken(models.Model):
    """Har phone/login ka apna token. Logout par sirf wahi delete hota hai."""

    key_hash = models.CharField(max_length=64, unique=True)
    account = models.ForeignKey(
        Account, on_delete=models.CASCADE, related_name='tokens'
    )
    device = models.CharField(max_length=100, blank=True, default='')
    created_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField()

    @classmethod
    def issue(cls, account, device='', remember=True):
        """Naya token banata hai aur asli (hash nahi) token wapas deta hai."""
        cls.objects.filter(expires_at__lt=timezone.now()).delete()
        raw = secrets.token_urlsafe(40)
        days = 90 if remember else 1
        cls.objects.create(
            key_hash=hash_token(raw),
            account=account,
            device=(device or '')[:100],
            expires_at=timezone.now() + timedelta(days=days),
        )
        return raw