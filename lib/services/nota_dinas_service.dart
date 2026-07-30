import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nota_dinas_model.dart';

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
}
