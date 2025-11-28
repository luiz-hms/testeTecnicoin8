import 'package:bloc/bloc.dart';
import 'package:ecommercefrontend/app/domain/repositories/product_repository.dart';

import '../../../data/models/product/product_filters.dart';
import 'product_state.dart';
import 'product_sort_by.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;

  ProductCubit({required ProductRepository productRepository})
    : _productRepository = productRepository,
      super(const ProductInitial());

  Future<void> loadProducts({
    int page = 1,
    int pageSize = 10,
    String? searchTerm,
    ProductSortBy? sortBy,
    ProductFilters? filters,
  }) async {
    emit(
      ProductUpdated(
        products: state.products,
        currentPage: state.currentPage,
        totalPages: state.totalPages,
        total: state.total,
        status: ProductStatus.loading,
        searchTerm: searchTerm,
      ),
    );

    try {
      // Map SortBy to API params
      String? apiSortBy;
      String? apiSortOrder;

      if (sortBy != null) {
        switch (sortBy) {
          case ProductSortBy.priceLowToHigh:
            apiSortBy = 'price';
            apiSortOrder = 'ASC';
            break;
          case ProductSortBy.priceHighToLow:
            apiSortBy = 'price';
            apiSortOrder = 'DESC';
            break;
          case ProductSortBy.nameAZ:
            apiSortBy = 'name';
            apiSortOrder = 'ASC';
            break;
          case ProductSortBy.nameZA:
            apiSortBy = 'name';
            apiSortOrder = 'DESC';
            break;
        }
      }

      final response = await _productRepository.getProducts(
        page: page,
        pageSize: pageSize,
        searchTerm: searchTerm,
        sortBy: apiSortBy,
        sortOrder: apiSortOrder,
        minPrice: filters?.minPrice,
        maxPrice: filters?.maxPrice,
        provider: filters?.provider,
      );

      emit(
        ProductUpdated(
          products: response.data,
          currentPage: response.page,
          totalPages: response.totalPages,
          total: response.total,
          status: ProductStatus.loaded,
          searchTerm: searchTerm,
        ),
      );
    } catch (e) {
      emit(
        ProductUpdated(
          products: [],
          currentPage: 1,
          totalPages: 1,
          total: 0,
          status: ProductStatus.error,
          errorMessage: e.toString(),
          searchTerm: searchTerm,
        ),
      );
    }
  }

  /// Sincronizar produtos da API externa
  Future<void> syncProducts() async {
    if (state is ProductUpdated) {
      emit((state as ProductUpdated).copyWith(status: ProductStatus.loading));
    }

    try {
      await _productRepository.syncProducts();

      if (state is ProductUpdated) {
        emit(
          (state as ProductUpdated).copyWith(status: ProductStatus.syncSuccess),
        );
      }

      // Recarregar produtos após sincronização
      await loadProducts(page: state.currentPage, searchTerm: state.searchTerm);
    } catch (e) {
      if (state is ProductUpdated) {
        emit(
          (state as ProductUpdated).copyWith(
            status: ProductStatus.error,
            errorMessage: 'Erro ao sincronizar produtos: ${e.toString()}',
          ),
        );
      }
    }
  }

  /// Ir para próxima página
  Future<void> nextPage() async {
    if (state.currentPage < state.totalPages) {
      await loadProducts(
        page: state.currentPage + 1,
        searchTerm: state.searchTerm,
      );
    }
  }

  /// Ir para página anterior
  Future<void> previousPage() async {
    if (state.currentPage > 1) {
      await loadProducts(
        page: state.currentPage - 1,
        searchTerm: state.searchTerm,
      );
    }
  }

  /// Buscar produtos por termo
  Future<void> searchProducts(String searchTerm) async {
    await loadProducts(page: 1, searchTerm: searchTerm);
  }
}
