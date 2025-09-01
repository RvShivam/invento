# api/viewspy
from django.utils import timezone
from datetime import timedelta
import random
from rest_framework import generics, status
from rest_framework.response import Response
from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken
from .serializers import UserRegistrationSerializer, UserLoginSerializer
from .models import User
from rest_framework.permissions import IsAuthenticated

#from .email_utils import send_otp_email  #uncomment the function in api/email_utils for email sending

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

        # Generate OTP
        otp = str(random.randint(100000, 999999))
        user.otp = otp
        user.otp_expires = timezone.now() + timedelta(minutes=5)
        user.save()

        # Replace the print statement with the email function call after setting up third party email service
        # currently sendgrid is being used
        # send_otp_email(user.email, otp)
        print(f"OTP for {user.email} is: {otp}") # For now, we'll just print it to the console

        return Response({'success': 'OTP sent successfully.'}, status=status.HTTP_200_OK)

class VerifyOtpView(generics.GenericAPIView):
    def post(self, request, *args, **kwargs):
        email = request.data.get('email')
        otp = request.data.get('otp')

        try:
            user = User.objects.get(email=email)
            if user.otp == otp and user.otp_expires > timezone.now():
                # OTP is valid. Clear it after verification.
                user.otp = None
                user.otp_expires = None
                user.save()
                
                # Grant a temporary token for password reset
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
        # With IsAuthenticated, the user is automatically attached to the request
        user = request.user
        new_password = request.data.get('new_password')
        
        if not new_password:
            return Response({'error': 'New password is required.'}, status=status.HTTP_400_BAD_REQUEST)

        user.set_password(new_password)
        user.save()
        return Response({'success': 'Password has been reset successfully.'}, status=status.HTTP_200_OK)