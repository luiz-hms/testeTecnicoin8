import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'routes/app_router.dart';
import 'depence_injection/service_locator.dart';
import '../presentation/cubits/theme/theme_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      create: (context) => getIt<ThemeCubit>()..loadCurrentTheme(),
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
