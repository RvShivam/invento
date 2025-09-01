# utility function for sending password email to the user
"""from django.core.mail import send_mail
from django.conf import settings

def send_otp_email(recipient_email, otp):
    subject = 'Your Invento Password Reset Code'
    message = f'Your OTP for password reset is: {otp}\n\nThis code is valid for 5 minutes.'
    from_email = settings.DEFAULT_FROM_EMAIL
    
    try:
        send_mail(subject, message, from_email, [recipient_email])
    except Exception as e:
        # Handle potential email sending errors
        print(f"Error sending email: {e}")
"""