import 'package:flutter/material.dart';
import '../models/home_model.dart';
import '../services/home_service.dart';

class HomeProvider with ChangeNotifier {
  final HomeService _homeService = HomeService();

  // Variabel penampung data
  HomeData? _homeData;
  HomeData? get homeData => _homeData;

  // Variabel untuk status loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Menyimpan pesan error jika ada
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  /// Fungsi untuk mengambil data dan memberitahu UI
  Future<void> fetchHomeData() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Beritahu UI untuk nampilin efek loading

    try {
      final data = await _homeService.getHomeData();
      if (data != null) {
        _homeData = data;
      } else {
        _errorMessage = 'Gagal memuat data dari server lokal';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
    } finally {
      _isLoading = false;
      notifyListeners(); // Beritahu UI kalau loading selesai (entah sukses/gagal)
    }
  }
}