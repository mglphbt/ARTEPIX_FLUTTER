from datetime import timedelta
from typing import Any
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from google.oauth2 import id_token
from google.auth.transport import requests

from app.api import deps
from app.core import security
from app.core.config import settings
from app.models.user import User
from app.schemas.user import Token

router = APIRouter()


@router.post("/google", response_model=Token)
async def google_login(
    google_token: dict,
    db: AsyncSession = Depends(deps.get_db)
) -> Any:
    """
    Authenticate user via Google OAuth.
    Expects: {"id_token": "..."}
    """
    try:
        # Verify the Google ID token
        idinfo = id_token.verify_oauth2_token(
            google_token.get("id_token"),
            requests.Request(),
            settings.GOOGLE_CLIENT_ID
        )
        
        google_id = idinfo.get("sub")
        email = idinfo.get("email")
        full_name = idinfo.get("name", "")
        
        if not email:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email not provided by Google"
            )
        
        # Check if user exists by google_id or email
        result = await db.execute(
            select(User).where(
                (User.google_id == google_id) | (User.email == email)
            )
        )
        user = result.scalars().first()
        
        if user:
            # Update google_id if not set (user registered with email first)
            if not user.google_id:
                user.google_id = google_id
                user.auth_provider = "google"
                user.is_email_verified = True
                await db.commit()
        else:
            # Create new user
            user = User(
                email=email,
                full_name=full_name,
                google_id=google_id,
                auth_provider="google",
                is_active=True,
                is_email_verified=True,
                hashed_password=None,
            )
            db.add(user)
            await db.commit()
            await db.refresh(user)
        
        if not user.is_active:
            raise HTTPException(status_code=400, detail="Inactive user")
        
        # Generate JWT token
        access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        return {
            "access_token": security.create_access_token(
                user.id, expires_delta=access_token_expires
            ),
            "token_type": "bearer",
        }
        
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Invalid Google token: {str(e)}"
        )
