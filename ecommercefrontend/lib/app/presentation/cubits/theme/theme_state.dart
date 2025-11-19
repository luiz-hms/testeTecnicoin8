part of 'theme_cubit.dart';

abstract class ThemeState {
  const ThemeState();
}

class ThemeInitial extends ThemeState {
  const ThemeInitial();
}

class ThemeLoading extends ThemeState {
  const ThemeLoading();
}

class ThemeLoaded extends ThemeState {
  final AppTheme theme;

  const ThemeLoaded({required this.theme});
}

class ThemeError extends ThemeState {
  final String message;

  const ThemeError({required this.message});
}
