import 'package:shared_preferences/shared_preferences.dart';

import 'dart:developer' as devtools;

class LocalStorage {
  LocalStorage._();

  static final LocalStorage _instance = LocalStorage._();
  factory LocalStorage() => _instance;

  SharedPreferences? _sharedPreferences;

  static Future<void> initialize() async {
    _instance._sharedPreferences = await SharedPreferences.getInstance();
  }

  static String? getString(String key) {
    final value = _instance._sharedPreferences!.getString(key);

    if (value == null) devtools.log('Error Local Storage: ', error: '[key] not found');

    return _instance._sharedPreferences!.getString(key);
  }

  static Future<void> setString(String key, String value) async {
    await _instance._sharedPreferences!.setString(key, value);
  }

  static Future<void> remove(String key) async {
    await _instance._sharedPreferences!.remove(key);
  }
}
