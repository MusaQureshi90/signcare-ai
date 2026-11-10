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

# Auto create custom superuser on startup
try:
    from django.contrib.auth.models import User
    if not User.objects.filter(username='signcare_ai').exists():
        User.objects.create_superuser('signcare_ai', 'admin@example.com', '123.Qwerty')
except Exception:
    pass