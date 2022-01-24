import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  static SharedPreferencesProvider? _instance;

  static SharedPreferencesProvider getInstance() {
    _instance ??= SharedPreferencesProvider();
    return _instance!;
  }

  Future<dynamic> getJson({
    required String key,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key) ?? '');
  }

  Future<bool> setJson({
    required String key,
    required dynamic json,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, json.encode(json));
  }
}
