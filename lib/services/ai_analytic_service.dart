import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiAnalyticService {
  String get _baseUrl {
    // URL API diambil secara aman dari file .env (environment variables)
    // Jika tidak ada di .env, kita kembalikan fallback default
    return dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:8000/api';
  }

  Future<Map<String, dynamic>> fetchPrediction(String pegawaiId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/predict?pegawai=$pegawaiId')).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal memuat prediksi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: $e');
    }
  }

  Future<Map<String, dynamic>> fetchWeeklyPattern(String pegawaiId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/analytics/weekly_pattern?pegawai=$pegawaiId')).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal memuat pola mingguan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: $e');
    }
  }

  Future<Map<String, dynamic>> fetchMonthlyTrend(String pegawaiId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/analytics/monthly_trend?pegawai=$pegawaiId')).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal memuat tren bulanan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: $e');
    }
  }

  Future<Map<String, dynamic>> fetchSummary(String pegawaiId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/analytics/summary?pegawai=$pegawaiId')).timeout(const Duration(seconds: 15));
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

