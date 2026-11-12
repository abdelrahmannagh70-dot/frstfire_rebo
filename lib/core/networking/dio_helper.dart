import 'package:dio/dio.dart';

class DioHelper {
  static Dio? _dio;

  static Dio get dio {
    if (_dio == null) {
      init();
    }
    return _dio!;
  }

  static void init() {
    _dio = Dio(
      BaseOptions(
        receiveDataWhenStatusError: true,
        baseUrl: 'https://dummyjson.com/',
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  static Future<Response> getProduct({required String url}) async {
    return await dio.get(url);
  }
}
