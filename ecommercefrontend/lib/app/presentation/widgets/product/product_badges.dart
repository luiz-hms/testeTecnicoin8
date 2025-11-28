import 'package:flutter/material.dart';
import '../../../data/models/product/product_model.dart';

class ProductBadges extends StatelessWidget {
  final ProductModel product;
  final Color accentColor;

  const ProductBadges({
    super.key,
    required this.product,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (product.category != null)
          _buildBadge(
            product.category!,
            accentColor.withOpacity(0.1),
            accentColor,
          ),
        if (product.material != null)
          _buildBadge(
            product.material!,
            Colors.blue.withOpacity(0.1),
            Colors.blue,
          ),
        if (product.department != null)
          _buildBadge(
            product.department!,
            Colors.purple.withOpacity(0.1),
            Colors.purple,
          ),
      ],
    );
  }

  Widget _buildBadge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
