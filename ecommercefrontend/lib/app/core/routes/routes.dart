import 'package:ecommercefrontend/app/presentation/pages/auth/login_page/login_page.dart';
import 'package:ecommercefrontend/app/presentation/pages/auth/register_page/register_page.dart';
import 'package:ecommercefrontend/app/presentation/pages/home_screen/home_screen.dart';
import 'package:ecommercefrontend/app/presentation/pages/product_details/product_details_page.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/checkout_page/checkout_page.dart';
import '../../presentation/pages/settings_page/settings_label_page/settings_label_page.dart';
import '../../../app/data/models/product/product_model.dart';
import 'named_routes.dart';

class Routes {
  static List<RouteBase> route = [
    GoRoute(
      path: NamedRoute.homePage,
      name: NamedRoute.homePage,
      builder: (context, state) {
        final searchTerm = state.uri.queryParameters['search'];
        return HomeScreen(searchTerm: searchTerm);
      },
    ),
    GoRoute(
      path: NamedRoute.loginPage,
      name: NamedRoute.loginPage,
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: NamedRoute.registerPage,
      name: NamedRoute.registerPage,
      builder: (_, __) => const ResgisterPage(),
    ),
    GoRoute(
      path: NamedRoute.checkoutPage,
      name: NamedRoute.checkoutPage,
      builder: (_, __) => const CheckoutPage(),
    ),
    GoRoute(
      path: NamedRoute.productDetailsPage,
      name: NamedRoute.productDetailsName,
      builder: (context, state) {
        final product = state.extra as ProductModel;
        return ProductDetailsPage(product: product);
      },
    ),
    GoRoute(
      path: NamedRoute.settingsPage,
      name: NamedRoute.settingsPage,
      builder: (_, __) => const WhiteLabelSettingsPage(),
    ),
  ];
}
