import 'package:flutter/material.dart';
import '../models/spt_model.dart';
import '../services/spt_service.dart';

class SptProvider with ChangeNotifier {
  final SptService _service = SptService();

  List<SptModel> _sptList = [];
  List<SptModel> get sptList => _sptList;

  List<SptModel> _historyList = [];
  List<SptModel> get historyList => _historyList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSptList({
    required String id,
    String? group,
    String? status,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _sptList = await _service.fetchSptList(
        id: id,
        group: group,
        status: status,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSptHistory({required String id, String? group}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _historyList = await _service.fetchSptList(
        id: id,
        group: group,
        status: null,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _sptList.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
