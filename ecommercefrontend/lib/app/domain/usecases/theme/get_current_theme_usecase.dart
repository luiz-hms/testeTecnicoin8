import 'package:ecommercefrontend/app/domain/entities/theme/app_theme.dart';
import 'package:ecommercefrontend/app/domain/repositories/theme_repository.dart';

class GetCurrentThemeUsecase {
  final ThemeRepository repository;

  GetCurrentThemeUsecase(this.repository);

  Future<AppTheme> call() async {
    return await repository.getCurrentTheme();
  }
}
