import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:l/l.dart';
import 'package:path/path.dart';

class HttpClient {
  static const String extraSpoofAuthToken = 'spoof_auth_token';
  static const String headerDeviceId = 'x-device-id';

  HttpClient({required String baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          receiveTimeout: const Duration(seconds: 20),
          connectTimeout: const Duration(seconds: 20),
          contentType: Headers.jsonContentType,
          headers: {HttpHeaders.acceptHeader: 'application/json'},
        ),
      ) {
    _addInterceptorsToDio(_dio);
  }

  final Dio _dio;

  final _dios = <String, Dio>{};

  set baseUrl(String? baseUrl) {
    if (_dio.options.baseUrl != baseUrl) {
      _dio.options = _dio.options.copyWith(baseUrl: baseUrl);
    }
  }

  void _addInterceptorsToDio(Dio dio) =>
      dio.interceptors..add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (kDebugMode) {
              l.i('HttpClient->requestUrl: ${options.uri}');
            }
            handler.next(options);
          },
        ),
      );

  Dio _getDioForBaseUrl(String? baseUrl) {
    if (baseUrl == null) {
      return _dio;
    }
    Dio? dio = _dios[baseUrl];
    if (dio == null) {
      dio = Dio(_dio.options.copyWith(baseUrl: baseUrl));
      _addInterceptorsToDio(dio);
      _dios[baseUrl] = dio;
    }
    return dio;
  }

  Future<Options> _createRequestOptions({
    int? timeout,
    String? authToken,
    Map<String, dynamic>? extra,
  }) async {
    if (timeout == null && authToken == null) {
      return Options();
    }
    return Options(
      sendTimeout: timeout?.toMillisecondsDuration(),
      receiveTimeout: timeout?.toMillisecondsDuration(),
      headers: {
        if (authToken != null) HttpHeaders.authorizationHeader: authToken,
      },
      extra: extra,
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    String? baseUrl,
    String? authToken,
    Map<String, dynamic>? queryParameters,
    int? timeout,
    Map<String, dynamic>? extra,
  }) async {
    final options = await _createRequestOptions(
      timeout: timeout,
      authToken: authToken,
      extra: extra,
    );
    return _getDioForBaseUrl(
      baseUrl,
    ).get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(
    String path, {
    String? baseUrl,
    String? authToken,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    int? timeout,
  }) async {
    final options = await _createRequestOptions(
      timeout: timeout,
      authToken: authToken,
    );
    return _getDioForBaseUrl(baseUrl).post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T?>> download<T>(
    String path,
    String? savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    String? baseUrl,
    String? authToken,
    Map<String, dynamic>? queryParameters,
    int? timeout,
  }) async {
    final options = await _createRequestOptions(
      timeout: timeout,
      authToken: authToken,
    );
    return _getDioForBaseUrl(baseUrl).download(
          path,
          savePath,
          queryParameters: queryParameters,
          options: options,
          onReceiveProgress: onReceiveProgress,
          cancelToken: cancelToken,
        )
        as FutureOr<Response<T?>>;
  }

  Future<Response<T>> upload<T>(
    String path,
    String filePath, {
    String? baseUrl,
    String? authToken,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    int? timeout,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final options = await _createRequestOptions(
      timeout: timeout,
      authToken: authToken,
    );
    final formData = FormData.fromMap({
      if (data is Map) ...data as Map<String, dynamic>,
      'file': MultipartFile.fromStream(
        () => File(filePath).openRead(),
        File(filePath).lengthSync(),
        filename: basename(filePath),
      ),
    });
    return _getDioForBaseUrl(baseUrl).post(
      path,
      data: formData,
      queryParameters: queryParameters,
      options: options,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    String? baseUrl,
    String? authToken,
    Map<String, dynamic>? queryParameters,
    int? timeout,
  }) async {
    final options = await _createRequestOptions(
      timeout: timeout,
      authToken: authToken,
    );
    return _getDioForBaseUrl(
      baseUrl,
    ).delete(path, queryParameters: queryParameters, options: options);
  }
}

extension DurationMappers on int {
  Duration toMillisecondsDuration() => Duration(milliseconds: this);
}
