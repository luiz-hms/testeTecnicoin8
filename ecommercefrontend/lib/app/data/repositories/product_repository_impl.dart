import 'package:ecommercefrontend/app/core/rest_client/rest_client.dart';
import 'package:ecommercefrontend/app/core/rest_client/rest_client_exception.dart';
import 'package:ecommercefrontend/app/core/helpers/constants/constants.dart';
import 'package:ecommercefrontend/app/data/models/product/paginated_products_response_model.dart';
import 'package:ecommercefrontend/app/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RestClient _restClient;

  ProductRepositoryImpl({required RestClient restClient})
    : _restClient = restClient;

  @override
  Future<PaginatedProductsResponseModel> getProducts({
    int page = 1,
    int pageSize = 10,
    String? searchTerm,
    String? sortBy,
    String? sortOrder,
    double? minPrice,
    double? maxPrice,
    String? provider,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
        if (searchTerm != null && searchTerm.isNotEmpty)
          'searchTerm': searchTerm,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
        if (minPrice != null) 'minPrice': minPrice.toString(),
        if (maxPrice != null) 'maxPrice': maxPrice.toString(),
        if (provider != null) 'provider': provider,
      };

      final result = await _restClient.unauth().get(
        Constants.API_PRODUCTS,
        queryParameters: queryParams,
      );

      return PaginatedProductsResponseModel.fromJson(result.data);
    } on RestClientException catch (e) {
      throw e;
    }
  }

  @override
  Future<Map<String, dynamic>> syncProducts() async {
    try {
      final result = await _restClient.auth().post(Constants.API_PRODUCTS_SYNC);
      return result.data as Map<String, dynamic>;
    } on RestClientException catch (e) {
      throw e;
    }
  }
}
