import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioConfig {
  static Dio get() {
    final String baseUrl;
    if (kIsWeb) {
      baseUrl = 'http://localhost:8080';
    } else {
      baseUrl = 'http://10.0.2.2:8080';
    }
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        sendTimeout: Duration(seconds: 180),
        connectTimeout: Duration(seconds: 180),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    return dio;
  }
}
