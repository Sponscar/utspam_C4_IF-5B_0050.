import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class LocalUser {
  static const String userKey = 'user_data';
  static const String loginKey = 'is_logged_in';

  // Simpan user ke SharedPreferences
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonUser = jsonEncode(user.toMap());
    await prefs.setString(userKey, jsonUser);
  }

  // Ambil user dari SharedPreferences
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonUser = prefs.getString(userKey);

    if (jsonUser == null) return null;

    final map = jsonDecode(jsonUser);
    return UserModel.fromMap(map);
  }

  // Simpan status login
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginKey, value);
  }

  // Cek apakah user sedang login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginKey) ?? false;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginKey, false);
  }
}
