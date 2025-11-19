import 'package:ecommercefrontend/app/domain/repositories/theme_repository.dart';

class ResetToDefaultThemeUsecase {
  final ThemeRepository repository;

  ResetToDefaultThemeUsecase(this.repository);

  Future<void> call() async {
    return await repository.resetToDefaultTheme();
  }
}
