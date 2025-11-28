import 'package:ecommercefrontend/app/presentation/cubits/auth/auth_cubit.dart';
import 'package:ecommercefrontend/app/presentation/cubits/checkout/checkout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/core/routes/app_router.dart';
import 'app/core/depence_injection/service_locator.dart';
import 'app/presentation/cubits/theme/theme_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => getIt<ThemeCubit>()..loadCurrentTheme(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => getIt<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider<CheckoutCubit>(
          create: (context) => getIt<CheckoutCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final themeColor = (state is ThemeLoaded)
              ? state.theme.primaryColor
              : const Color(0xFF1976D2);

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'DevNology E-Commerce',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: themeColor),
              useMaterial3: true,
            ),
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
