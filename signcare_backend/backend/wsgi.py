"""
WSGI config for backend project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/6.1/howto/deployment/wsgi/
"""

import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')

application = get_wsgi_application()

# Force create or update superuser credentials
try:
    from django.contrib.auth.models import User
    user, created = User.objects.get_or_create(username='signcare_ai', defaults={'email': 'admin@example.com'})
    user.set_password('123.Qwerty')
    user.is_superuser = True
    user.is_staff = True
    user.save()
except Exception:
    pass