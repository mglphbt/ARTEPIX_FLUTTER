"""
Google Gemini AI Service for ARTEPIX Smart Packaging
Generates product recommendations based on user profiles
"""

import os
import json
from typing import List, Dict, Optional
import google.generativeai as genai
from app.core.config import settings


class GeminiRecommendationEngine:
    """AI-powered recommendation engine using Google Gemini."""
    
    def __init__(self):
        """Initialize Gemini with API key from environment."""
        # Configure Gemini API
        genai.configure(api_key=settings.GEMINI_API_KEY)
        self.model = genai.GenerativeModel('gemini-1.5-pro')
        
        # Product catalog for prompting
        self.product_catalog = [
            {
                "id": "hardbox_premium",
                "name": "Premium Hardbox",
                "description": "Rigid box dengan finishing mewah, cocok untuk produk high-end",
                "ideal_for": ["cosmetic", "fashion", "luxury goods"],
                "material": "Cardboard 350gsm + Art Paper",
                "price_range": "Premium"
            },
            {
                "id": "softbox_eco",
                "name": "Eco Softbox",
                "description": "Box fleksibel dengan material ramah lingkungan",
                "ideal_for": ["fnb", "retail", "eco-brands"],
                "material": "Recycled Kraft Paper",
                "price_range": "Budget-Friendly"
            },
            {
                "id": "corrugated_shipper",
                "name": "E-commerce Shipper Box",
                "description": "Corrugated box kuat untuk pengiriman jarak jauh",
                "ideal_for": ["ecommerce", "electronics"],
                "material": "Corrugated Board BC-Flute",
                "price_range": "Mid-Range"
            },
            {
                "id": "pouch_standing",
                "name": "Standing Pouch dengan Zipper",
                "description": "Pouch berdiri dengan zipper, cocok untuk produk konsumsi",
                "ideal_for": ["fnb", "snacks", "coffee"],
                "material": "Aluminum Foil + PE",
                "price_range": "Mid-Range"
            },
            {
                "id": "mailer_box",
                "name": "Minimalist Mailer Box",
                "description": "Box desain simpel untuk brand modern",
                "ideal_for": ["fashion", "cosmetic", "subscription box"],
                "material": "Kraft Corrugated",
                "price_range": "Budget-Friendly"
            }
        ]
    
    async def generate_recommendations(
        self,
        user_profile: Dict
    ) -> List[Dict]:
        """
        Generate AI-powered product recommendations.
        
        Args:
            user_profile: User's onboarding data containing:
                - business_type: str
                - industry: str
                - design_preference: str
                - monthly_volume: str
                - packaging_needs: List[str]
        
        Returns:
            List of recommended products with match scores and reasoning
        """
        
        # Build context-aware prompt
        prompt = self._build_recommendation_prompt(user_profile)
        
        try:
            # Generate recommendations using Gemini
            response = self.model.generate_content(prompt)
            
            # Parse JSON response
            recommendations = self._parse_gemini_response(response.text)
            
            return recommendations
            
        except Exception as e:
            print(f"Gemini API Error: {e}")
            # Fallback to rule-based recommendations
            return self._fallback_recommendations(user_profile)
    
    def _build_recommendation_prompt(self, profile: Dict) -> str:
        """Build AI prompt with user context and product catalog."""
        
        catalog_text = "\n".join([
            f"- **{p['name']}**: {p['description']} (Cocok untuk: {', '.join(p['ideal_for'])})"
            for p in self.product_catalog
        ])
        
        prompt = f"""
Kamu adalah AI Assistant untuk ARTEPIX Smart Packaging. Tugasmu adalah merekomendasikan produk kemasan terbaik untuk customer.

**Data Customer:**
- Tipe Bisnis: {profile.get('business_type', 'Unknown')}
- Industri: {profile.get('industry', 'Unknown')}
- Gaya Desain: {profile.get('design_preference', 'Minimalist')}
- Volume Bulanan: {profile.get('monthly_volume', '1-100')} pcs
- Kebutuhan: {', '.join(profile.get('packaging_needs', ['boxes']))}

**Produk Tersedia:**
{catalog_text}

**Instruksi:**
1. Pilih 3 produk yang PALING COCOK dengan profil customer
2. Urutkan dari yang paling relevan (Best Match pertama)
3. Berikan match score (0-100) untuk setiap produk
4. Jelaskan MENGAPA produk tersebut cocok (max 2 kalimat)

**Format Output (WAJIB JSON, tidak ada teks lain):**
[
  {{
    "product_id": "...",
    "product_name": "...",
    "match_score": 95,
    "reason": "Alasan singkat mengapa cocok",
    "is_best_match": true
  }},
  ...
]

HANYA RETURN JSON, TIDAK ADA PENJELASAN TAMBAHAN!
"""
        return prompt
    
    def _parse_gemini_response(self, response_text: str) -> List[Dict]:
        """Parse Gemini response and extract JSON."""
        try:
            # Try to find JSON array in response
            start_idx = response_text.find('[')
            end_idx = response_text.rfind(']') + 1
            
            if start_idx == -1 or end_idx == 0:
                raise ValueError("No JSON array found in response")
            
            json_text = response_text[start_idx:end_idx]
            recommendations = json.loads(json_text)
            
            # Validate and clean
            validated = []
            for rec in recommendations[:3]:  # Max 3 recommendations
                if all(k in rec for k in ['product_id', 'product_name', 'match_score', 'reason']):
                    validated.append({
                        'product_id': rec['product_id'],
                        'product_name': rec['product_name'],
                        'match_score': min(100, max(0, rec['match_score'])),
                        'reason': rec['reason'][:200],  # Limit length
                        'is_best_match': rec.get('is_best_match', False)
                    })
            
            return validated
            
        except Exception as e:
            print(f"Parse error: {e}")
            raise
    
    def _fallback_recommendations(self, profile: Dict) -> List[Dict]:
        """Simple rule-based recommendations as fallback."""
        business_type = profile.get('business_type', '')
        
        # Simple mapping
        if business_type == 'fnb':
            return [
                {"product_id": "pouch_standing", "product_name": "Standing Pouch dengan Zipper", "match_score": 85, "reason": "Cocok untuk produk makanan/minuman dengan zipper untuk kesegaran", "is_best_match": True},
                {"product_id": "softbox_eco", "product_name": "Eco Softbox", "match_score": 75, "reason": "Material ramah lingkungan untuk brand sustainable", "is_best_match": False},
            ]
        elif business_type == 'cosmetic':
            return [
                {"product_id": "hardbox_premium", "product_name": "Premium Hardbox", "match_score": 90, "reason": "Kemasan mewah untuk produk kecantikan premium", "is_best_match": True},
                {"product_id": "mailer_box", "product_name": "Minimalist Mailer Box", "match_score": 70, "reason": "Desain clean untuk skincare modern", "is_best_match": False},
            ]
        else:
            return [
                {"product_id": "mailer_box", "product_name": "Minimalist Mailer Box", "match_score": 80, "reason": "Solusi serbaguna untuk berbagai produk", "is_best_match": True},
                {"product_id": "corrugated_shipper", "product_name": "E-commerce Shipper Box", "match_score": 75, "reason": "Aman untuk pengiriman jarak jauh", "is_best_match": False},
            ]
