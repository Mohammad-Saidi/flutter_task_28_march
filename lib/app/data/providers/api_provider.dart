import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

/// Custom exception for offline state.
class OfflineException implements Exception {
  final String message;
  const OfflineException([this.message = 'No internet connection']);
  @override
  String toString() => 'OfflineException: $message';
}

/// Wrapper around Dio for making HTTP requests to the Rick and Morty API.
/// Includes an interceptor that checks connectivity before requests.
class ApiProvider {
  static const String _baseUrl = 'https://rickandmortyapi.com/api/character';

  late final Dio _dio;

  ApiProvider() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Interceptor: check connectivity before each request.
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult.contains(ConnectivityResult.none) ||
              connectivityResult.isEmpty) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: const OfflineException(),
                type: DioExceptionType.connectionError,
              ),
            );
          }
          handler.next(options);
        },
        onError: (DioException error, handler) {
          // Convert socket exceptions to OfflineException
          if (error.error is SocketException) {
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: const OfflineException(),
                type: DioExceptionType.connectionError,
              ),
            );
          }
          handler.next(error);
        },
      ),
    );
  }

  /// Fetches a page of characters. Supports optional [name] and [status] filters.
  Future<Map<String, dynamic>> getCharacters({
    int page = 1,
    String? name,
    String? status,
  }) async {
    final Map<String, dynamic> queryParams = {'page': page};
    if (name != null && name.isNotEmpty) queryParams['name'] = name;
    if (status != null && status.isNotEmpty) queryParams['status'] = status;

    final response = await _dio.get('', queryParameters: queryParams);
    return response.data as Map<String, dynamic>;
  }
}
