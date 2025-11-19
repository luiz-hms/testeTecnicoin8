import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

/// Classe responsável por gerenciar dados de White Label (logo, banners, cores)
/// Sincroniza com SharedPreferences
class WhiteLabelData {
  // Keys para SharedPreferences
  static const String _primaryColorKey = 'whitelabel_primary_color';
  static const String _secondaryColorKey = 'whitelabel_secondary_color';
  static const String _logoKey = 'whitelabel_logo_base64';
  static const String _bannersKey = 'whitelabel_banners_base64';

  // Instância privada do SharedPreferences
  static late SharedPreferences _prefs;

  /// Inicializa o gerenciador de dados
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Obtém o logo em bytes (Base64 decodificado)
  static Future<Uint8List?> getLogo() async {
    final logoBase64 = _prefs.getString(_logoKey);
    if (logoBase64 != null && logoBase64.isNotEmpty) {
      try {
        return base64Decode(logoBase64);
      } catch (e) {
        print('Erro ao decodificar logo: $e');
        return null;
      }
    }
    return null;
  }

  /// Obtém os banners em bytes (lista de Base64 decodificados)
  static Future<List<Uint8List>> getBanners() async {
    final bannersJson = _prefs.getString(_bannersKey);
    if (bannersJson != null && bannersJson.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(bannersJson);
        return decoded
            .map((base64String) => base64Decode(base64String as String))
            .toList();
      } catch (e) {
        print('Erro ao decodificar banners: $e');
        return [];
      }
    }
    return [];
  }

  /// Obtém a cor primária como int
  static int getPrimaryColor() {
    return _prefs.getInt(_primaryColorKey) ?? 0xFF1976D2;
  }

  /// Obtém a cor secundária como int
  static int getSecondaryColor() {
    return _prefs.getInt(_secondaryColorKey) ?? 0xFFFF6D00;
  }

  /// Salva o logo (em bytes)
  static Future<void> saveLogo(Uint8List? logoBytes) async {
    if (logoBytes != null) {
      final logoBase64 = base64Encode(logoBytes);
      await _prefs.setString(_logoKey, logoBase64);
    } else {
      await _prefs.remove(_logoKey);
    }
  }

  /// Salva os banners (lista de bytes)
  static Future<void> saveBanners(List<Uint8List> bannerImages) async {
    if (bannerImages.isNotEmpty) {
      final bannersBase64 = bannerImages
          .map((bytes) => base64Encode(bytes))
          .toList();
      final bannersJson = jsonEncode(bannersBase64);
      await _prefs.setString(_bannersKey, bannersJson);
    } else {
      await _prefs.remove(_bannersKey);
    }
  }

  /// Salva a cor primária
  static Future<void> savePrimaryColor(int colorValue) async {
    await _prefs.setInt(_primaryColorKey, colorValue);
  }

  /// Salva a cor secundária
  static Future<void> saveSecondaryColor(int colorValue) async {
    await _prefs.setInt(_secondaryColorKey, colorValue);
  }

  /// Limpa todos os dados de White Label
  static Future<void> clearAll() async {
    await _prefs.remove(_primaryColorKey);
    await _prefs.remove(_secondaryColorKey);
    await _prefs.remove(_logoKey);
    await _prefs.remove(_bannersKey);
  }

  /// Verifica se existe logo customizado
  static bool hasCustomLogo() {
    final logoBase64 = _prefs.getString(_logoKey);
    return logoBase64 != null && logoBase64.isNotEmpty;
  }

  /// Verifica se existem banners customizados
  static bool hasCustomBanners() {
    final bannersJson = _prefs.getString(_bannersKey);
    return bannersJson != null && bannersJson.isNotEmpty;
  }
}
