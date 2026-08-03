import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nota_dinas_model.dart';
import '../models/nota_dinas_detail_model.dart';

class NotaDinasService {
  // Hardcoded for now based on user's API endpoint, can be made dynamic later
  final String _baseUrl =
      'https://espj.sumbarprov.go.id/sumbarapis/spj/nota-dinas/list';

  Future<List<NotaDinasModel>> fetchNotaDinasList(
    String id,
    String group,
    String status,
  ) async {
    final url = '$_baseUrl/id/$id/group/$group/status/$status';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);

        if (decodedData['response'] == 1 && decodedData['result'] != null) {
          final List<dynamic> resultList = decodedData['result'];
          return resultList
              .map((json) => NotaDinasModel.fromJson(json))
              .toList();
        } else {
          return []; // Return empty if no result or response code is not 1
        }
      } else {
        throw Exception(
          'Gagal memuat data dari server (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }

  Future<NotaDinasDetailModel?> fetchNotaDinasDetail(
    String id,
    String tahun,
    String group,
    String tipe,
    String token,
  ) async {
    // URL pattern: /detail/id/{id}/tahun/{tahun}/group/{group}/tipe/{tipe}/token/{token}
    // _baseUrl is 'https://espj.sumbarprov.go.id/sumbarapis/spj/nota-dinas/list'
    // We need to modify _baseUrl to point to detail instead of list
    final String detailBaseUrl = 'https://espj.sumbarprov.go.id/sumbarapis/spj/nota-dinas/detail';
    final url = '$detailBaseUrl/id/$id/tahun/$tahun/group/$group/tipe/$tipe/token/$token';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);

        if (decodedData['response'] == 1 && decodedData['result'] != null) {
          return NotaDinasDetailModel.fromJson(decodedData);
        } else {
          return null; // or throw Exception
        }
      } else {
        throw Exception(
          'Gagal memuat detail dari server (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}
