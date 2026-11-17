from django.urls import path

from .views import (
    ChangePasswordView,
    DeleteAccountView,
    LoginView,
    LogoutView,
    MeView,
    RegisterView,
    ResetPasswordView,
)

urlpatterns = [
    path('auth/register/', RegisterView.as_view()),
    path('auth/login/', LoginView.as_view()),
    path('auth/logout/', LogoutView.as_view()),
    path('auth/change-password/', ChangePasswordView.as_view()),
    path('auth/reset-password/', ResetPasswordView.as_view()),
    path('me/', MeView.as_view()),
    path('me/delete/', DeleteAccountView.as_view()),
]