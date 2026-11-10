from django.db import models

class PatientRequest(models.Model):
    category = models.CharField(max_length=100) # Jaise Pain, Common Needs, Emergency
    message = models.TextField() # Jo aawaz ya text announce hua
    created_at = models.DateTimeField(auto_now_add=True) # Kis waqt bheji gayi

    def __str__(self):
        return f"{self.category}: {self.message} ({self.created_at})"

class UserPreference(models.Model):
    phone_number = models.CharField(max_length=20, unique=True) # User ka phone number identifier ke tor par
    language = models.CharField(max_length=20, default='English') # English ya Urdu
    theme_mode = models.CharField(max_length=20, default='light') # light ya dark
    home_layout = models.CharField(max_length=20, default='List') # List ya Grid
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Prefs for {self.phone_number} - Lang: {self.language}, Theme: {self.theme_mode}"