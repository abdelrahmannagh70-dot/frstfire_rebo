part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}


final class GetProfileLoading extends ProfileState {}

final class GetProfileSuccess extends ProfileState {
  final ProfileDataModel? profileDate;

  GetProfileSuccess(this.profileDate);
}

final class GetProfileError extends ProfileState {}

final class UpdateProfileLoading extends ProfileState {}

final class UpdateProfileSuccess extends ProfileState {}

final class UpdateProfileError extends ProfileState {
  final String message;
  UpdateProfileError(this.message);
}

final class ChangePasswordLoading extends ProfileState {}

final class ChangePasswordSuccess extends ProfileState {}

final class ChangePasswordError extends ProfileState {
  final String message;
  ChangePasswordError(this.message);
}


final class GetOrdersLoading extends ProfileState {}

final class GetOrdersSuccess extends ProfileState {
  final List<OrderModel> orders;

  GetOrdersSuccess(this.orders);
}

final class GetOrdersError extends ProfileState {
  final String message;
  GetOrdersError(this.message);
}


final class GetOrderDetailsLoading extends ProfileState {}

final class GetOrderDetailsSuccess extends ProfileState {
  final OrderDetailsModel details;

  GetOrderDetailsSuccess(this.details);
}

final class GetOrderDetailsError extends ProfileState {
  final String message;
  GetOrderDetailsError(this.message);
}