from django.urls import path
from .views import UserPreferenceView

urlpatterns = [
    path('preferences/', UserPreferenceView.as_view()),
    path('preferences/<str:phone>/', UserPreferenceView.as_view()),
]