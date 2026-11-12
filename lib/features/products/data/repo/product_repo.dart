import 'package:app3/core/networking/dio_helper.dart';
import '../model/product_model.dart';

class ProductRepo {
  Future<List<Product>> getProduct() async {
    try {
      final response = await DioHelper.getProduct(url: "products");
      final List<Product> products = [];
      if (response.statusCode == 200 && response.data != null) {
        final list = response.data['products'] as List? ?? [];
        for (var item in list) {
          if (item is Map<String, dynamic>) {
            products.add(Product.fromJson(item));
          }
        }
      }
      return products;
    } catch (e) {
      rethrow;
    }
  }
}
