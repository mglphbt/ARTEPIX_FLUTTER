from fastapi import APIRouter
from app.api.v1.endpoints import auth, google_auth, otp, onboarding, ai_recommendations

api_router = APIRouter()
api_router.include_router(auth.router, prefix="/auth", tags=["auth"])
api_router.include_router(google_auth.router, prefix="/auth", tags=["auth"])
api_router.include_router(otp.router, prefix="/auth/otp", tags=["otp"])
api_router.include_router(onboarding.router, prefix="/onboarding", tags=["onboarding"])
api_router.include_router(ai_recommendations.router, prefix="/ai", tags=["ai"])

