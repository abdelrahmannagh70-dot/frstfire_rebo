class CheckoutItemModel {
  final int itemId;
  final String name;
  final int quantity;
  final String total;

  CheckoutItemModel({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.total,
  });

  factory CheckoutItemModel.fromJson(Map<String, dynamic> json) =>
      CheckoutItemModel(
        itemId: json['item_id'] ?? 0,
        name: json['item_product_name']?.toString() ?? '',
        quantity: json['item_quantity'] ?? 1,
        total: json['item_total']?.toString() ?? '0',
      );
}

class CheckoutModel {
  final String userName;
  final String? phone;
  final String? address;
  final String total;
  final List<CheckoutItemModel> items;

  CheckoutModel({
    required this.userName,
    required this.phone,
    required this.address,
    required this.total,
    required this.items,
  });

  factory CheckoutModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map ? json['user'] as Map : {};
    return CheckoutModel(
      userName: user['user_name']?.toString() ?? '',
      phone: user['phone']?.toString(),
      address: user['address']?.toString(),
      total: json['total']?.toString() ?? '0',
      items: (json['cart_items'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(CheckoutItemModel.fromJson)
          .toList(),
    );
  }
}

class GovernorateModel {
  final int id;
  final String name;

  GovernorateModel({required this.id, required this.name});

  factory GovernorateModel.fromJson(Map<String, dynamic> json) =>
      GovernorateModel(
        id: json['id'] ?? 0,
        name: json['governorate_name_en']?.toString() ?? '',
      );
}