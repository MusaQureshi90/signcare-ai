from django.urls import include, path

from api.views import home

urlpatterns = [
    path('', home),
    path('api/', include('api.urls')),
]