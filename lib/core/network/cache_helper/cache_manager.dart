import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const _accessTokenKey = 'accessToken';
  static const _roleKey = 'role';
  // Save access token
  static Future<void> saveRole(bool role) async {
    final prefs = await SharedPreferences.getInstance();
    final isSaved = await prefs.setBool(_roleKey, role);
    if (isSaved) {
      log('Role saved successfully: $role');
    } else {
      log('Failed to save role.');
    }
  }


  static Future<bool?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_roleKey);
  }

  // Save access token
  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<bool> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }
}
