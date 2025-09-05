from django.utils import timezone
from datetime import timedelta
import random
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated
from .serializers import (
    UserRegistrationSerializer, 
    UserLoginSerializer, 
    UserProfileSerializer,
    ChangePasswordSerializer,
    ItemSerializer
)
import rest_framework.serializers as serializers
from .models import User, Item
# from .email_utils import send_otp_email # Uncomment for email sending

class UserRegistrationView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserRegistrationSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            self.perform_create(serializer)
            headers = self.get_success_headers(serializer.data)
            return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)
        
        email = request.data.get('email')
        if email and User.objects.filter(email=email).exists():
            return Response({"error": "An account with this email already exists."}, status=status.HTTP_400_BAD_REQUEST)
            
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class UserLoginView(generics.GenericAPIView):
    serializer_class = UserLoginSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        email = serializer.validated_data['email']
        password = serializer.validated_data['password']
        
        user = authenticate(request, email=email, password=password)
        
        if user is None:
            return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
        
        refresh = RefreshToken.for_user(user)
        
        return Response({
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'user': {
                'id': user.id,
                'name': user.name,
                'email': user.email
            }
        })
    
class SendOtpView(generics.GenericAPIView):
    def post(self, request, *args, **kwargs):
        email = request.data.get('email')
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({'error': 'User with this email does not exist.'}, status=status.HTTP_404_NOT_FOUND)

        otp = str(random.randint(100000, 999999))
        user.otp = otp
        user.otp_expires = timezone.now() + timedelta(minutes=5)
        user.save()

        # send_otp_email(user.email, otp)
        print(f"OTP for {user.email} is: {otp}")

        return Response({'success': 'OTP sent successfully.'}, status=status.HTTP_200_OK)

class VerifyOtpView(generics.GenericAPIView):
    def post(self, request, *args, **kwargs):
        email = request.data.get('email')
        otp = request.data.get('otp')

        try:
            user = User.objects.get(email=email)
            if user.otp == otp and user.otp_expires and user.otp_expires > timezone.now():
                user.otp = None
                user.otp_expires = None
                user.save()
                
                refresh = RefreshToken.for_user(user)
                return Response({
                    'success': 'OTP verified.',
                    'access_token': str(refresh.access_token)
                })
            else:
                return Response({'error': 'Invalid or expired OTP.'}, status=status.HTTP_400_BAD_REQUEST)
        except User.DoesNotExist:
            return Response({'error': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)

class ResetPasswordView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        user = request.user
        new_password = request.data.get('new_password')
        
        if not new_password:
            return Response({'error': 'New password is required.'}, status=status.HTTP_400_BAD_REQUEST)

        user.set_password(new_password)
        user.save()
        return Response({'success': 'Password has been reset successfully.'}, status=status.HTTP_200_OK)


class ProfileView(generics.RetrieveUpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = UserProfileSerializer

    def get_object(self):
        return self.request.user

class ChangePasswordView(generics.UpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = ChangePasswordSerializer

    def update(self, request, *args, **kwargs):
        user = self.request.user
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        if not user.check_password(serializer.data.get("old_password")):
            return Response({"error": "Wrong password."}, status=status.HTTP_400_BAD_REQUEST)

        user.set_password(serializer.data.get("new_password"))
        user.save()

        return Response({"success": "Password updated successfully."}, status=status.HTTP_200_OK)
    
class DeleteAccountView(generics.DestroyAPIView):
    permission_classes = [IsAuthenticated]

    def get_object(self):
        return self.request.user

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return Response({"success": "Account deleted successfully."}, status=status.HTTP_204_NO_CONTENT)
    
class ItemListCreateView(generics.ListCreateAPIView):
    serializer_class = ItemSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Item.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class ItemDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = ItemSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Item.objects.filter(user=self.request.user)
    
class LowStockReportView(generics.ListAPIView):
    serializer_class = ItemSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        # Filter items for the current user that have a quantity of 10 or less
        return Item.objects.filter(user=self.request.user, quantity__lte=10)

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        report_data = {
            'totalLowStockItems': queryset.count(),
            'items': serializer.data
        }
        return Response(report_data)
    
class ItemDetailBySkuView(generics.RetrieveAPIView):
    serializer_class = ItemSerializer
    permission_classes = [IsAuthenticated]
    lookup_field = 'sku' 

    def get_queryset(self):
        return Item.objects.filter(user=self.request.user)
    
class AdjustStockView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Item.objects.all()
    serializer_class = ItemSerializer

    def get_object(self):
        queryset = self.get_queryset()
        obj = generics.get_object_or_404(queryset, pk=self.kwargs['pk'], user=self.request.user)
        return obj

    def post(self, request, *args, **kwargs):
        item = self.get_object()
        quantity_change = request.data.get('quantity_change')
        description = request.data.get('description')

        if not all([isinstance(quantity_change, int), description]):
            return Response({'error': 'Invalid data provided.'}, status=status.HTTP_400_BAD_REQUEST)

        item.quantity += quantity_change
        
        history_entry = {
            'type': 'Stock In' if quantity_change > 0 else 'Stock Out',
            'change': quantity_change,
            'description': description,
            'date': timezone.now().strftime('%Y-%m-%d')
        }
        if not isinstance(item.stock_history, list):
            item.stock_history = []
        item.stock_history.append(history_entry)
        
        item.save()
        serializer = self.get_serializer(item)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
class CategoryListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        categories = Item.objects.filter(user=request.user).order_by('category').values_list('category', flat=True).distinct()
        return Response(list(categories))

class SupplierListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        suppliers = Item.objects.filter(user=request.user).order_by('supplier').values_list('supplier', flat=True).distinct()
        return Response(list(suppliers))