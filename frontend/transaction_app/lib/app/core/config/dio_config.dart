import 'package:dio/dio.dart';

class DioConfig {
  static Dio get() {
    final dio = Dio(
      BaseOptions(
        // baseUrl: 'http://172.26.16.1:8080',
        baseUrl: 'http://localhost:8080',
        sendTimeout: Duration(seconds: 180),
        connectTimeout: Duration(seconds: 180),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    return dio;
  }
}
