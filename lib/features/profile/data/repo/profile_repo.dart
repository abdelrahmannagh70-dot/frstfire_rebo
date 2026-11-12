import 'dart:io';

import 'package:app3/core/networking/api_endpoint.dart';
import 'package:app3/core/networking/dio_factory.dart';
import 'package:app3/core/services/local/local_Helper.dart';
import 'package:app3/core/utils/app.constans.dart';
import 'package:dio/dio.dart';

import '../model/order_details_model.dart';
import '../model/order_model.dart';
import '../model/profile_response_model.dart';

class ProfileRepo {

  static const bool _useMock = true;

  static final List<Map<String, dynamic>> _mockOrders = [
    {
      "id": 51,
      "order_code": "00051",
      "order_date": "2023-08-14",
      "status": "New",
      "total": "130.51",
    },
    {
      "id": 47,
      "order_code": "b1U9muD3w9PLGvcCeWGw",
      "order_date": "2023-07-11",
      "status": "Pending",
      "total": "3244.00",
    },
    {
      "id": 8,
      "order_code": "FxiTNLkdrUn97VUvqACV",
      "order_date": "2023-06-20",
      "status": "Shipping",
      "total": "3086.00",
    },
  ];

  static final Map<String, dynamic> _mockDetails = {
    "id": 52,
    "order_code": "00052",
    "total": "594.03",
    "name": "mohammed",
    "email": "m@m.m",
    "address": "tanta",
    "governorate": "Menofia",
    "phone": "0114258055",
    "tax": null,
    "sub_total": "594.03",
    "order_date": "2023-08-14",
    "status": "New",
    "notes": null,
    "discount": 0,
    "order_products": [
      {
        "order_product_id": 12,
        "product_id": 2,
        "product_name": "doloremque",
        "product_price": "421.00",
        "product_discount": 69,
        "product_price_after_discount": 130.51,
        "order_product_quantity": 3,
        "product_total": "391.53",
      },
      {
        "order_product_id": 13,
        "product_id": 3,
        "product_name": "nemo",
        "product_price": "225.00",
        "product_discount": 10,
        "product_price_after_discount": 202.5,
        "order_product_quantity": 1,
        "product_total": "202.50",
      },
    ],
  };

  static Future<ProfileDataModel?> getProfileData() async {
    try {
      final response = await DioFactory.dio.get(ApiEndPoint.Profile);
      if (response.statusCode == 200) {
        ProfileResponseModel profileData =
        ProfileResponseModel.fromJson(response.data);
        return profileData.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String?> updateProfile({
    required String name,
    required String phone,
    required String city,
    required String address,
    File? image,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'phone': phone,
        'city': city,
        'address': address,
        if (image != null)
          'image': await MultipartFile.fromFile(
            image.path,
            filename: image.path.split(Platform.pathSeparator).last,
          ),
      });

      final response = await DioFactory.dio.post(
        ApiEndPoint.UpdateProfile,
        data: formData,
      );

      if (response.statusCode == 200) return null;
      return _extractError(response.data, 'Something went wrong');
    } on DioException catch (e) {
      return _extractError(e.response?.data, 'Network error');
    } catch (e) {
      return 'Something went wrong';
    }
  }

  static Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await DioFactory.dio.post(
        ApiEndPoint.ChangePassword,
        data: FormData.fromMap({
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': confirmPassword,
        }),
      );

      if (response.statusCode == 200) return null;
      return _extractError(response.data, 'Something went wrong');
    } on DioException catch (e) {
      return _extractError(e.response?.data, 'Network error');
    } catch (e) {
      return 'Something went wrong';
    }
  }

  static Future<dynamic> getOrders() async {
    try {

      if (_useMock) {
        await Future.delayed(const Duration(milliseconds: 600));
        return _mockOrders.map((e) => OrderModel.fromJson(e)).toList();
      }


      if (localHelper.prefs == null) {
        await localHelper.init();
      }
      final rawToken = localHelper.prefs?.getString(AppConstans.userToken) ??
          localHelper.prefs?.get(AppConstans.userToken)?.toString();

      if (rawToken == null || rawToken.trim().isEmpty) {
        return 'Please login to view your orders';
      }

      final response = await DioFactory.dio.get(ApiEndPoint.OrderHistory);
      if (response.statusCode == 200) {
        final rawData = response.data;
        final data = rawData is Map ? rawData['data'] : null;

        final dynamic listData = data is Map ? data['orders'] : data;
        final List list = listData is List ? listData : [];

        return list
            .whereType<Map<String, dynamic>>()
            .map((e) => OrderModel.fromJson(e))
            .toList();
      }
      return _extractError(response.data, 'Failed to load orders');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return 'Session expired or unauthenticated. Please login again.';
      }
      return _extractError(
        e.response?.data,
        'Network error. Please check your connection.',
      );
    } catch (e) {
      return 'Something went wrong while fetching orders.';
    }
  }

  static Future<dynamic> getOrderDetails(int id) async {
    try {

      if (_useMock) {
        await Future.delayed(const Duration(milliseconds: 600));
        return OrderDetailsModel.fromJson(_mockDetails);
      }

      if (localHelper.prefs == null) {
        await localHelper.init();
      }
      final rawToken = localHelper.prefs?.getString(AppConstans.userToken) ??
          localHelper.prefs?.get(AppConstans.userToken)?.toString();

      if (rawToken == null || rawToken.trim().isEmpty) {
        return 'Please login to view order details';
      }


      final response =
      await DioFactory.dio.get('${ApiEndPoint.OrderHistory}$id');
      if (response.statusCode == 200) {
        final rawData = response.data;
        final data = rawData is Map ? rawData['data'] : null;
        if (data is Map<String, dynamic>) {
          return OrderDetailsModel.fromJson(data);
        }
      }
      return _extractError(response.data, 'Failed to load order details');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return 'Session expired or unauthenticated. Please login again.';
      }
      return _extractError(
        e.response?.data,
        'Network error. Please check your connection.',
      );
    } catch (e) {
      return 'Something went wrong while fetching order details.';
    }
  }

  static String _extractError(dynamic data, String fallback) {
    if (data is Map) {
      final errors = data['errors'] ?? data['error'];
      if (errors is Map && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) {
          return first.first.toString().trim();
        }
        return first.toString().trim();
      } else if (errors is List && errors.isNotEmpty) {
        return errors.first.toString().trim();
      } else if (errors is String && errors.isNotEmpty) {
        return errors.trim();
      }
      final message = data['message']?.toString().trim();
      if (message != null && message.isNotEmpty) return message;
    }
    return fallback;
  }
}