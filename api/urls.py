# api/urls.py

from django.urls import path
from .views import UserRegistrationView, UserLoginView, SendOtpView, VerifyOtpView, ResetPasswordView

urlpatterns = [
    path('users/register/', UserRegistrationView.as_view(), name='user-registration'),
    path('users/login/', UserLoginView.as_view(), name='user-login'),
    path('users/send-otp/', SendOtpView.as_view(), name='send-otp'),
    path('users/verify-otp/', VerifyOtpView.as_view(), name='verify-otp'),
    path('users/reset-password/', ResetPasswordView.as_view(), name='reset-password'),
]