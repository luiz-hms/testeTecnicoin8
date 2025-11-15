import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/named_routes.dart';

class CustomMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomMainAppBar({super.key});

  final Color primaryBlue = const Color(0xFF1976D2);
  final Color accentOrange = const Color(0xFFFF6D00);

  @override
  Size get preferredSize => const Size.fromHeight(110);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ÍCONE MENU PARA ABRIR O DRAWER
          IconButton(
            icon: const Icon(Icons.menu, size: 32),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),

          const SizedBox(width: 16),

          Image.network(
            "https://upload.wikimedia.org/wikipedia/commons/4/44/Google-flutter-logo.svg",
            width: 70,
          ),

          const Spacer(),

          SizedBox(
            width: 420,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: "Buscar produtos...",
                hintStyle: const TextStyle(fontSize: 16),
                suffixIcon: Icon(Icons.search, color: primaryBlue),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const Spacer(),

          IconButton(
            tooltip: "Minha Conta",
            onPressed: () {},
            icon: Icon(Icons.person_outline, size: 34, color: primaryBlue),
          ),

          IconButton(
            tooltip: "Carrinho",
            onPressed: () => context.goNamed(NamedRoute.checkoutPage),
            icon: Icon(
              Icons.shopping_cart_outlined,
              size: 34,
              color: accentOrange,
            ),
          ),
        ],
      ),
    );
  }
}
