from fastapi import APIRouter, Depends, HTTPException
from typing import Any

from app.api import deps
from app.models.user import User
from app.services.ai.gemini_service import GeminiRecommendationEngine

router = APIRouter()
gemini_engine = GeminiRecommendationEngine()


@router.get("/recommendations")
async def get_ai_recommendations(
    current_user: User = Depends(deps.get_current_user),
    mongo_db = Depends(deps.get_mongo_db)
) -> Any:
    """
    Get AI-powered product recommendations based on user's onboarding profile.
    Requires user to have completed onboarding first.
    """
    
    # Fetch user profile from MongoDB
    profile = await mongo_db.user_profiles.find_one({"user_id": current_user.id})
    
    if not profile:
        raise HTTPException(
            status_code=404,
            detail="User profile not found. Please complete onboarding first."
        )
    
    # Generate AI recommendations
    try:
        recommendations = await gemini_engine.generate_recommendations(profile)
        
        # Save recommendations to user profile
        await mongo_db.user_profiles.update_one(
            {"user_id": current_user.id},
            {"$set": {"recommended_products": recommendations}}
        )
        
        return {
            "status": "success",
            "recommendations": recommendations,
            "profile_summary": {
                "business_type": profile.get("business_type"),
                "industry": profile.get("industry"),
                "design_preference": profile.get("design_preference")
            }
        }
    
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Failed to generate recommendations: {str(e)}"
        )
