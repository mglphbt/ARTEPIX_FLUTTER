/// Model for storing onboarding questionnaire data
class OnboardingData {
  final String industry; // From question 1
  final String designPreference; // From question 2
  final String productionScale; // From question 3

  OnboardingData({
    required this.industry,
    required this.designPreference,
    required this.productionScale,
  });

  /// Convert to API payload format
  Map<String, dynamic> toApiPayload() {
    // Map UI answers to backend schema
    return {
      'business_type': _mapIndustryToBusinessType(industry),
      'industry': industry,
      'packaging_needs': _inferPackagingNeeds(industry),
      'monthly_volume': _mapScaleToVolume(productionScale),
      'design_preference': _mapDesignStyle(designPreference),
    };
  }

  String _mapIndustryToBusinessType(String industry) {
    if (industry.contains('Makanan')) return 'fnb';
    if (industry.contains('Fashion')) return 'retail';
    if (industry.contains('Elektronik')) return 'ecommerce';
    if (industry.contains('Kecantikan')) return 'cosmetic';
    return 'other';
  }

  List<String> _inferPackagingNeeds(String industry) {
    // Infer based on industry
    if (industry.contains('Makanan')) return ['boxes', 'pouches'];
    if (industry.contains('Fashion')) return ['boxes', 'bags'];
    if (industry.contains('Elektronik')) return ['boxes', 'protective'];
    if (industry.contains('Kecantikan')) return ['boxes', 'tubes'];
    return ['boxes'];
  }

  String _mapScaleToVolume(String scale) {
    if (scale.contains('Startup')) return '1-100';
    if (scale.contains('Kecil')) return '100-500';
    if (scale.contains('Menengah')) return '500-1000';
    return '1000+';
  }

  String _mapDesignStyle(String style) {
    if (style.contains('Minimalis')) return 'minimalist';
    if (style.contains('Mewah')) return 'luxury';
    if (style.contains('Ramah Lingkungan')) return 'eco-friendly';
    if (style.contains('Ceria')) return 'vibrant';
    return 'minimalist';
  }

  /// Create from onboarding screen answers
  factory OnboardingData.fromAnswers(Map<int, String> answers) {
    return OnboardingData(
      industry: answers[0] ?? 'Other',
      designPreference: answers[1] ?? 'Minimalis & Bersih',
      productionScale: answers[2] ?? 'Startup (< 100 pcs)',
    );
  }
}
