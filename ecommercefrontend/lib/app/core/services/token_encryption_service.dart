import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenEncryptionService {
  final _storage = const FlutterSecureStorage();
  // Chave fixa para exemplo - em produção idealmente viria de env ou key store
  final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
  final _iv = encrypt.IV.fromLength(16);
  late final encrypt.Encrypter _encrypter;

  TokenEncryptionService() {
    _encrypter = encrypt.Encrypter(encrypt.AES(_key));
  }

  Future<void> saveToken(String token) async {
    final encrypted = _encrypter.encrypt(token, iv: _iv);
    await _storage.write(key: 'auth_token', value: encrypted.base64);
  }

  Future<String?> getToken() async {
    final encryptedToken = await _storage.read(key: 'auth_token');
    if (encryptedToken == null) return null;

    try {
      final decrypted = _encrypter.decrypt(
        encrypt.Encrypted.fromBase64(encryptedToken),
        iv: _iv,
      );
      return decrypted;
    } catch (e) {
      print('Erro ao descriptografar token: $e');
      await clearToken();
      return null;
    }
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
