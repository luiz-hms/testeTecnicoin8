import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/named_routes.dart';
import '../../../cubits/theme/theme_cubit.dart';
import '../../../cubits/theme/white_label_data.dart';
import '../../../cubits/checkout/checkout_cubit.dart';
import '../../../cubits/auth/auth_cubit.dart';
import '../../../cubits/auth/auth_state.dart';

class CustomMainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomMainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(110);

  @override
  State<CustomMainAppBar> createState() => _CustomMainAppBarState();
}

class _CustomMainAppBarState extends State<CustomMainAppBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearchText = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _hasSearchText = _searchController.text.isNotEmpty;
      });
    });
  }

  void _onSearch() {
    final value = _searchController.text.trim();
    if (value.isNotEmpty) {
      context.goNamed(NamedRoute.homePage, queryParameters: {'search': value});
    } else {
      // Se vazio, vai para home sem busca (limpa filtro)
      context.goNamed(NamedRoute.homePage);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    context.goNamed(NamedRoute.homePage);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

                  if (customLogo != null)
                    Image.memory(
                      customLogo,
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    )
                  else if (logoUrl.isNotEmpty &&
                      logoUrl !=
                          "https://upload.wikimedia.org/wikipedia/commons/4/44/Google-flutter-logo.svg")
                    Image.network(
                      logoUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/default_logo.png',
                          width: 70,
                          height: 70,
                          fit: BoxFit.contain,
                        );
                      },
                    )
                  else
                    Image.asset(
                      'assets/images/default_logo.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    ),

                  const Spacer(),

                  SizedBox(
                    width: 420,
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (_) => _onSearch(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: "Buscar produtos...",
                        hintStyle: const TextStyle(fontSize: 16),
                        prefixIcon: _hasSearchText
                            ? IconButton(
                                icon: const Icon(Icons.close, size: 20),
                                onPressed: _clearSearch,
                                tooltip: 'Limpar busca',
                              )
                            : null,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search, color: primaryColor),
                          onPressed: _onSearch,
                        ),
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

                  BlocBuilder<CheckoutCubit, CheckoutState>(
                    builder: (context, state) {
                      final totalItems = state.items.fold(
                        0,
                        (sum, item) => sum + item.quantity,
                      );

                      return IconButton(
                        tooltip: "Carrinho",
                        onPressed: () =>
                            context.goNamed(NamedRoute.checkoutPage),
                        icon: Badge(
                          isLabelVisible: totalItems > 0,
                          label: Text('$totalItems'),
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            size: 34,
                            color: accentColor,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 16),

                  // BOTÃO LOGIN / LOGOUT
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, authState) {
                      if (authState is AuthAuthenticated) {
                        return IconButton(
                          tooltip: "Sair",
                          onPressed: () {
                            context.read<AuthCubit>().logout();
                            context.goNamed(NamedRoute.homePage);
                          },
                          icon: const Icon(
                            Icons.logout,
                            size: 34,
                            color: Colors.red,
                          ),
                        );
                      } else {
                        return IconButton(
                          tooltip: "Entrar",
                          onPressed: () =>
                              context.goNamed(NamedRoute.loginPage),
                          icon: Icon(
                            Icons.login,
                            size: 34,
                            color: primaryColor,
                          ),
                        );
                      }
                    },
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
