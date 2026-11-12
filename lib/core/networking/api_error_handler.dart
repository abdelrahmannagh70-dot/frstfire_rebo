
import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please try again.';

      case DioExceptionType.sendTimeout:
        return 'Sending request took too long.';

      case DioExceptionType.receiveTimeout:
        return 'Receiving response took too long.';

      case DioExceptionType.badCertificate:
        return 'Invalid server certificate.';

      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';

      case DioExceptionType.transformTimeout:
        return 'Processing server response took too long.';

      case DioExceptionType.unknown:
        return 'Something went wrong. Please try again.';
    }
  }

  static String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';

      case 401:
        return 'Unauthorized. Please login again.';

      case 403:
        return 'Access forbidden.';

      case 404:
        return 'Requested resource not found.';

      case 405:
        return 'Method not allowed.';

      case 408:
        return 'Request timeout. Please try again.';

      case 409:
        return 'Conflict occurred.';

      case 422:
        return 'Validation error. Please check your data.';

      case 429:
        return 'Too many requests. Please try again later.';

      case 500:
        return 'Internal server error.';

      case 502:
        return 'Bad gateway.';

      case 503:
        return 'Service unavailable.';

      case 504:
        return 'Gateway timeout.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
