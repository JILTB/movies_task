import 'package:flutter/foundation.dart';

import 'package:l/l.dart';
import 'package:movies_task/models/request_model.dart';
import 'package:movies_task/services/network_services/http_client.dart';

abstract class BaseApi {
  BaseApi(this.httpClient);

  final HttpClient httpClient;

  String? get baseUrl => 'https://raw.githubusercontent.com/';

  @protected
  Future<T> makeRequest<T>(
    RequestModel model, {
    T Function(dynamic)? mapper,
    Map<String, Object>? extra,
  }) async {
    try {
      Object json;

      switch (model.type) {
        case MethodType.get:
          json =
              (await httpClient.get(
                model.path,
                queryParameters: model.queryParameters,
                timeout: model.timeout,
                baseUrl: baseUrl,
                extra: extra,
              )).data;
          break;
        case MethodType.post:
          json =
              (await httpClient.post(
                model.path,
                queryParameters: model.queryParameters,
                data: model.body,
                timeout: model.timeout,
                baseUrl: baseUrl,
              )).data;
          break;
        case MethodType.download:
          json =
              (await httpClient.download(
                model.path,
                model.filePath,
                queryParameters: model.queryParameters,
                timeout: model.timeout,
                baseUrl: baseUrl,
                onReceiveProgress: model.onReceiveProgress,
                cancelToken: model.cancelToken,
              )).data;
          break;
        case MethodType.upload:
          json =
              (await httpClient.upload(
                model.path,
                model.filePath!,
                queryParameters: model.queryParameters,
                data: model.body,
                timeout: model.timeout,
                baseUrl: baseUrl,
                onSendProgress: model.onSendProgress,
                cancelToken: model.cancelToken,
              )).data;
          break;
        case MethodType.delete:
          json =
              (await httpClient.delete(
                model.path,
                queryParameters: model.queryParameters,
                timeout: model.timeout,
                baseUrl: baseUrl,
              )).data;
      }
      if (mapper != null) {
        return mapper(json);
      } else {
        return json as T;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        l.e('Error on ${model.path}: ${e.toString()}');
      }
      return Future.error(e);
    } catch (e) {
      final error = 'Invalid response: $e';
      if (kDebugMode) {
        l.e('Error on ${model.path}: ${error.toString()}');
      }
      return Future.error(e);
    }
  }
}
