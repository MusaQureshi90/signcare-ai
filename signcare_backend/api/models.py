from django.db import models

class PatientRequest(models.Model):
    category = models.CharField(max_length=100)
    message = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.category}: {self.message} ({self.created_at})"

class UserPreference(models.Model):
    phone_number = models.CharField(max_length=20, unique=True)
    name = models.CharField(max_length=100, blank=True, null=True)
    age = models.CharField(max_length=50, blank=True, null=True)
    gender = models.CharField(max_length=20, blank=True, null=True)
    password = models.CharField(max_length=100, blank=True, null=True)
    language = models.CharField(max_length=20, default='English')
    theme_mode = models.CharField(max_length=20, default='light')
    home_layout = models.CharField(max_length=20, default='List')
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.name or 'User'} - {self.phone_number}"