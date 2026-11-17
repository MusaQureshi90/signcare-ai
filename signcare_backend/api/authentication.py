from django.utils import timezone
from rest_framework.authentication import BaseAuthentication
from rest_framework.exceptions import AuthenticationFailed

from .models import AuthToken, hash_token


class TokenAuthentication(BaseAuthentication):
    """Header:  Authorization: Bearer <token>"""

    def authenticate(self, request):
        parts = request.headers.get('Authorization', '').split()
        if len(parts) != 2 or parts[0] != 'Bearer':
            return None
        try:
            token = AuthToken.objects.select_related('account').get(
                key_hash=hash_token(parts[1])
            )
        except AuthToken.DoesNotExist:
            raise AuthenticationFailed('invalid_token')
        if token.expires_at < timezone.now():
            token.delete()
            raise AuthenticationFailed('token_expired')
        return (token.account, token)

    def authenticate_header(self, request):
        return 'Bearer'