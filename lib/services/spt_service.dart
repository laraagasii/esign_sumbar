import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/spt_model.dart';

class SptService {
  final String _baseUrl =
      'https://espj.sumbarprov.go.id/sumbarapis/spj/surat-tugas/list';
  final String _detailBaseUrl =
      'https://espj.sumbarprov.go.id/sumbarapis/spj/surat-tugas/detail';

  Future<List<SptModel>> fetchSptList({
    required String id,
    String? group,
    String? status,
  }) async {
    final url = group != null && group.isNotEmpty
        ? '$_baseUrl/id/$id/group/$group'
        : '$_baseUrl/id/$id';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        if (decodedData is Map<String, dynamic>) {
          final result = decodedData['result'];
          if (result is List) {
            final items = result
                .whereType<Map<String, dynamic>>()
                .map((item) => SptModel.fromJson(item))
                .toList();

            if (status != null && status.toUpperCase() == 'NEW') {
              final pendingItems = items.where(_isPendingItem).toList();
              return pendingItems.isNotEmpty ? pendingItems : items;
            }

            return items;
          }
        }

        return [];
      }

      throw Exception('Gagal memuat data SPT (Status: ${response.statusCode})');
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }

  Future<List<SptModel>> _fetchPendingSptListFallback({
    required String id,
    String? group,
  }) async {
    final fallbackUrl = group != null && group.isNotEmpty
        ? '$_baseUrl/id/$id/group/$group'
        : '$_baseUrl/id/$id';

    final response = await http.get(Uri.parse(fallbackUrl));
    if (response.statusCode != 200) {
      throw Exception(
        'Gagal memuat data SPT fallback (Status: ${response.statusCode})',
      );
    }

    final decodedData = json.decode(response.body);
    if (decodedData is Map<String, dynamic>) {
      final result = decodedData['result'];
      if (result is List) {
        return result
            .whereType<Map<String, dynamic>>()
            .where(_isPendingItem)
            .map((item) => SptModel.fromJson(item))
            .toList();
      }
    }

    return [];
  }

  bool _isPendingItem(Map<String, dynamic> item) {
    final status = item['status']?.toString().toUpperCase() ?? '';
    final nmstatus = item['nmstatus']?.toString().toLowerCase() ?? '';
    final statusLabel = item['status_label']?.toString().toLowerCase() ?? '';

    if (status == 'NEW') return true;
    if (nmstatus.contains('belum') ||
        nmstatus.contains('proses') ||
        nmstatus.contains('pending')) {
      return true;
    }
    if (statusLabel.contains('belum') ||
        statusLabel.contains('proses') ||
        statusLabel.contains('pending')) {
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>> fetchSptDetail({
    required String id,
    required String year,
    required String tipe,
    required String token,
  }) async {
    final url = '$_detailBaseUrl/id/$id/tahun/$year/tipe/$tipe/token/$token';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        if (decodedData is Map<String, dynamic>) {
          return decodedData;
        }
        return {'result': decodedData};
      }
      throw Exception(
        'Gagal memuat detail SPT (Status: ${response.statusCode})',
      );
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}
