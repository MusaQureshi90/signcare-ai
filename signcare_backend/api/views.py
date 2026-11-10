from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import UserPreference
from .serializers import UserPreferenceSerializer

class UserPreferenceView(APIView):
    def get(self, request, phone):
        try:
            pref = UserPreference.objects.get(phone_number=phone)
            serializer = UserPreferenceSerializer(pref)
            return Response(serializer.data)
        except UserPreference.DoesNotExist:
            return Response({'error': 'Not found'}, status=status.HTTP_404_NOT_FOUND)

    def post(self, request):
        phone = request.data.get('phone_number')
        if not phone:
            return Response({'error': 'Phone number is required'}, status=status.HTTP_400_BAD_REQUEST)
            
        pref, created = UserPreference.objects.update_or_create(
            phone_number=phone,
            defaults={
                'language': request.data.get('language', 'English'),
                'theme_mode': request.data.get('theme_mode', 'light'),
                'home_layout': request.data.get('home_layout', 'List'),
            }
        )
        serializer = UserPreferenceSerializer(pref)
        return Response(serializer.data)