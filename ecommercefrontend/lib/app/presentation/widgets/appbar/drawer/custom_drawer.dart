import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/named_routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () => context.goNamed(NamedRoute.homePage),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text("Carrinho"),
            onTap: () => context.goNamed(NamedRoute.checkoutPage),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Configurações"),
            onTap: () => context.goNamed(NamedRoute.settingsPage),
          ),
        ],
      ),
    );
  }
}
