abstract class LocalStorage {
  Future<V?> read<V>(String key);
  Future<void> write<V>(String key, V value);
  Future<bool> containsKey(String key);
  Future<void> delete(String key);
  Future<void> clear();
}

abstract class LocalSecureStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<bool> containsKey(String key);
  Future<void> delete(String key);
  Future<void> clear();
}
