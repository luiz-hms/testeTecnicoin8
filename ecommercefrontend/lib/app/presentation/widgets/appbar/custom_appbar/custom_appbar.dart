import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/named_routes.dart';
import '../../../cubits/theme/theme_cubit.dart';
import '../../../cubits/theme/white_label_data.dart';

class CustomMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomMainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(110);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final primaryColor = (state is ThemeLoaded)
            ? state.theme.primaryColor
            : const Color(0xFF1976D2);
        final accentColor = (state is ThemeLoaded)
            ? state.theme.accentColor
            : const Color(0xFFFF6D00);
        final logoUrl = (state is ThemeLoaded)
            ? state.theme.logoUrl
            : "https://upload.wikimedia.org/wikipedia/commons/4/44/Google-flutter-logo.svg";

        return FutureBuilder(
          future: WhiteLabelData.getLogo(),
          builder: (context, snapshot) {
            final customLogo = snapshot.data;

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

                  // LOGO - PRIORIZA CUSTOM LOGO EM BASE64
                  if (customLogo != null)
                    Image.memory(
                      customLogo,
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    )
                  else
                    Image.network(
                      logoUrl,
                      width: 70,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 70,
                          height: 70,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
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
                        suffixIcon: Icon(Icons.search, color: primaryColor),
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
                    icon: Icon(
                      Icons.person_outline,
                      size: 34,
                      color: primaryColor,
                    ),
                  ),

                  IconButton(
                    tooltip: "Carrinho",
                    onPressed: () => context.goNamed(NamedRoute.checkoutPage),
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      size: 34,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
