import 'package:flutter/material.dart';
import '../../cubits/product/product_sort_by.dart';

class ProductSortDropdown extends StatelessWidget {
  final ProductSortBy currentSort;
  final ValueChanged<ProductSortBy> onSortChanged;
  final Color? accentColor;

  const ProductSortDropdown({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: DropdownButtonFormField<ProductSortBy>(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          prefixIcon: Icon(
            Icons.sort,
            color: accentColor ?? Theme.of(context).primaryColor,
          ),
        ),
        value: currentSort,
        items: ProductSortBy.values
            .map(
              (sortBy) => DropdownMenuItem(
                value: sortBy,
                child: Text(sortBy.displayName),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            onSortChanged(value);
          }
        },
      ),
    );
  }
}
