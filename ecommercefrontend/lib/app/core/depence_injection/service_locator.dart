import 'package:ecommercefrontend/app/core/local_storage/local_storage.dart';
import 'package:ecommercefrontend/app/core/local_storage/secure_storage/secure_storage.dart';
import 'package:ecommercefrontend/app/core/rest_client/dio/dio_rest_client.dart';
import 'package:ecommercefrontend/app/core/rest_client/rest_client.dart';
import 'package:ecommercefrontend/app/core/services/whitelabel_init_service.dart';
import 'package:ecommercefrontend/app/core/services/token_encryption_service.dart';
import 'package:ecommercefrontend/app/data/repositories/auth_repository_impl.dart';
import 'package:ecommercefrontend/app/data/repositories/product_repository_impl.dart';
import 'package:ecommercefrontend/app/data/repositories/client_repository_impl.dart';
import 'package:ecommercefrontend/app/data/repositories/user_repository_impl.dart';
import 'package:ecommercefrontend/app/data/datasources/theme/theme_local_data_source.dart';
import 'package:ecommercefrontend/app/data/repositories/theme_repository_impl.dart';
import 'package:ecommercefrontend/app/domain/repositories/auth_repository.dart';
import 'package:ecommercefrontend/app/domain/repositories/product_repository.dart';
import 'package:ecommercefrontend/app/domain/repositories/client_repository.dart';
import 'package:ecommercefrontend/app/domain/repositories/user_repository.dart';
import 'package:ecommercefrontend/app/domain/repositories/theme_repository.dart';
import 'package:ecommercefrontend/app/domain/usecases/theme/get_current_theme_usecase.dart';
import 'package:ecommercefrontend/app/domain/usecases/theme/save_theme_usecase.dart';
import 'package:ecommercefrontend/app/domain/usecases/theme/get_available_themes_usecase.dart';
import 'package:ecommercefrontend/app/domain/usecases/theme/reset_to_default_theme_usecase.dart';
import 'package:ecommercefrontend/app/presentation/cubits/auth/auth_cubit.dart';
import 'package:ecommercefrontend/app/presentation/cubits/auth/login/login_cubit.dart';
import 'package:ecommercefrontend/app/presentation/cubits/product/product_cubit.dart';
import 'package:ecommercefrontend/app/presentation/cubits/client/client_settings_cubit.dart';
import 'package:ecommercefrontend/app/presentation/cubits/user/user_cubit.dart';
import 'package:ecommercefrontend/app/presentation/cubits/user_profile/user_profile_cubit.dart';
import 'package:ecommercefrontend/app/presentation/cubits/theme/theme_cubit.dart';
import 'package:ecommercefrontend/app/presentation/cubits/checkout/checkout_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

/// Inicializa as dependências da aplicação
Future<void> setupServiceLocator() async {
  // Registra SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Registra LocalStorage (SecureStorage)
  getIt.registerSingleton<LocalStorage>(SecureStorageImpl());

  // Registra RestClient
  getIt.registerSingleton<RestClient>(
    DioRestClient(localStorage: getIt<LocalStorage>()),
  );

  // Registra Data Sources
  getIt.registerSingleton<ThemeLocalDataSource>(
    ThemeLocalDataSourceImpl(sharedPreferences: getIt<SharedPreferences>()),
  );

  // Registra Repositories (segue o SOLID Principle - Dependency Inversion)
  getIt.registerSingleton<ThemeRepository>(
    ThemeRepositoryImpl(localDataSource: getIt<ThemeLocalDataSource>()),
  );

  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(restClient: getIt<RestClient>()),
  );

  getIt.registerSingleton<ProductRepository>(
    ProductRepositoryImpl(restClient: getIt<RestClient>()),
  );

  getIt.registerSingleton<ClientRepository>(
    ClientRepositoryImpl(restClient: getIt<RestClient>()),
  );

  getIt.registerSingleton<UserRepository>(
    UserRepositoryImpl(restClient: getIt<RestClient>()),
  );

  // Registra Services
  getIt.registerSingleton<WhitelabelInitService>(
    WhitelabelInitService(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerSingleton<TokenEncryptionService>(TokenEncryptionService());

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

  getIt.registerSingleton<AuthCubit>(
    AuthCubit(getIt<TokenEncryptionService>()),
  );

  getIt.registerFactory<CheckoutCubit>(() => CheckoutCubit());

  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(
      authRepository: getIt<AuthRepository>(),
      localStorage: getIt<LocalStorage>(),
      authCubit: getIt<AuthCubit>(),
    ),
  );

  getIt.registerFactory<ProductCubit>(
    () => ProductCubit(productRepository: getIt<ProductRepository>()),
  );

  getIt.registerFactory<ClientSettingsCubit>(
    () => ClientSettingsCubit(clientRepository: getIt<ClientRepository>()),
  );

  getIt.registerFactory<UserCubit>(
    () => UserCubit(userRepository: getIt<UserRepository>()),
  );

  getIt.registerFactory<UserProfileCubit>(
    () => UserProfileCubit(userRepository: getIt<UserRepository>()),
  );
}
