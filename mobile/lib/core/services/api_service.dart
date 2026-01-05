import 'package:dio/dio.dart';
import 'storage_service.dart';

class ApiService {
  final Dio _dio;
  final StorageService _storageService;

  ApiService(this._storageService)
      : _dio = Dio(BaseOptions(
          baseUrl: 'http://72.61.215.223:8000/api/v1',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Handle global errors (e.g. 401 Unauthorized -> Logout)
          return handler.next(e);
        },
      ),
    );
  }

  Dio get client => _dio;

  // HTTP Methods for convenience
  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> put(String path,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters}) async {
    return await _dio.put(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}
