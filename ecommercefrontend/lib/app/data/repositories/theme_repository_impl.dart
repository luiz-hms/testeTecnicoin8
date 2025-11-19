import 'package:ecommercefrontend/app/data/datasources/theme/theme_local_data_source.dart';
import 'package:ecommercefrontend/app/data/models/theme/theme_model.dart';
import 'package:ecommercefrontend/app/domain/entities/theme/app_theme.dart';
import 'package:ecommercefrontend/app/domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl({required this.localDataSource});

  @override
  Future<AppTheme> getCurrentTheme() async {
    return await localDataSource.getCurrentTheme();
  }

  @override
  Future<void> saveTheme(AppTheme theme) async {
    final themeModel = ThemeModel.fromEntity(theme);
    return await localDataSource.saveTheme(themeModel);
  }

  @override
  Future<List<AppTheme>> getAvailableThemes() async {
    return await localDataSource.getAvailableThemes();
  }

  @override
  Future<void> resetToDefaultTheme() async {
    return await localDataSource.resetToDefaultTheme();
  }
}
