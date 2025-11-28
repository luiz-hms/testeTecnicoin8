import '../../../domain/entities/product.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;

  // Brazilian provider fields
  final String? category;
  final String? material;
  final String? department;

  // European provider fields
  final List<String>? gallery;
  final bool? hasDiscount;
  final double? discountValue;

  // Common fields
  final int stock;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.category,
    this.material,
    this.department,
    this.gallery,
    this.hasDiscount,
    this.discountValue,
    required this.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String?,
      material: json['material'] as String?,
      department: json['department'] as String?,
      gallery: (json['gallery'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      hasDiscount: json['hasDiscount'] as bool?,
      discountValue: json['discountValue'] != null
          ? (json['discountValue'] as num).toDouble()
          : null,
      stock: json['stock'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'material': material,
      'department': department,
      'gallery': gallery,
      'hasDiscount': hasDiscount,
      'discountValue': discountValue,
      'stock': stock,
    };
  }

  // Convert ProductModel to Product entity for use with CheckoutCubit
  Product toProduct() {
    return Product(
      id: id,
      name: name,
      price: price,
      oldPrice: 0, // ProductModel doesn't have oldPrice, defaulting to 0
      imageUrl: imageUrl,
      description: description,
    );
  }
}
