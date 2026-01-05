import 'package:dio/dio.dart';
import 'api_service.dart';
import 'storage_service.dart';

class OnboardingService {
  final ApiService _apiService;
  final StorageService _storageService;

  OnboardingService(this._apiService, this._storageService);

  /// Save onboarding profile to backend after user logs in
  Future<Map<String, dynamic>> saveProfile({
    required String businessType,
    required String industry,
    required List<String> packagingNeeds,
    required String monthlyVolume,
    required String designPreference,
  }) async {
    try {
      final response = await _apiService.post(
        '/onboarding/save',
        data: {
          'business_type': businessType,
          'industry': industry,
          'packaging_needs': packagingNeeds,
          'monthly_volume': monthlyVolume,
          'design_preference': designPreference,
        },
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to save onboarding profile: $e');
    }
  }

  /// Get user's onboarding profile
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final response = await _apiService.get('/onboarding/profile');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Profile not found - user hasn't completed onboarding
        return null;
      }
      rethrow;
    }
  }

  /// Track user behavior for analytics
  Future<void> trackBehavior(
      String eventType, Map<String, dynamic> eventData) async {
    try {
      await _apiService.put(
        '/onboarding/profile/behavior',
        queryParameters: {'event_type': eventType},
        data: eventData,
      );
    } catch (e) {
      // Silent fail for analytics - don't block user flow
      print('Failed to track behavior: $e');
    }
  }

  /// Save onboarding data temporarily (before login)
  Future<void> saveTempOnboardingData(Map<String, dynamic> data) async {
    await _storageService.saveString('temp_onboarding', data.toString());
  }

  /// Get temporary onboarding data
  Future<String?> getTempOnboardingData() async {
    return await _storageService.getString('temp_onboarding');
  }

  /// Clear temporary onboarding data
  Future<void> clearTempOnboardingData() async {
    await _storageService.deleteKey('temp_onboarding');
  }
}
