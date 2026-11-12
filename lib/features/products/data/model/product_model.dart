class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double? rating;
  final double? discountPercentage;
  final int? stock;
  final String? thumbnail;
  final String? brand;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    this.rating,
    this.discountPercentage,
    this.stock,
    this.thumbnail,
    this.brand,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble(),
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      stock: json['stock'] is int
          ? json['stock'] as int
          : int.tryParse(json['stock']?.toString() ?? '0'),
      thumbnail: json['thumbnail']?.toString(),
      brand: json['brand']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      if (rating != null) 'rating': rating,
      if (discountPercentage != null) 'discountPercentage': discountPercentage,
      if (stock != null) 'stock': stock,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (brand != null) 'brand': brand,
    };
  }
}
