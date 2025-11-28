import '../../data/models/product/paginated_products_response_model.dart';

abstract class ProductRepository {
  Future<PaginatedProductsResponseModel> getProducts({
    int page = 1,
    int pageSize = 10,
    String? searchTerm,
    String? sortBy,
    String? sortOrder,
    double? minPrice,
    double? maxPrice,
    String? provider,
  });

  Future<Map<String, dynamic>> syncProducts();
}
