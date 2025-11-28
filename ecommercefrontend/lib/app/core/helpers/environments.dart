import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'constants/constants.dart';

class Environments {
  Environments._();
  static String? param(String paramName) {
    return dotenv.env[paramName];
  }

  static Future<void> loadEnvs() async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      print('⚠️ Erro ao carregar .env: $e');
      print('📝 Usando configuração padrão: ${Constants.ENV_DEFAULT_API_URL}');
      // Fallback: definir base_url padrão
      dotenv.env[Constants.ENV_BASE_URL] = Constants.ENV_DEFAULT_API_URL;
    }
  }
}
