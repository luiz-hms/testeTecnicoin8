class ProductFilters {
  final String? provider; // 'brazilian_provider' or 'european_provider'
  final double? minPrice;
  final double? maxPrice;

  const ProductFilters({this.provider, this.minPrice, this.maxPrice});

  ProductFilters copyWith({
    String? provider,
    double? minPrice,
    double? maxPrice,
    bool clearProvider = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
  }) {
    return ProductFilters(
      provider: clearProvider ? null : (provider ?? this.provider),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
    );
  }

  bool get hasActiveFilters =>
      provider != null || minPrice != null || maxPrice != null;

  ProductFilters clear() {
    return const ProductFilters();
  }

  @override
  String toString() {
    return 'ProductFilters(provider: $provider, minPrice: $minPrice, maxPrice: $maxPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductFilters &&
        other.provider == provider &&
        other.minPrice == minPrice &&
        other.maxPrice == maxPrice;
  }

  @override
  int get hashCode => provider.hashCode ^ minPrice.hashCode ^ maxPrice.hashCode;
}
