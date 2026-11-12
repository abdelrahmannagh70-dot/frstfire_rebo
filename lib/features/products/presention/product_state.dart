part of 'product_cubit.dart';

@immutable
sealed class ProductState {
  const ProductState();
}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductSuccess extends ProductState {
  final List<Product> products;

  const ProductSuccess({required this.products});
}

final class ProductError extends ProductState {
  final String error;

  const ProductError({required this.error});
}
