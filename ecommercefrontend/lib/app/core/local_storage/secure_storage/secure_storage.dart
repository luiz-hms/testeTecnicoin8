import 'package:ecommercefrontend/app/core/local_storage/local_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageImpl implements LocalStorage {
  FlutterSecureStorage get _instance => FlutterSecureStorage();
  @override
  Future<void> clear() => _instance.deleteAll();

  @override
  Future<bool> containsKey(String key) => _instance.containsKey(key: key);

  @override
  Future<void> delete(String key) => _instance.delete(key: key);

  @override
  Future<V?> read<V>(String key) async {
    final result = await _instance.read(key: key);
    if (result == null) return null;
    return result as V;
  }

  @override
  Future<void> write<V>(String key, V value) =>
      _instance.write(key: key, value: value.toString());
}
