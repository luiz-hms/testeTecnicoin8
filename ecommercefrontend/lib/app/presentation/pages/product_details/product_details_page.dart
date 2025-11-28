import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/product/product_model.dart';
import '../../cubits/theme/theme_cubit.dart';
import '../../widgets/product/product_image_gallery.dart';
import '../../widgets/product/product_price_section.dart';
import '../../widgets/product/product_badges.dart';
import '../../widgets/product/product_add_to_cart_button.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  List<String> get _allImages {
    final images = <String>[];
    if (widget.product.imageUrl != null &&
        widget.product.imageUrl!.isNotEmpty) {
      images.add(widget.product.imageUrl!);
    }
    if (widget.product.gallery != null) {
      images.addAll(widget.product.gallery!);
    }
    return images.isEmpty ? [''] : images;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final accentColor = (state is ThemeLoaded)
            ? state.theme.accentColor
            : const Color(0xFFFF6D00);

        final hasDiscount =
            widget.product.hasDiscount == true &&
            (widget.product.discountValue ?? 0) > 0;

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Text(
              widget.product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            backgroundColor: accentColor,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductImageGallery(images: _allImages),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ProductBadges(
                        product: widget.product,
                        accentColor: accentColor,
                      ),
                      const SizedBox(height: 16),
                      ProductPriceSection(
                        price: widget.product.price,
                        discountValue: widget.product.discountValue,
                        hasDiscount: hasDiscount,
                      ),
                      const SizedBox(height: 16),
                      _buildStockIndicator(),
                      const SizedBox(height: 20),
                      const Text(
                        'Descrição',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildProviderInfo(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: ProductAddToCartButton(
            product: widget.product,
            accentColor: accentColor,
          ),
        );
      },
    );
  }

  Widget _buildStockIndicator() {
    return Row(
      children: [
        const Icon(Icons.inventory_2, color: Colors.green, size: 20),
        const SizedBox(width: 8),
        const Text(
          'Em estoque',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildProviderInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.local_shipping, color: Colors.grey[600], size: 20),
          const SizedBox(width: 8),
          Text(
            'Fornecido por: Brazilian Provider',
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
