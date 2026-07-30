import 'package:flutter/material.dart';
import '../models/nota_dinas_model.dart';
import '../services/nota_dinas_service.dart';

class NotaDinasProvider with ChangeNotifier {
  final NotaDinasService _service = NotaDinasService();

  List<NotaDinasModel> _notaDinasList = [];
  List<NotaDinasModel> get notaDinasList => _notaDinasList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchBelumDiperiksa(String id, String group) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Mengambil status MBB (Belum Diperiksa)
      _notaDinasList = await _service.fetchNotaDinasList(id, group, 'MBB');
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void removeItem(String idnota) {
    _notaDinasList.removeWhere((item) => item.idnota == idnota);
    notifyListeners();
  }
}
