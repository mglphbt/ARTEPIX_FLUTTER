import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';

class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthService(this._apiService, this._storageService);

  Future<void> login(String email, String password) async {
    try {
      final response = await _apiService.client.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final token = response.data['access_token'];
      if (token != null) {
        await _storageService.saveToken(token);
      } else {
        throw Exception('Token not found in response');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> loginWithGoogle(String idToken) async {
    try {
      final response = await _apiService.client.post(
        '/auth/google',
        data: {
          'id_token': idToken,
        },
      );

      final token = response.data['access_token'];
      if (token != null) {
        await _storageService.saveToken(token);
      } else {
        throw Exception('Token not found in response');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> signup(String email, String password, String fullName) async {
    try {
      await _apiService.client.post(
        '/auth/signup',
        data: {
          'email': email,
          'password': password,
          'full_name': fullName,
        },
      );
      // Automatically login after signup optionally, or just return void
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
  }

  Future<bool> isAuthenticated() async {
    final token = await _storageService.getToken();
    return token != null;
  }

  Exception _handleError(dynamic e) {
    if (e is DioException) {
      if (e.response != null) {
        return Exception(e.response?.data['detail'] ?? 'Server Error');
      }
      return Exception('Network Error: ${e.message}');
    }
    return Exception(e.toString());
  }
}
