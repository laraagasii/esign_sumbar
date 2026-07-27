import 'package:flutter/material.dart';
import '../models/auth_model.dart'; // Sesuaikan path jika berbeda
import '../services/auth_service.dart'; // Sesuaikan path jika berbeda

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  // Variabel untuk menyimpan data user yang sedang login
  UserModel? _user;
  UserModel? get user => _user;

  // Variabel untuk mengontrol status loading di UI (misal: tombol muter-muter)
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Fungsi untuk mengecek status login saat aplikasi pertama kali dibuka
  /// (Biasanya dipanggil di main.dart)
  Future<void> checkLoginStatus() async {
    _user = await _authService.getUserSession();
    notifyListeners(); // Memberi tahu UI untuk update tampilan jika ada perubahan
  }

  /// Fungsi untuk menangani proses login dari tombol UI
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners(); // Ubah status tombol jadi loading

    try {
      // Panggil fungsi login dari service (yang baca file JSON)
      final loggedInUser = await _authService.login(username, password);

      if (loggedInUser != null) {
        // Jika berhasil, simpan data ke state dan SharedPreferences
        _user = loggedInUser;
        await _authService.saveUserSession(loggedInUser);

        _isLoading = false;
        notifyListeners(); // Matikan loading
        return true;
      } else {
        // Jika gagal (username/password salah)
        _isLoading = false;
        notifyListeners(); // Matikan loading
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners(); // Matikan loading
      throw Exception('Terjadi kesalahan saat login: $e');
    }
  }

  /// Fungsi untuk menangani proses logout
  Future<void> logout() async {
    await _authService.clearSession(); // Hapus dari local storage
    _user = null; // Kosongkan data user di state
    notifyListeners(); // Update UI (arahkan kembali ke halaman login)
  }
}
