import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';

class AuthService {
  // Key untuk SharedPreferences
  static const String _userKey = 'user_data';
  static const String isLoggedInKey = 'isLoggedIn';

  /// Fungsi memanggil "API" Login dengan membaca file lokal JSON
  Future<UserModel?> login(String usernameInput, String passwordInput) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      final String responseString = await rootBundle.loadString(
        'assets/Login.json',
      );
      final Map<String, dynamic> data = jsonDecode(responseString);

      if (data['response'] == 1) {
        final List<dynamic> users = data['result'];

        // Cari user yang usernamenya cocok
        final userData = users.firstWhere(
          (user) => user['username'] == usernameInput,
          orElse: () => null,
        );

        if (userData != null && passwordInput == '123456') {
          return UserModel.fromJson(userData);
        }
      }
      // Return null jika username atau password salah, atau response bukan 1
      return null;
    } catch (e) {
      throw Exception('Gagal memproses data login: $e');
    }
  }

  /// Fungsi untuk menyimpan sesi user ke local storage
  Future<void> saveUserSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    // Mengubah object UserModel kembali ke bentuk JSON string untuk disimpan
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setBool(isLoggedInKey, true);
  }

  /// Fungsi untuk mengambil sesi user saat aplikasi baru dibuka
  Future<UserModel?> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool(isLoggedInKey) ?? false;

    if (isLoggedIn) {
      final String? userDataString = prefs.getString(_userKey);
      if (userDataString != null) {
        // Mengubah string JSON kembali menjadi object UserModel
        return UserModel.fromJson(jsonDecode(userDataString));
      }
    }
    return null; // Return null jika belum login atau data kosong
  }

  /// Fungsi untuk menghapus sesi user (Logout)
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Menghapus semua data sesi di SharedPreferences
  }
}
