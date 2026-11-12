import 'package:app3/core/networking/api_endpoint.dart';
import 'package:app3/core/networking/dio_factory.dart';
import 'package:dio/dio.dart';

import '../model/checkout_model.dart';

class CheckoutRepo {

  static Future<dynamic> getCheckout() async {
    try {
      final res = await DioFactory.dio.get(ApiEndPoint.checkout);
      final data = res.data is Map ? res.data['data'] : null;
      if (res.statusCode == 200 && data is Map<String, dynamic>) {
        return CheckoutModel.fromJson(data);
      }
      return _extractError(res.data, 'Your cart is empty');
    } on DioException catch (e) {
      return _extractError(e.response?.data, 'Network error');
    } catch (e) {
      return 'Something went wrong';
    }
  }


  static Future<dynamic> getGovernorates() async {
    try {
      final res = await DioFactory.dio.get(ApiEndPoint.governorates);
      final data = res.data is Map ? res.data['data'] : null;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(GovernorateModel.fromJson)
            .toList();
      }
      return _extractError(res.data, 'Failed to load governorates');
    } on DioException catch (e) {
      return _extractError(e.response?.data, 'Network error');
    } catch (e) {
      return 'Something went wrong';
    }
  }

  /// بترجع id الأوردر (int) لو نجح، أو String فيها الخطأ.
  static Future<dynamic> placeOrder({
    required int governorateId,
    required String name,
    required String phone,
    required String address,
    String? email,
  }) async {
    try {
      final res = await DioFactory.dio.post(
        ApiEndPoint.placeOrder,
        data: {
          'governorate_id': governorateId,
          'name': name,
          'phone': phone,
          'address': address,
          if (email != null && email.isNotEmpty) 'email': email,
        },
      );
      final data = res.data is Map ? res.data['data'] : null;
      if (data is Map && data['id'] != null) {
        return int.tryParse(data['id'].toString()) ?? 0;
      }
      return _extractError(res.data, 'Something went wrong');
    } on DioException catch (e) {
      return _extractError(e.response?.data, 'Network error');
    } catch (e) {
      return 'Something went wrong';
    }
  }

  static String _extractError(dynamic data, String fallback) {
    if (data is Map) {
      final errors = data['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) {
          return first.first.toString().trim();
        }
      }
      final message = data['message']?.toString().trim();
      if (message != null && message.isNotEmpty) return message;
    }
    return fallback;
  }
}