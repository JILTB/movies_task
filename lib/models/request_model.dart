import 'package:dio/dio.dart';

enum MethodType { get, post, download, upload, delete }

abstract class RequestModel {
  MethodType get type;

  String get path;

  int get timeout => 20000;

  Map<String, Object>? get queryParameters => null;

  Object? get urlParameter => null;

  Object? get body => null;

  String? get filePath => null;

  ProgressCallback? get onReceiveProgress => null;

  ProgressCallback? get onSendProgress => null;

  CancelToken? get cancelToken => null;
}
