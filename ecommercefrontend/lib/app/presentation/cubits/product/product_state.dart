import 'package:ecommercefrontend/app/data/models/product/product_model.dart';

enum ProductStatus { initial, loading, loaded, error, syncSuccess }

abstract class ProductState {
  final List<ProductModel> products;
  final int currentPage;
  final int totalPages;
  final int total;
  final ProductStatus status;
  final String? errorMessage;
  final String? searchTerm;

  const ProductState({
    required this.products,
    required this.currentPage,
    required this.totalPages,
    required this.total,
    required this.status,
    this.errorMessage,
    this.searchTerm,
  });
}

class ProductInitial extends ProductState {
  const ProductInitial()
    : super(
        products: const [],
        currentPage: 1,
        totalPages: 1,
        total: 0,
        status: ProductStatus.initial,
      );
}

class ProductUpdated extends ProductState {
  const ProductUpdated({
    required super.products,
    required super.currentPage,
    required super.totalPages,
    required super.total,
    required super.status,
    super.errorMessage,
    super.searchTerm,
  });

  ProductUpdated copyWith({
    List<ProductModel>? products,
    int? currentPage,
    int? totalPages,
    int? total,
    ProductStatus? status,
    String? errorMessage,
    String? searchTerm,
    bool clearError = false,
  }) {
    return ProductUpdated(
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }
}
