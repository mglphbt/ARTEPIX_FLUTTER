from fastapi import APIRouter, Depends, HTTPException, status
from typing import Any
from datetime import datetime

from app.api import deps
from app.models.user import User
from app.schemas.user_profile import (
    UserProfileCreate,
    UserProfile,
    UserProfileResponse
)

router = APIRouter()


@router.post("/save", response_model=UserProfileResponse)
async def save_onboarding_profile(
    profile_in: UserProfileCreate,
    current_user: User = Depends(deps.get_current_user),
    mongo_db = Depends(deps.get_mongo_db)
) -> Any:
    """
    Save or update user onboarding profile to MongoDB.
    This endpoint is called after user completes questionnaire and logs in.
    """
    
    # Prepare profile data
    profile_data = profile_in.dict()
    profile_data["user_id"] = current_user.id
    profile_data["updated_at"] = datetime.utcnow()
    
    # Check if profile exists
    existing_profile = await mongo_db.user_profiles.find_one({"user_id": current_user.id})
    
    if existing_profile:
        # Update existing profile
        await mongo_db.user_profiles.update_one(
            {"user_id": current_user.id},
            {"$set": profile_data}
        )
        message = "Profile updated successfully"
    else:
        # Create new profile
        profile_data["created_at"] = datetime.utcnow()
        await mongo_db.user_profiles.insert_one(profile_data)
        message = "Profile created successfully"
    
    # TODO: Generate AI recommendations based on profile
    # recommendations = await generate_recommendations(profile_data)
    recommendations = []  # Placeholder for now
    
    return UserProfileResponse(
        status="success",
        message=message,
        profile=profile_data,
        recommendations=recommendations
    )


@router.get("/profile", response_model=UserProfile)
async def get_user_profile(
    current_user: User = Depends(deps.get_current_user),
    mongo_db = Depends(deps.get_mongo_db)
) -> Any:
    """
    Get current user's onboarding profile from MongoDB.
    """
    profile = await mongo_db.user_profiles.find_one({"user_id": current_user.id})
    
    if not profile:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User profile not found. Please complete onboarding first."
        )
    
    return profile


@router.delete("/profile")
async def delete_user_profile(
    current_user: User = Depends(deps.get_current_user),
    mongo_db = Depends(deps.get_mongo_db)
) -> Any:
    """
    Delete user's onboarding profile (GDPR compliance).
    """
    result = await mongo_db.user_profiles.delete_one({"user_id": current_user.id})
    
    if result.deleted_count == 0:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Profile not found"
        )
    
    return {"status": "success", "message": "Profile deleted successfully"}


@router.put("/profile/behavior")
async def track_user_behavior(
    event_type: str,
    event_data: dict,
    current_user: User = Depends(deps.get_current_user),
    mongo_db = Depends(deps.get_mongo_db)
) -> Any:
    """
    Track user behavior (product views, cart additions, etc.)
    for analytics and AI recommendations.
    """
    if event_type == "product_view":
        await mongo_db.user_profiles.update_one(
            {"user_id": current_user.id},
            {"$push": {"viewed_products": event_data.get("product_id")}}
        )
    elif event_type == "cart_add":
        await mongo_db.user_profiles.update_one(
            {"user_id": current_user.id},
            {"$push": {"cart_history": event_data}}
        )
    
    return {"status": "success", "message": f"Event '{event_type}' tracked"}
