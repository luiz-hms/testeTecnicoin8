import 'package:shared_preferences/shared_preferences.dart';

import '../local_storage.dart';

class SharedPreferencesImpl implements LocalStorage {
  Future<SharedPreferences> get _instance => SharedPreferences.getInstance();
  @override
  Future<void> clear() async {
    final sharedPreferences = await _instance;
    sharedPreferences.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    final sharedPreferences = await _instance;
    return sharedPreferences.containsKey(key);
  }

  @override
  Future<void> delete(String key) async {
    final sharedPreferences = await _instance;
    sharedPreferences.remove(key);
  }

  @override
  Future<V?> read<V>(String key) async {
    final sharedPreferences = await _instance;
    return sharedPreferences.get(key) as V?;
  }

  @override
  Future<void> write<V>(String key, V value) async {
    final sharedPreferences = await _instance;
    switch (V) {
      case String:
        await sharedPreferences.setString(key, value as String);
        return;
      case int:
        await sharedPreferences.setInt(key, value as int);
        return;
      case double:
        await sharedPreferences.setDouble(key, value as double);
        return;
      case bool:
        await sharedPreferences.setBool(key, value as bool);
        return;
      case const (List<String>):
        await sharedPreferences.setStringList(key, value as List<String>);
        return;
      default:
        throw Exception('Tipo de valor não suportado para SharedPreferences');
    }
  }
}
