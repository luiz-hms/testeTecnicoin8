import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/product/product_model.dart';
import '../../cubits/checkout/checkout_cubit.dart';

class ProductAddToCartButton extends StatelessWidget {
  final ProductModel product;
  final Color accentColor;

  const ProductAddToCartButton({
    super.key,
    required this.product,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            context.read<CheckoutCubit>().addItem(product.toProduct());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.name} adicionado ao carrinho!'),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.green,
                action: SnackBarAction(
                  label: 'Ver Carrinho',
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/checkout');
                  },
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_shopping_cart, size: 24),
              const SizedBox(width: 12),
              const Text(
                'ADICIONAR AO CARRINHO',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
