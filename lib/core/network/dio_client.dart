import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../constants/app_constants.dart';

@lazySingleton
class DioClient {
  late final Dio _dio;

  // Simple in-memory cache for GET responses
  final Map<String, _CachedResponse> _getCache = {};
  // Default cache TTL
  final Duration _defaultTtl = const Duration(seconds: 60);

  DioClient() {
    _dio = Dio();
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      connectTimeout: AppConstants.connectionTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: false, // keep concise in debug
          requestHeader: false,
          responseHeader: false,
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, handler) {
          // Retry once on timeout errors
          if (_isTimeout(error) && error.requestOptions.extra['retried'] != true) {
            final opts = error.requestOptions;
            opts.extra = Map<String, dynamic>.from(opts.extra)..['retried'] = true;
            _dio
                .fetch(opts)
                .then((r) => handler.resolve(r))
                .catchError((e) => handler.next(e));
            return;
          }
          handler.next(error);
        },
      ),
    );
  }

  bool _isTimeout(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout;
  }

  String _cacheKey(String path, Map<String, dynamic>? query) {
    if (query == null || query.isEmpty) return path;
    final sorted = Map<String, dynamic>.fromEntries(
      query.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return '$path?${sorted.entries.map((e) => '${e.key}=${e.value}').join('&')}';
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    Duration? cacheTtl,
    bool forceRefresh = false,
  }) async {
    final key = _cacheKey(path, queryParameters);

    // Serve from cache if valid
    if (!forceRefresh) {
      final cached = _getCache[key];
      if (cached != null && DateTime.now().isBefore(cached.expiresAt)) {
        return Response<T>(
          requestOptions: RequestOptions(path: path),
          data: cached.data as T?,
          statusCode: 200,
        );
      }
    }

    final resp = await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );

    // Cache successful GETs
    if (resp.statusCode == 200) {
      _getCache[key] = _CachedResponse(
        data: resp.data,
        expiresAt: DateTime.now().add(cacheTtl ?? _defaultTtl),
      );
    }

    return resp;
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

class _CachedResponse {
  final Object? data;
  final DateTime expiresAt;
  _CachedResponse({required this.data, required this.expiresAt});
}
