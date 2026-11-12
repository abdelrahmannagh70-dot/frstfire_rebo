import 'package:app3/core/networking/api_endpoint.dart';
import 'package:app3/core/services/local/local_Helper.dart';
import 'package:app3/core/utils/app.constans.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  static Dio? _dio;

  static Dio get dio {
    if (_dio == null) {
      init();
    }
    return _dio!;
  }

  static void init() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndPoint.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Ensure SharedPreferences instance is ready
          if (localHelper.prefs == null) {
            await localHelper.init();
          }

          final rawToken = localHelper.prefs?.getString(AppConstans.userToken) ??
              localHelper.prefs?.get(AppConstans.userToken)?.toString();

          if (rawToken != null && rawToken.trim().isNotEmpty) {
            // Strip any existing "Bearer " prefix to prevent duplicate "Bearer Bearer ..."
            final cleanToken = rawToken
                .trim()
                .replaceFirst(RegExp(r'^Bearer\s+', caseSensitive: false), '');

            if (cleanToken.isNotEmpty) {
              options.headers["Authorization"] = "Bearer $cleanToken";
            } else {
              options.headers.remove("Authorization");
            }
          } else {
            options.headers.remove("Authorization");
          }

          handler.next(options);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            debugPrint(
              "[Dio Error] ${e.requestOptions.method} ${e.requestOptions.uri} -> ${e.response?.statusCode}: ${e.message}",
            );
          }
          handler.next(e);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    _dio = dio;
  }
}
