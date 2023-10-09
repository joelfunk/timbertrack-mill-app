import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._();
  static final LocalStorage _instance = LocalStorage._();
  factory LocalStorage() => _instance;

  SharedPreferences? _sharedPreferences;

  Future<String?> getString(String key) async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
      return _sharedPreferences!.getString(key);
    } else {
      return _sharedPreferences!.getString(key);
    }
  }

  Future<void> setString(String key, String value) async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
      _sharedPreferences!.setString(key, value);
    } else {
      _sharedPreferences!.setString(key, value);
    }
  }

  Future<bool> remove(String key) async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
      return (await _sharedPreferences!.remove(key));
    } else {
      return (await _sharedPreferences!.remove(key));
    }
  }
}
