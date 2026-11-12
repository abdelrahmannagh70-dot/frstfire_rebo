
import 'package:app3/core/networking/api_error_handler.dart';
import 'package:app3/features/products/data/model/product_model.dart';
import 'package:app3/features/products/data/repo/product_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit([ProductRepo? repo])
      : productRepo = repo ?? ProductRepo(),
        super(ProductInitial());

  final ProductRepo productRepo;

  Future<void> getProduct() async {
    emit(ProductLoading());

    try {
      final response = await productRepo.getProduct();

      emit(ProductSuccess(products: response));

    } on DioException catch (e) {
      final errer=ApiErrorHandler.handleDioException(e);
      emit(ProductError(error: errer));

    } catch (e) {
      emit(ProductError(error: e.toString()));
    }
  }
}
