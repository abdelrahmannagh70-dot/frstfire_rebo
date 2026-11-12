import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../model/checkout_model.dart';
import '../repo/checkout_repo.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutLoading());

  CheckoutModel? checkout;
  List<GovernorateModel> governorates = [];

  Future<void> load() async {
    emit(CheckoutLoading());
    final results = await Future.wait<dynamic>([
      CheckoutRepo.getCheckout(),
      CheckoutRepo.getGovernorates(),
    ]);
    final c = results[0];
    final g = results[1];
    if (c is CheckoutModel) {
      checkout = c;
      governorates = g is List<GovernorateModel> ? g : [];
      emit(CheckoutLoaded());
    } else {
      emit(CheckoutError(c.toString()));
    }
  }

  Future<void> placeOrder({
    required int governorateId,
    required String name,
    required String phone,
    required String address,
    String? email,
  }) async {
    emit(PlaceOrderLoading());
    final res = await CheckoutRepo.placeOrder(
      governorateId: governorateId,
      name: name,
      phone: phone,
      address: address,
      email: email,
    );
    if (res is int) {
      emit(PlaceOrderSuccess(res));
    } else {
      emit(PlaceOrderError(res.toString()));
    }
  }
}