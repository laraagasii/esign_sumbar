import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class AiAnalyticService {
  String get _baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    } else {
      // Gunakan IP laptop host agar bisa diakses dari emulator apa saja (Nox, LDPlayer, Google Emulator)
      return 'http://192.168.1.41:8000/api';
    }
  }

  Future<Map<String, dynamic>> fetchPrediction(String groupId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/predict?group=$groupId')).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal memuat prediksi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: $e');
    }
  }

  Future<Map<String, dynamic>> fetchWeeklyPattern(String groupId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/analytics/weekly_pattern?group=$groupId')).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal memuat pola mingguan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: $e');
    }
  }

  Future<Map<String, dynamic>> fetchMonthlyTrend(String groupId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/analytics/monthly_trend?group=$groupId')).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal memuat tren bulanan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: $e');
    }
  }

  Future<Map<String, dynamic>> fetchSummary(String groupId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/analytics/summary?group=$groupId')).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal memuat summary: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: $e');
    }
  }
}

