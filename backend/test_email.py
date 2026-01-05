"""
Test script to verify SMTP email configuration.
Run this locally to send a test OTP email.
"""
import sys
sys.path.insert(0, '.')

from app.core.email_service import send_otp_email

if __name__ == "__main__":
    test_email = "mglphbt@gmail.com"
    test_otp = "847291"
    
    print(f"Sending test OTP email to: {test_email}")
    print(f"OTP Code: {test_otp}")
    
    success = send_otp_email(test_email, test_otp)
    
    if success:
        print("✅ Email sent successfully!")
    else:
        print("❌ Failed to send email. Check SMTP configuration.")
