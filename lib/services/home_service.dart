import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/home_model.dart';

class HomeService {
  /// Membaca file Home.json dari folder assets
  Future<HomeData?> getHomeData() async {
    // Simulasi loading API selama 1 detik
    await Future.delayed(const Duration(seconds: 1));

    try {
      final String responseString = await rootBundle.loadString('assets/Home.json');
      final Map<String, dynamic> data = jsonDecode(responseString);

      // Cek apakah response sukses (bernilai 1)
      if (data['response'] == 1) {
        return HomeData.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal memproses data dashboard: $e');
    }
  }
}