from rest_framework import serializers
from .models import PatientRequest, UserPreference

class PatientRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = PatientRequest
        fields = '__all__'

class UserPreferenceSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserPreference
        fields = '__all__'