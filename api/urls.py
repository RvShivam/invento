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
    DeleteAccountView,
    ItemListCreateView,
    ItemDetailView,
    LowStockReportView,
    ItemDetailBySkuView,
    AdjustStockView,
    CategoryListView,
    SupplierListView,
)

urlpatterns = [
    # --- Authentication URLs ---
    path('users/register/', UserRegistrationView.as_view(), name='user-registration'),
    path('users/login/', UserLoginView.as_view(), name='user-login'),
    
    # --- Password Reset URLs ---
    path('users/send-otp/', SendOtpView.as_view(), name='send-otp'),
    path('users/verify-otp/', VerifyOtpView.as_view(), name='verify-otp'),
    path('users/reset-password/', ResetPasswordView.as_view(), name='reset-password'),

    # --- Settings URLs  ---
    path('users/profile/', ProfileView.as_view(), name='user-profile'),
    path('users/change-password/', ChangePasswordView.as_view(), name='change-password'),
    path('users/delete/', DeleteAccountView.as_view(), name='user-delete'),

    # --- Item Management URLs ---
    path('items/', ItemListCreateView.as_view(), name='item-list-create'),
    path('items/<int:pk>/', ItemDetailView.as_view(), name='item-detail'),
    path('items/sku/<str:sku>/', ItemDetailBySkuView.as_view(), name='item-detail-by-sku'),
    path('items/<int:pk>/adjust_stock/', AdjustStockView.as_view(), name='adjust-stock'),

    # --- Reporting & Filtwering URLs ---
    path('categories/', CategoryListView.as_view(), name='category-list'),
    path('suppliers/', SupplierListView.as_view(), name='supplier-list'),
    path('reports/low-stock/', LowStockReportView.as_view(), name='low-stock-report'),
]