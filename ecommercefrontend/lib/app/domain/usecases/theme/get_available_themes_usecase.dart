import 'package:ecommercefrontend/app/domain/entities/theme/app_theme.dart';
import 'package:ecommercefrontend/app/domain/repositories/theme_repository.dart';

class GetAvailableThemesUsecase {
  final ThemeRepository repository;

  GetAvailableThemesUsecase(this.repository);

  Future<List<AppTheme>> call() async {
    return await repository.getAvailableThemes();
  }
}
