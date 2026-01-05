import random
import string
from datetime import datetime, timedelta
from typing import Any, Dict
from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel, EmailStr

from app.core.config import settings
from app.core.email_service import send_otp_email

router = APIRouter()

# In-memory OTP storage (use Redis in production)
otp_storage: Dict[str, dict] = {}


class OTPRequest(BaseModel):
    email: EmailStr


class OTPVerify(BaseModel):
    email: EmailStr
    code: str


def generate_otp(length: int = 6) -> str:
    """Generate a random numeric OTP code."""
    return ''.join(random.choices(string.digits, k=length))


@router.post("/send")
async def send_otp(request: OTPRequest) -> Any:
    """
    Generate and send OTP code to the provided email.
    """
    email = request.email.lower()
    otp_code = generate_otp()
    
    # Store OTP with expiration
    expires_at = datetime.utcnow() + timedelta(minutes=settings.OTP_EXPIRE_MINUTES)
    otp_storage[email] = {
        "code": otp_code,
        "expires_at": expires_at,
        "attempts": 0
    }
    
    # Send email
    success = send_otp_email(email, otp_code)
    
    if not success:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to send OTP email. Please try again."
        )
    
    return {
        "message": "OTP sent successfully",
        "email": email,
        "expires_in_minutes": settings.OTP_EXPIRE_MINUTES
    }


@router.post("/verify")
async def verify_otp(request: OTPVerify) -> Any:
    """
    Verify the OTP code for the provided email.
    """
    email = request.email.lower()
    code = request.code
    
    if email not in otp_storage:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No OTP found for this email. Please request a new one."
        )
    
    stored = otp_storage[email]
    
    # Check expiration
    if datetime.utcnow() > stored["expires_at"]:
        del otp_storage[email]
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="OTP has expired. Please request a new one."
        )
    
    # Check attempts (max 5)
    if stored["attempts"] >= 5:
        del otp_storage[email]
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail="Too many attempts. Please request a new OTP."
        )
    
    # Verify code
    if stored["code"] != code:
        otp_storage[email]["attempts"] += 1
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid OTP code."
        )
    
    # Success - remove OTP
    del otp_storage[email]
    
    return {
        "message": "OTP verified successfully",
        "verified": True
    }
