import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommercefrontend/app/data/datasources/theme/theme_local_data_source.dart';
import 'package:ecommercefrontend/app/data/repositories/theme_repository_impl.dart';
import 'package:ecommercefrontend/app/domain/repositories/theme_repository.dart';
import 'package:ecommercefrontend/app/domain/usecases/theme/get_current_theme_usecase.dart';
import 'package:ecommercefrontend/app/domain/usecases/theme/save_theme_usecase.dart';
import 'package:ecommercefrontend/app/domain/usecases/theme/get_available_themes_usecase.dart';
import 'package:ecommercefrontend/app/domain/usecases/theme/reset_to_default_theme_usecase.dart';
import 'package:ecommercefrontend/app/presentation/cubits/theme/theme_cubit.dart';

final getIt = GetIt.instance;

/// Inicializa as dependências da aplicação
Future<void> setupServiceLocator() async {
  // Registra SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Registra Data Sources
  getIt.registerSingleton<ThemeLocalDataSource>(
    ThemeLocalDataSourceImpl(sharedPreferences: getIt<SharedPreferences>()),
  );

  // Registra Repositories (segue o SOLID Principle - Dependency Inversion)
  getIt.registerSingleton<ThemeRepository>(
    ThemeRepositoryImpl(localDataSource: getIt<ThemeLocalDataSource>()),
  );

  // Registra Use Cases
  getIt.registerSingleton<GetCurrentThemeUsecase>(
    GetCurrentThemeUsecase(getIt<ThemeRepository>()),
  );

  getIt.registerSingleton<SaveThemeUsecase>(
    SaveThemeUsecase(getIt<ThemeRepository>()),
  );

  getIt.registerSingleton<GetAvailableThemesUsecase>(
    GetAvailableThemesUsecase(getIt<ThemeRepository>()),
  );

  getIt.registerSingleton<ResetToDefaultThemeUsecase>(
    ResetToDefaultThemeUsecase(getIt<ThemeRepository>()),
  );

  // Registra Cubits
  getIt.registerSingleton<ThemeCubit>(
    ThemeCubit(
      getCurrentThemeUsecase: getIt<GetCurrentThemeUsecase>(),
      saveThemeUsecase: getIt<SaveThemeUsecase>(),
      getAvailableThemesUsecase: getIt<GetAvailableThemesUsecase>(),
      resetToDefaultThemeUsecase: getIt<ResetToDefaultThemeUsecase>(),
    ),
  );
}
