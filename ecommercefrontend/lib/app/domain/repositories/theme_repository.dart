import 'package:ecommercefrontend/app/domain/entities/theme/app_theme.dart';

abstract class ThemeRepository {
  /// Obtém o tema atual
  Future<AppTheme> getCurrentTheme();

  /// Salva o tema
  Future<void> saveTheme(AppTheme theme);

  /// Obtém todos os temas disponíveis
  Future<List<AppTheme>> getAvailableThemes();

  /// Restaura o tema padrão
  Future<void> resetToDefaultTheme();
}
