# api/urls.py

from django.urls import path
from .views import (
    UserRegistrationView, 
    UserLoginView,
    SendOtpView,
    VerifyOtpView,
    ResetPasswordView,
    ProfileView,          
    ChangePasswordView,
    DeleteAccountView
)

urlpatterns = [
    # --- Authentication URLs ---
    path('users/register/', UserRegistrationView.as_view(), name='user-registration'),
    path('users/login/', UserLoginView.as_view(), name='user-login'),
    
    # --- Password Reset URLs ---
    path('users/send-otp/', SendOtpView.as_view(), name='send-otp'),
    path('users/verify-otp/', VerifyOtpView.as_view(), name='verify-otp'),
    path('users/reset-password/', ResetPasswordView.as_view(), name='reset-password'),

    # --- Settings URLs (Add these) ---
    path('users/profile/', ProfileView.as_view(), name='user-profile'),
    path('users/change-password/', ChangePasswordView.as_view(), name='change-password'),
    path('users/delete/', DeleteAccountView.as_view(), name='user-delete'),
]