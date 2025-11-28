import 'product_model.dart';

class PaginatedProductsResponseModel {
  final List<ProductModel> data;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  PaginatedProductsResponseModel({
    required this.data,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory PaginatedProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return PaginatedProductsResponseModel(
      data: (json['data'] as List<dynamic>)
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}
