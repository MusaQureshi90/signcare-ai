import re

from rest_framework import serializers

PHONE_RE = re.compile(r'^03\d{9}$')


def normalize_phone(raw):
    """0300-1234567, +92 300 1234567, 00923001234567 -> sab 03001234567 banenge.
    Isi se ek number ka duplicate account nahi ban sakta. Galat number par None."""
    d = re.sub(r'\D', '', str(raw))
    if d.startswith('0092'):
        d = '0' + d[4:]
    elif d.startswith('92') and len(d) == 12:
        d = '0' + d[2:]
    elif len(d) == 10 and d.startswith('3'):
        d = '0' + d
    return d if PHONE_RE.match(d) else None


LANGUAGES = ['English', 'Urdu']
THEMES = ['light', 'dark', 'system']
LAYOUTS = ['List', 'Grid']
GENDERS = ['Male', 'Female', 'Other']


class PhoneMixin:
    def validate_phone_number(self, value):
        phone = normalize_phone(value)
        if not phone:
            raise serializers.ValidationError(
                'Enter a valid mobile number like 03XXXXXXXXX.'
            )
        return phone


class RegisterSerializer(PhoneMixin, serializers.Serializer):
    phone_number = serializers.CharField(max_length=30)
    password = serializers.CharField(
        min_length=6, max_length=128, trim_whitespace=False
    )
    name = serializers.CharField(
        max_length=100, required=False, allow_blank=True, default=''
    )
    age = serializers.CharField(
        max_length=50, required=False, allow_blank=True, default=''
    )
    gender = serializers.ChoiceField(
        choices=GENDERS, required=False, allow_blank=True, default=''
    )
    language = serializers.ChoiceField(choices=LANGUAGES, default='English')
    theme_mode = serializers.ChoiceField(choices=THEMES, default='light')
    home_layout = serializers.ChoiceField(choices=LAYOUTS, default='List')
    device = serializers.CharField(
        max_length=100, required=False, allow_blank=True, default=''
    )
    remember_me = serializers.BooleanField(default=True)


class LoginSerializer(PhoneMixin, serializers.Serializer):
    phone_number = serializers.CharField(max_length=30)
    password = serializers.CharField(
        max_length=128, trim_whitespace=False
    )
    device = serializers.CharField(
        max_length=100, required=False, allow_blank=True, default=''
    )
    remember_me = serializers.BooleanField(default=True)


class ProfileUpdateSerializer(serializers.Serializer):
    """Phone number yahan se nahi badalta, wo account ki pehchan hai."""

    name = serializers.CharField(max_length=100, required=False, allow_blank=True)
    age = serializers.CharField(max_length=50, required=False, allow_blank=True)
    gender = serializers.ChoiceField(
        choices=GENDERS, required=False, allow_blank=True
    )
    language = serializers.ChoiceField(choices=LANGUAGES, required=False)
    theme_mode = serializers.ChoiceField(choices=THEMES, required=False)
    home_layout = serializers.ChoiceField(choices=LAYOUTS, required=False)


class ChangePasswordSerializer(serializers.Serializer):
    old_password = serializers.CharField(max_length=128, trim_whitespace=False)
    new_password = serializers.CharField(
        min_length=6, max_length=128, trim_whitespace=False
    )


class ResetPasswordSerializer(PhoneMixin, serializers.Serializer):
    phone_number = serializers.CharField(max_length=30)
    recovery_code = serializers.CharField(max_length=40)
    new_password = serializers.CharField(
        min_length=6, max_length=128, trim_whitespace=False
    )


class DeleteAccountSerializer(serializers.Serializer):
    password = serializers.CharField(max_length=128, trim_whitespace=False)