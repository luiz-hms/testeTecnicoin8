import 'package:go_router/go_router.dart';

import '../../presentation/pages/not_found_page/not_found_page.dart';
import 'named_routes.dart';
import 'routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: NamedRoute.settingsPage,
    //initialLocation: NamedRoute.loginPage,
    routes: Routes.route,
    errorBuilder: (_, __) => const NotFoundPage(),
  );
}
