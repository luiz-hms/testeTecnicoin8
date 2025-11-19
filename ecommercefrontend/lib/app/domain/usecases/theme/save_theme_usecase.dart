import 'package:ecommercefrontend/app/domain/entities/theme/app_theme.dart';
import 'package:ecommercefrontend/app/domain/repositories/theme_repository.dart';

class SaveThemeUsecase {
  final ThemeRepository repository;

  SaveThemeUsecase(this.repository);

  Future<void> call(AppTheme theme) async {
    return await repository.saveTheme(theme);
  }
}
