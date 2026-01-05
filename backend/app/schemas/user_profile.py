from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime
from bson import ObjectId

class PyObjectId(ObjectId):
    """Custom ObjectId type for Pydantic models."""
    
    @classmethod
    def __get_validators__(cls):
        yield cls.validate

    @classmethod
    def validate(cls, v):
        if not ObjectId.is_valid(v):
            raise ValueError("Invalid ObjectId")
        return ObjectId(v)

    @classmethod
    def __modify_schema__(cls, field_schema):
        field_schema.update(type="string")


class UserProfileBase(BaseModel):
    """Base schema for user profile (onboarding data)."""
    business_type: str = Field(..., description="Type of business: retail, ecommerce, fnb, cosmetic, other")
    industry: str = Field(..., description="Industry category")
    packaging_needs: List[str] = Field(default_factory=list, description="List of packaging types needed")
    monthly_volume: str = Field(..., description="Estimated monthly volume: 1-100, 100-500, 500-1000, 1000+")
    design_preference: str = Field(..., description="Design style: minimalist, luxury, eco-friendly, vibrant")
    
    class Config:
        json_encoders = {ObjectId: str}
        schema_extra = {
            "example": {
                "business_type": "ecommerce",
                "industry": "Fashion",
                "packaging_needs": ["boxes", "bags", "labels"],
                "monthly_volume": "100-500",
                "design_preference": "minimalist"
            }
        }


class UserProfileCreate(UserProfileBase):
    """Schema for creating user profile."""
    pass


class UserProfile(UserProfileBase):
    """Complete user profile with metadata."""
    id: Optional[PyObjectId] = Field(default_factory=PyObjectId, alias="_id")
    user_id: int = Field(..., description="Reference to PostgreSQL users.id")
    
    # AI Recommendations
    recommended_products: List[dict] = Field(default_factory=list)
    
    # Behavior tracking
    viewed_products: List[str] = Field(default_factory=list)
    cart_history: List[dict] = Field(default_factory=list)
    
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
    
    class Config:
        allow_population_by_field_name = True
        arbitrary_types_allowed = True
        json_encoders = {ObjectId: str}


class UserProfileResponse(BaseModel):
    """Response schema for user profile."""
    status: str = "success"
    message: str = "Profile saved successfully"
    profile: Optional[dict] = None
    recommendations: Optional[List[dict]] = None
