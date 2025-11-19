import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:ecommercefrontend/app/domain/entities/theme/app_theme.dart';
import 'package:ecommercefrontend/app/domain/usecases/theme/get_current_theme_usecase.dart';
import 'package:ecommercefrontend/app/domain/usecases/theme/save_theme_usecase.dart';
import 'package:ecommercefrontend/app/domain/usecases/theme/get_available_themes_usecase.dart';
import 'package:ecommercefrontend/app/domain/usecases/theme/reset_to_default_theme_usecase.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final GetCurrentThemeUsecase getCurrentThemeUsecase;
  final SaveThemeUsecase saveThemeUsecase;
  final GetAvailableThemesUsecase getAvailableThemesUsecase;
  final ResetToDefaultThemeUsecase resetToDefaultThemeUsecase;

  ThemeCubit({
    required this.getCurrentThemeUsecase,
    required this.saveThemeUsecase,
    required this.getAvailableThemesUsecase,
    required this.resetToDefaultThemeUsecase,
  }) : super(const ThemeInitial());

  /// Carrega o tema atual
  Future<void> loadCurrentTheme() async {
    try {
      emit(const ThemeLoading());
      final theme = await getCurrentThemeUsecase();
      emit(ThemeLoaded(theme: theme));
    } catch (e) {
      emit(ThemeError(message: 'Erro ao carregar tema: ${e.toString()}'));
    }
  }

  /// Atualiza o tema
  Future<void> updateTheme(AppTheme theme) async {
    try {
      emit(const ThemeLoading());
      await saveThemeUsecase(theme);
      emit(ThemeLoaded(theme: theme));
    } catch (e) {
      emit(ThemeError(message: 'Erro ao atualizar tema: ${e.toString()}'));
    }
  }

  /// Atualiza apenas a cor primária
  Future<void> updatePrimaryColor(int colorValue) async {
    if (state is ThemeLoaded) {
      final currentTheme = (state as ThemeLoaded).theme;
      final updatedTheme = currentTheme.copyWith(
        primaryColor: Color(colorValue),
      );
      await updateTheme(updatedTheme);
    }
  }

  /// Atualiza apenas a cor de acento
  Future<void> updateAccentColor(int colorValue) async {
    if (state is ThemeLoaded) {
      final currentTheme = (state as ThemeLoaded).theme;
      final updatedTheme = currentTheme.copyWith(
        accentColor: Color(colorValue),
      );
      await updateTheme(updatedTheme);
    }
  }

  /// Atualiza apenas o logo
  Future<void> updateLogo(String logoUrl) async {
    if (state is ThemeLoaded) {
      final currentTheme = (state as ThemeLoaded).theme;
      final updatedTheme = currentTheme.copyWith(logoUrl: logoUrl);
      await updateTheme(updatedTheme);
    }
  }

  /// Atualiza apenas os banners
  Future<void> updateBanners(List<String> bannerUrls) async {
    if (state is ThemeLoaded) {
      final currentTheme = (state as ThemeLoaded).theme;
      final updatedTheme = currentTheme.copyWith(bannerUrls: bannerUrls);
      await updateTheme(updatedTheme);
    }
  }

  /// Obtém temas disponíveis
  Future<List<AppTheme>> getAvailableThemes() async {
    try {
      return await getAvailableThemesUsecase();
    } catch (e) {
      emit(ThemeError(message: 'Erro ao obter temas: ${e.toString()}'));
      return [];
    }
  }

  /// Reseta para o tema padrão
  Future<void> resetToDefaultTheme() async {
    try {
      emit(const ThemeLoading());
      await resetToDefaultThemeUsecase();
      final theme = await getCurrentThemeUsecase();
      emit(ThemeLoaded(theme: theme));
    } catch (e) {
      emit(ThemeError(message: 'Erro ao resetar tema: ${e.toString()}'));
    }
  }
}
