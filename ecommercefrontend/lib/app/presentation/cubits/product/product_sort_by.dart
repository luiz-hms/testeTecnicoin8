enum ProductSortBy { priceLowToHigh, priceHighToLow, nameAZ, nameZA }

extension ProductSortByExtension on ProductSortBy {
  String get displayName {
    switch (this) {
      case ProductSortBy.priceLowToHigh:
        return 'Preço: menor → maior';
      case ProductSortBy.priceHighToLow:
        return 'Preço: maior → menor';
      case ProductSortBy.nameAZ:
        return 'Nome: A → Z';
      case ProductSortBy.nameZA:
        return 'Nome: Z → A';
    }
  }

  static ProductSortBy fromDisplayName(String displayName) {
    return ProductSortBy.values.firstWhere(
      (e) => e.displayName == displayName,
      orElse: () => ProductSortBy.priceLowToHigh,
    );
  }
}
