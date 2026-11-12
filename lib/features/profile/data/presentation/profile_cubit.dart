import 'dart:io';

import 'package:app3/features/profile/data/repo/profile_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/order_details_model.dart';
import '../model/order_model.dart';
import '../model/profile_response_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> getProfileData() async {
    emit(GetProfileLoading());
    final response = await ProfileRepo.getProfileData();
    if (response is ProfileDataModel) {
      emit(GetProfileSuccess(response));
    } else {
      emit(GetProfileError());
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String city,
    required String address,
    File? image,
  }) async {
    emit(UpdateProfileLoading());
    final error = await ProfileRepo.updateProfile(
      name: name,
      phone: phone,
      city: city,
      address: address,
      image: image,
    );
    if (error == null) {
      emit(UpdateProfileSuccess());
      getProfileData();
    } else {
      emit(UpdateProfileError(error));
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(ChangePasswordLoading());
    final error = await ProfileRepo.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    if (error == null) {
      emit(ChangePasswordSuccess());
    } else {
      emit(ChangePasswordError(error));
    }
  }


  Future<void> getOrders() async {
    emit(GetOrdersLoading());
    final response = await ProfileRepo.getOrders();
    if (response is List<OrderModel>) {
      emit(GetOrdersSuccess(response));
    } else {
      emit(GetOrdersError(response.toString()));
    }
  }

  Future<void> getOrderDetails(int id) async {
    emit(GetOrderDetailsLoading());
    final response = await ProfileRepo.getOrderDetails(id);
    if (response is OrderDetailsModel) {
      emit(GetOrderDetailsSuccess(response));
    } else {
      emit(GetOrderDetailsError(response.toString()));
    }
  }
}