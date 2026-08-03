import 'package:flutter/material.dart';
import '../models/nota_dinas_model.dart';
import '../models/nota_dinas_detail_model.dart';
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

  List<NotaDinasModel> _riwayatNotaDinasList = [];
  List<NotaDinasModel> get riwayatNotaDinasList => _riwayatNotaDinasList;

  bool _isRiwayatLoading = false;
  bool get isRiwayatLoading => _isRiwayatLoading;

  String? _riwayatErrorMessage;
  String? get riwayatErrorMessage => _riwayatErrorMessage;

  Future<void> fetchSudahDiperiksa(String id, String group) async {
    _isRiwayatLoading = true;
    _riwayatErrorMessage = null;
    notifyListeners();

    try {
      // Mengambil status MSB (Sudah Diperiksa / Riwayat)
      _riwayatNotaDinasList = await _service.fetchNotaDinasList(id, group, 'MSB');
    } catch (e) {
      _riwayatErrorMessage = e.toString();
    } finally {
      _isRiwayatLoading = false;
      notifyListeners();
    }
  }

  void removeItem(String idnota) {
    _notaDinasList.removeWhere((item) => item.idnota == idnota);
    notifyListeners();
  }

  NotaDinasDetailModel? _notaDinasDetail;
  NotaDinasDetailModel? get notaDinasDetail => _notaDinasDetail;

  bool _isDetailLoading = false;
  bool get isDetailLoading => _isDetailLoading;

  String? _detailErrorMessage;
  String? get detailErrorMessage => _detailErrorMessage;

  Future<void> fetchNotaDinasDetail(
    String id,
    String tahun,
    String group,
    String tipe,
    String token,
  ) async {
    _isDetailLoading = true;
    _detailErrorMessage = null;
    _notaDinasDetail = null;
    notifyListeners();

    try {
      _notaDinasDetail = await _service.fetchNotaDinasDetail(id, tahun, group, tipe, token);
    } catch (e) {
      _detailErrorMessage = e.toString();
    } finally {
      _isDetailLoading = false;
      notifyListeners();
    }
  }
}
