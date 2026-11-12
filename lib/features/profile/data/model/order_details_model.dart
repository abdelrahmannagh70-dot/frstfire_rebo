class OrderProductModel {
  final int productId;
  final String name;
  final String price;
  final num discount;
  final String priceAfterDiscount;
  final int quantity;
  final String total;

  OrderProductModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.discount,
    required this.priceAfterDiscount,
    required this.quantity,
    required this.total,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) =>
      OrderProductModel(
        productId: json['product_id'] is int
            ? json['product_id'] as int
            : int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
        name: json['product_name']?.toString() ?? '',
        price: json['product_price']?.toString() ?? '0',
        discount: json['product_discount'] is num
            ? json['product_discount'] as num
            : num.tryParse(json['product_discount']?.toString() ?? '0') ?? 0,
        priceAfterDiscount:
            json['product_price_after_discount']?.toString() ?? '0',
        quantity: json['order_product_quantity'] is int
            ? json['order_product_quantity'] as int
            : int.tryParse(json['order_product_quantity']?.toString() ?? '1') ?? 1,
        total: json['product_total']?.toString() ?? '0',
      );
}

class OrderDetailsModel {
  final int id;
  final String orderCode;
  final String orderDate;
  final String status;
  final String name;
  final String phone;
  final String address;
  final String governorate;
  final String subTotal;
  final String? tax;
  final num discount;
  final String total;
  final String? notes;
  final List<OrderProductModel> products;

  OrderDetailsModel({
    required this.id,
    required this.orderCode,
    required this.orderDate,
    required this.status,
    required this.name,
    required this.phone,
    required this.address,
    required this.governorate,
    required this.subTotal,
    required this.tax,
    required this.discount,
    required this.total,
    required this.notes,
    required this.products,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        id: json['id'] is int
            ? json['id'] as int
            : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        orderCode: json['order_code']?.toString() ?? '',
        orderDate: json['order_date']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        governorate: json['governorate']?.toString() ?? '',
        subTotal: json['sub_total']?.toString() ?? '0',
        tax: json['tax']?.toString(),
        discount: json['discount'] is num
            ? json['discount'] as num
            : num.tryParse(json['discount']?.toString() ?? '0') ?? 0,
        total: json['total']?.toString() ?? '0',
        notes: json['notes']?.toString(),
        products: (json['order_products'] as List? ?? [])
            .map((e) => OrderProductModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
