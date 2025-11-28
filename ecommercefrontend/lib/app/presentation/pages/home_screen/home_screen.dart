import 'package:ecommercefrontend/app/core/depence_injection/service_locator.dart';
import 'package:ecommercefrontend/app/presentation/cubits/product/product_cubit.dart';
import 'package:ecommercefrontend/app/presentation/cubits/product/product_state.dart';
import 'package:ecommercefrontend/app/presentation/cubits/product/product_sort_by.dart';
import 'package:ecommercefrontend/app/presentation/widgets/appbar/custom_appbar/custom_appbar.dart';
import 'package:ecommercefrontend/app/presentation/cubits/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/appbar/drawer/custom_drawer.dart';
import '../../widgets/custom_carrousel/custom_carrousel.dart';
import '../../../data/models/product/product_model.dart';
import '../../widgets/product/product_sort_dropdown.dart';
import '../../widgets/product/pagination_bar.dart';
import '../../widgets/product/product_filter_modal.dart';
import '../../../data/models/product/product_filters.dart';
import '../../widgets/product/product_card.dart';

class HomeScreen extends StatelessWidget {
  final String? searchTerm;

  const HomeScreen({super.key, this.searchTerm});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ProductCubit>()..loadProducts(searchTerm: searchTerm),
      child: _HomeScreenContent(searchTerm: searchTerm),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  final String? searchTerm;

  const _HomeScreenContent({this.searchTerm});

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  ProductSortBy _currentSortBy = ProductSortBy.priceLowToHigh;
  ProductFilters _currentFilters = const ProductFilters();
  String? _currentSearchTerm;

  @override
  void initState() {
    super.initState();
    _currentSearchTerm = widget.searchTerm;
  }

  @override
  void didUpdateWidget(_HomeScreenContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload products if search term changed
    if (widget.searchTerm != oldWidget.searchTerm) {
      _currentSearchTerm = widget.searchTerm;
      context.read<ProductCubit>().loadProducts(
        page: 1,
        searchTerm: _currentSearchTerm,
        sortBy: _currentSortBy,
        filters: _currentFilters,
      );
    }
  }

  final List<String> orderOptions = [
    "Preço: menor → maior",
    "Preço: maior → menor",
    "Nome: A → Z",
    "Nome: Z → A",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final accentColor = (state is ThemeLoaded)
            ? state.theme.accentColor
            : const Color(0xFFFF6D00);

        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: Colors.grey[100],
            drawer: CustomDrawer(),
            floatingActionButton: FloatingActionButton(
              backgroundColor: accentColor,
              tooltip: "FILTROS",
              onPressed: () async {
                final result = await showDialog<ProductFilters>(
                  context: context,
                  builder: (context) => ProductFilterModal(
                    currentFilters: _currentFilters,
                    accentColor: accentColor,
                  ),
                );

                if (result != null) {
                  setState(() {
                    _currentFilters = result;
                  });
                  if (mounted) {
                    context.read<ProductCubit>().loadProducts(
                      page: 1,
                      searchTerm: _currentSearchTerm,
                      sortBy: _currentSortBy,
                      filters: _currentFilters,
                    );
                  }
                }
              },
              child: const Icon(Icons.filter_list, color: Colors.white),
            ),
            appBar: CustomMainAppBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  HomeCarousel(),
                  const SizedBox(height: 12),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ProductSortDropdown(
                          currentSort: _currentSortBy,
                          accentColor: accentColor,
                          onSortChanged: (newSort) {
                            setState(() {
                              _currentSortBy = newSort;
                            });
                            context.read<ProductCubit>().loadProducts(
                              page: 1,
                              searchTerm: _currentSearchTerm,
                              sortBy: newSort,
                              filters: _currentFilters,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Grid de produtos
                  BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, productState) {
                      return Padding(
                        padding: const EdgeInsets.all(30),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            const itemWidth = 260.0;
                            final crossAxisCount =
                                (constraints.maxWidth / itemWidth).floor();

                            if (productState.status == ProductStatus.loading) {
                              return GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: 24,
                                      mainAxisSpacing: 24,
                                      childAspectRatio: 0.7,
                                    ),
                                itemCount: 6,
                                itemBuilder: (_, index) {
                                  return ProductCard(
                                    accentColor: accentColor,
                                    product: ProductModel(
                                      id: 'loading',
                                      name: 'Loading...',
                                      description: '',
                                      price: 0,
                                      stock: 0,
                                    ),
                                    isLoading: true,
                                  );
                                },
                              );
                            }

                            if (productState.status == ProductStatus.error) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      size: 48,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Erro ao carregar produtos',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(productState.errorMessage ?? ''),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () => context
                                          .read<ProductCubit>()
                                          .loadProducts(),
                                      child: const Text('Tentar Novamente'),
                                    ),
                                  ],
                                ),
                              );
                            }

                            if (productState.products.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Nenhum produto encontrado',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                  ],
                                ),
                              );
                            }

                            return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 24,
                                    mainAxisSpacing: 24,
                                    childAspectRatio: 0.7,
                                  ),
                              itemCount: productState.products.length,
                              itemBuilder: (_, index) {
                                final product = productState.products[index];
                                return ProductCard(
                                  accentColor: accentColor,
                                  product: product,
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),

                  // Pagination Bar
                  BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, productState) {
                      return PaginationBar(
                        currentPage: productState.currentPage,
                        totalPages: productState.totalPages,
                        accentColor: accentColor,
                        onPageChanged: (page) {
                          context.read<ProductCubit>().loadProducts(
                            page: page,
                            searchTerm: _currentSearchTerm,
                            sortBy: _currentSortBy,
                            filters: _currentFilters,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
