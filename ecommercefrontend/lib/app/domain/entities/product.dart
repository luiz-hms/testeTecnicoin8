class Product {
  final String id;
  final String name;
  final double price;
  final double oldPrice;
  final String? imageUrl;
  final String? description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.oldPrice,
    this.imageUrl,
    this.description,
  });

  Product copyWith({
    String? id,
    String? name,
    double? price,
    double? oldPrice,
    String? imageUrl,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }
}
