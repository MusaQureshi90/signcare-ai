from django.db import IntegrityError, transaction
from django.http import HttpResponse
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import Account, AuthToken
from .serializers import (
    ChangePasswordSerializer,
    DeleteAccountSerializer,
    LoginSerializer,
    ProfileUpdateSerializer,
    RegisterSerializer,
    ResetPasswordSerializer,
)


def home(request):
    return HttpResponse('SignCare AI backend is running.')


def fail(code, message, http_status):
    """Har error ek jaisa:  {"error": "<code>", "message": "..."}
    App 'error' code dekh kar apni zubaan mein message dikhayegi."""
    return Response({'error': code, 'message': message}, status=http_status)


def invalid(serializer):
    return Response(
        {
            'error': 'validation',
            'message': 'Some fields are invalid.',
            'fields': serializer.errors,
        },
        status=status.HTTP_400_BAD_REQUEST,
    )


def locked_response():
    return fail(
        'locked',
        'Too many wrong attempts. Try again in 15 minutes.',
        status.HTTP_429_TOO_MANY_REQUESTS,
    )


def profile_data(a):
    # Password ya hash KABHI response mein nahi jata.
    return {
        'phone_number': a.phone_number,
        'phone_verified': a.phone_verified,
        'name': a.name,
        'age': a.age,
        'gender': a.gender,
        'language': a.language,
        'theme_mode': a.theme_mode,
        'home_layout': a.home_layout,
    }


class PublicView(APIView):
    """Bina login wale endpoints (register, login, reset)."""

    authentication_classes = []
    permission_classes = [AllowAny]
    throttle_scope = 'auth'


class PrivateView(APIView):
    """Sirf token wale user ke liye."""

    permission_classes = [IsAuthenticated]


class RegisterView(PublicView):
    def post(self, request):
        s = RegisterSerializer(data=request.data)
        if not s.is_valid():
            return invalid(s)
        d = s.validated_data

        taken = fail(
            'phone_exists',
            'An account with this phone number already exists.',
            status.HTTP_409_CONFLICT,
        )
        if Account.objects.filter(phone_number=d['phone_number']).exists():
            return taken

        account = Account(
            phone_number=d['phone_number'],
            name=d['name'],
            age=d['age'],
            gender=d['gender'],
            language=d['language'],
            theme_mode=d['theme_mode'],
            home_layout=d['home_layout'],
        )
        account.set_password(d['password'])
        recovery_code = account.issue_recovery_code()
        try:
            with transaction.atomic():
                account.save()
        except IntegrityError:
            # Do log ek saath register karein to database unique rule bachata hai.
            return taken

        token = AuthToken.issue(account, d['device'], d['remember_me'])
        return Response(
            {
                'token': token,
                'recovery_code': recovery_code,
                'profile': profile_data(account),
            },
            status=status.HTTP_201_CREATED,
        )


class LoginView(PublicView):
    def post(self, request):
        s = LoginSerializer(data=request.data)
        if not s.is_valid():
            return invalid(s)
        d = s.validated_data

        bad = fail(
            'invalid_credentials',
            'Wrong phone number or password.',
            status.HTTP_401_UNAUTHORIZED,
        )
        account = Account.objects.filter(phone_number=d['phone_number']).first()
        if account is None:
            return bad
        if account.is_locked():
            return locked_response()
        if not account.check_password(d['password']):
            account.register_failure()
            return bad

        account.clear_failures()
        token = AuthToken.issue(account, d['device'], d['remember_me'])
        return Response({'token': token, 'profile': profile_data(account)})


class LogoutView(PrivateView):
    def post(self, request):
        request.auth.delete()  # sirf is phone ka token
        return Response({'ok': True})


class MeView(PrivateView):
    def get(self, request):
        return Response({'profile': profile_data(request.user)})

    def patch(self, request):
        s = ProfileUpdateSerializer(data=request.data)
        if not s.is_valid():
            return invalid(s)
        account = request.user
        for field, value in s.validated_data.items():
            setattr(account, field, value)
        account.save()
        return Response({'profile': profile_data(account)})


class ChangePasswordView(PrivateView):
    throttle_scope = 'auth'

    def post(self, request):
        s = ChangePasswordSerializer(data=request.data)
        if not s.is_valid():
            return invalid(s)
        d = s.validated_data
        account = request.user

        if account.is_locked():
            return locked_response()
        if not account.check_password(d['old_password']):
            account.register_failure()
            return fail(
                'wrong_password',
                'Current password is wrong.',
                status.HTTP_400_BAD_REQUEST,
            )

        account.clear_failures()
        account.set_password(d['new_password'])
        account.save()
        # Baqi sab phones se logout, sirf ye wala login rahe.
        account.tokens.exclude(pk=request.auth.pk).delete()
        return Response({'ok': True})


class ResetPasswordView(PublicView):
    """Password bhoolne par: phone number + register ke waqt mila recovery code."""

    def post(self, request):
        s = ResetPasswordSerializer(data=request.data)
        if not s.is_valid():
            return invalid(s)
        d = s.validated_data

        bad = fail(
            'invalid_recovery',
            'Phone number or recovery code is wrong.',
            status.HTTP_400_BAD_REQUEST,
        )
        account = Account.objects.filter(phone_number=d['phone_number']).first()
        if account is None:
            return bad
        if account.is_locked():
            return locked_response()
        if not account.check_recovery_code(d['recovery_code']):
            account.register_failure()
            return bad

        account.clear_failures()
        account.set_password(d['new_password'])
        new_code = account.issue_recovery_code()  # purana code khatam
        account.save()
        account.tokens.all().delete()  # har phone se logout
        return Response({'ok': True, 'recovery_code': new_code})


class DeleteAccountView(PrivateView):
    throttle_scope = 'auth'

    def post(self, request):
        s = DeleteAccountSerializer(data=request.data)
        if not s.is_valid():
            return invalid(s)
        account = request.user

        if account.is_locked():
            return locked_response()
        if not account.check_password(s.validated_data['password']):
            account.register_failure()
            return fail(
                'wrong_password',
                'Password is wrong.',
                status.HTTP_400_BAD_REQUEST,
            )

        account.delete()  # tokens bhi saath delete (cascade)
        return Response({'ok': True})