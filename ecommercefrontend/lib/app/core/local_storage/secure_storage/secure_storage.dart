import 'package:ecommercefrontend/app/core/local_storage/local_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageImpl implements LocalSecureStorage {
  FlutterSecureStorage get _instance => FlutterSecureStorage();
  @override
  Future<void> clear() => _instance.deleteAll();

  @override
  Future<bool> containsKey(String key) => _instance.containsKey(key: key);

  @override
  Future<void> delete(String key) => _instance.delete(key: key);

  @override
  Future<String?> read(String key) => _instance.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _instance.write(key: key, value: value);
}
