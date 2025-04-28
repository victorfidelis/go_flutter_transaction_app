import 'package:dio/dio.dart';

class DioConfig {
  static Dio getDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "http://localhost:8080",
        sendTimeout: Duration(seconds: 180),
        connectTimeout: Duration(seconds: 180),
      ),
    );

    return dio;
  }
}
