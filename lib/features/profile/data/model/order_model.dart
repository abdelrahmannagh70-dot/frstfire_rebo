class OrderModel {
  final int id;
  final String orderCode;
  final String orderDate;
  final String status;
  final String total;

  OrderModel({
    required this.id,
    required this.orderCode,
    required this.orderDate,
    required this.status,
    required this.total,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      orderCode: json['order_code']?.toString() ?? '',
      orderDate: json['order_date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      total: json['total']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_code': orderCode,
      'order_date': orderDate,
      'status': status,
      'total': total,
    };
  }
}
