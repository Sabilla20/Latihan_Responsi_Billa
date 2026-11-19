class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;
  final int ratingCount;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    required this.ratingCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rating = (json['rating'] as Map?) ?? {};
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: ((rating['rate'] ?? 0) as num).toDouble(),
      ratingCount: ((rating['count'] ?? 0) as num).toInt(),
    );
  }

  /// Dipakai untuk menyimpan ke Hive.
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'image': image,
        'rating': {'rate': rating, 'count': ratingCount},
      };

  factory Product.fromMap(Map<dynamic, dynamic> map) {
    return Product.fromJson(Map<String, dynamic>.from(map).map((key, value) {
      if (value is Map) return MapEntry(key, Map<String, dynamic>.from(value));
      return MapEntry(key, value);
    }));
  }
}
