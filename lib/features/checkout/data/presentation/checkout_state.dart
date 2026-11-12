part of 'checkout_cubit.dart';

@immutable
sealed class CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutLoaded extends CheckoutState {}

final class CheckoutError extends CheckoutState {
  final String message;
  CheckoutError(this.message);
}

final class PlaceOrderLoading extends CheckoutState {}

final class PlaceOrderSuccess extends CheckoutState {
  final int orderId;
  PlaceOrderSuccess(this.orderId);
}

final class PlaceOrderError extends CheckoutState {
  final String message;
  PlaceOrderError(this.message);
}