from django.contrib import admin
from .models import UserPreference  # Yahan apne model ka naam likhna

# Model ko admin panel mein register karne ke liye:
admin.site.register(UserPreference)