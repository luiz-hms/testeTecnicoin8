import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommercefrontend/app/data/models/theme/theme_model.dart';
import 'package:ecommercefrontend/app/domain/entities/theme/app_theme.dart';

abstract class ThemeLocalDataSource {
  /// Obtém o tema atual armazenado localmente
  Future<ThemeModel> getCurrentTheme();

  /// Salva o tema localmente
  Future<void> saveTheme(ThemeModel theme);

  /// Obtém todos os temas disponíveis
  Future<List<ThemeModel>> getAvailableThemes();

  /// Restaura o tema padrão
  Future<void> resetToDefaultTheme();
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferences sharedPreferences;

  ThemeLocalDataSourceImpl({required this.sharedPreferences});

  static const String _currentThemeKey = 'current_theme';
  static const String _availableThemesKey = 'available_themes';

  @override
  Future<ThemeModel> getCurrentTheme() async {
    try {
      final themeJson = sharedPreferences.getString(_currentThemeKey);
      if (themeJson != null) {
        final themeMap = jsonDecode(themeJson) as Map<String, dynamic>;
        return ThemeModel.fromJson(themeMap);
      }
      // Retorna o tema padrão se nenhum foi salvo
      return ThemeModel.fromEntity(defaultTheme);
    } catch (e) {
      return ThemeModel.fromEntity(defaultTheme);
    }
  }

  @override
  Future<void> saveTheme(ThemeModel theme) async {
    try {
      final themeJson = jsonEncode(theme.toJson());
      await sharedPreferences.setString(_currentThemeKey, themeJson);
    } catch (e) {
      throw Exception('Erro ao salvar tema: $e');
    }
  }

  @override
  Future<List<ThemeModel>> getAvailableThemes() async {
    try {
      final themesJson = sharedPreferences.getString(_availableThemesKey);
      if (themesJson != null && themesJson.isNotEmpty) {
        final themesList = jsonDecode(themesJson) as List;
        return themesList
            .map((theme) => ThemeModel.fromJson(theme as Map<String, dynamic>))
            .toList();
      }
      // Retorna temas padrões se nenhum foi salvo
      return [ThemeModel.fromEntity(defaultTheme)];
    } catch (e) {
      return [ThemeModel.fromEntity(defaultTheme)];
    }
  }

  @override
  Future<void> resetToDefaultTheme() async {
    try {
      await sharedPreferences.remove(_currentThemeKey);
    } catch (e) {
      throw Exception('Erro ao resetar tema: $e');
    }
  }
}
