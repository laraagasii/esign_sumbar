import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:proyek_esign/widgets/custom_bottom_navbar.dart';
import 'package:proyek_esign/providers/auth_provider.dart';
import 'package:proyek_esign/widgets/filter_analitik_dialog.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AnalisisPengajuanScreen extends StatefulWidget {
  const AnalisisPengajuanScreen({super.key});

  @override
  State<AnalisisPengajuanScreen> createState() =>
      _AnalisisPengajuanScreenState();
}

class _AnalisisPengajuanScreenState extends State<AnalisisPengajuanScreen> {
  String _selectedPeriode = 'Bulan Ini';
  String? _selectedDinas;
  int _totalNodin = 0;
  int _totalSpt = 0;
  int _totalDisetujui = 0;
  int _totalBerjalan = 0;
  int _totalDitolak = 0;
  double _avgDurationNodin = 0.0;
  double _avgDurationSpt = 0.0;
  bool _isLoading = true;

  // --- STATE UNTUK AI ETA PREDICTION ---
  bool _isLoadingEta = true;
  List<Map<String, dynamic>> _activePredictions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadEtaPrediction();
  }

  Future<void> _loadEtaPrediction() async {
    setState(() {
      _isLoadingEta = true;
      _activePredictions = [];
    });

    try {
      final String jsonString =
          await rootBundle.loadString('assets/riwayat_pengajuan.json');
      final jsonData = json.decode(jsonString);

      final nodinList =
          (jsonData['data']['nota_dinas'] as List).cast<Map<String, dynamic>>();
      final sptList =
          (jsonData['data']['spt'] as List).cast<Map<String, dynamic>>();

      int _kategoriFromTipePd(String tipePd) {
        switch (tipePd.toUpperCase()) {
          case 'DK':
            return 0;
          case 'DD':
            return 1;
          case 'DL':
            return 2;
          default:
            return 1;
        }
      }

      List<Map<String, dynamic>> prosesItems = [];
      
      for (final item in nodinList) {
        if (item['status'] == 'PROSES') {
          prosesItems.add({'item': item, 'tipeDoc': 0});
        }
      }
      for (final item in sptList) {
        if (item['status'] == 'PROSES') {
          prosesItems.add({'item': item, 'tipeDoc': 1});
        }
      }

      if (prosesItems.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoadingEta = false;
          });
        }
        return;
      }

      List<Map<String, dynamic>> results = [];
      final baseUrl = "http://localhost:8000/api/predict-eta"; // Gunakan 10.0.2.2 jika menggunakan emulator Android

      for (var p in prosesItems) {
        final found = p['item'];
        final tipeDoc = p['tipeDoc'];
        final tipePd = found['tipe_pd'] as String? ?? 'DD';
        final jumlahPengikut = (found['detail']?['total_pengikut'] as int?) ?? 1;
        
        // AMBIL TANGGAL PENGAJUAN DARI JSON
        final String tglPengajuan = found['tgl_st'] ?? ''; 
        
        final title = '${tipeDoc == 0 ? 'Nota Dinas' : 'SPT'} - ${found['maksud'] ?? ''}';
        final kategori = _kategoriFromTipePd(tipePd);

        try {
          // GABUNGKAN PARAMETER TANGGAL KE DALAM URL API
          String apiUrl = "$baseUrl?tipe_dokumen=$tipeDoc&jumlah_pengikut=$jumlahPengikut&kategori=$kategori";
          if (tglPengajuan.isNotEmpty) {
            apiUrl += "&tanggal_pengajuan=$tglPengajuan";
          }

          final uri = Uri.parse(apiUrl);
          final response = await http.get(uri);

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final prediksi = data['prediksi_eta'];

            results.add({
              'title': title,
              'durasi_jam': (prediksi['durasi_jam'] as num).toDouble(),
              'eta_label': prediksi['estimasi_selesai_label'],
              'is_error': false,
            });
          } else {
            results.add({
              'title': title,
              'is_error': true,
              'error_msg': 'Gagal memuat API',
            });
          }
        } catch (e) {
          results.add({
            'title': title,
            'is_error': true,
            'error_msg': 'Backend terputus',
          });
        }
      }

      if (mounted) {
        setState(() {
          _activePredictions = results;
          _isLoadingEta = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingEta = false;
        });
      }
    }
  }

  DateTime? _parseIndoDate(String dateStr) {
    if (dateStr.isEmpty) return null;
    try {
      final parts = dateStr.split(', ');
      if (parts.length < 2) return null;
      final timeParts = parts[1].split(' ');
      if (timeParts.length < 4) return null;
      
      final day = timeParts[0];
      final monthStr = timeParts[1].toLowerCase();
      final year = timeParts[2];
      final time = timeParts[3];

      const months = {
        'januari': '01', 'februari': '02', 'maret': '03', 'april': '04',
        'mei': '05', 'juni': '06', 'juli': '07', 'agustus': '08',
        'september': '09', 'oktober': '10', 'november': '11', 'desember': '12'
      };
      final month = months[monthStr] ?? '01';
      return DateTime.tryParse('$year-$month-${day.padLeft(2, '0')} $time');
    } catch (_) {
      return null;
    }
  }

  Future<void> _loadData() async {
    try {
      final String response = await rootBundle.loadString('assets/riwayat_pengajuan.json');
      final data = await json.decode(response);
      
      final nodinList = data['data']['nota_dinas'] as List;
      final sptList = data['data']['spt'] as List;

      int disetujui = 0;
      int berjalan = 0;
      int ditolak = 0;

      double totalNodinHours = 0;
      int countNodinFinished = 0;

      double totalSptHours = 0;
      int countSptFinished = 0;

      void processItem(Map<String, dynamic> item, bool isNodin) {
        if (item['status'] == 'DISETUJUI') disetujui++;
        else if (item['status'] == 'PROSES') berjalan++;
        else if (item['status'] == 'DITOLAK') ditolak++;

        if (item['status'] == 'DISETUJUI' || item['status'] == 'DITOLAK') {
           final tglStStr = item['tgl_st']; 
           final tglSt = DateTime.tryParse(tglStStr ?? '');
           
           final riwayat = item['detail']['riwayat_pemeriksaan'] as List;
           if (riwayat.isNotEmpty && tglSt != null) {
              String lastWaktuStr = '';
              for (var r in riwayat) {
                 if (r['waktu'] != null && r['waktu'].toString().isNotEmpty) {
                    lastWaktuStr = r['waktu'].toString();
                    break;
                 }
              }
              final lastWaktu = _parseIndoDate(lastWaktuStr);
              if (lastWaktu != null) {
                 final diff = lastWaktu.difference(tglSt).inHours;
                 if (isNodin) {
                    totalNodinHours += diff > 0 ? diff : 0;
                    countNodinFinished++;
                 } else {
                    totalSptHours += diff > 0 ? diff : 0;
                    countSptFinished++;
                 }
              }
           }
        }
      }

      for (var item in nodinList) {
        processItem(item, true);
      }
      for (var item in sptList) {
        processItem(item, false);
      }

      double avgNodin = countNodinFinished > 0 ? (totalNodinHours / countNodinFinished) / 24.0 : 0.0;
      double avgSpt = countSptFinished > 0 ? (totalSptHours / countSptFinished) / 24.0 : 0.0;

      if (mounted) {
        setState(() {
          _totalNodin = nodinList.length;
          _totalSpt = sptList.length;
          _totalDisetujui = disetujui;
          _totalBerjalan = berjalan;
          _totalDitolak = ditolak;
          _avgDurationNodin = avgNodin;
          _avgDurationSpt = avgSpt;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showFilterDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => FilterAnalitikDialog(
        initialPeriode: _selectedPeriode,
        initialDinas: _selectedDinas,
        showDinasFilter: false,
      ),
    );
    if (result != null) {
      setState(() {
        _selectedPeriode = result['periode'] as String;
        _selectedDinas = result['dinas'] as String?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPejabat =
        Provider.of<AuthProvider>(context, listen: false).user?.isPejabat ??
        false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 260,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF132F53), Color(0xFF5A84AB)],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child: Center(
                    child: Text(
                      'Dashboard Analitik',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        top: 32,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(32),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 25,
                                spreadRadius: 0,
                                offset: const Offset(0, -8),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 48, 16, 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Analitik Pengajuan Saya',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF0F2E59),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildRingkasanSection(),
                                const SizedBox(height: 12),
                                _buildStatusPengajuanCard(),
                                const SizedBox(height: 12),
                                _buildDurasiPenyelesaianCard(),
                                const SizedBox(height: 12),
                                _buildAIEstimationCard(isPejabat),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 9,
                        left: 16,
                        right: 16,
                        child: _buildToggleRow(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 1),
    );
  }

  Widget _buildToggleRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/analisis'),
                    child: Center(
                      child: Text(
                        'Persetujuan',
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.09),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Pengajuan',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF132F53),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _showFilterDialog(context),
              child: Container(
                height: 44,
                width: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF132F53),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Filter',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRingkasanSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan',
            style: GoogleFonts.inter(
              color: const Color(0xFF0F2E59),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          _isLoading 
              ? const Center(child: CircularProgressIndicator()) 
              : Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9EE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nota Dinas',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFDB913),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_totalNodin',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF0F2E59),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Pengajuan',
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F7FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SPT',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF0088FF),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_totalSpt',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF0F2E59),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Pengajuan',
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPengajuanCard() {
    bool isEmpty = (_totalDisetujui + _totalBerjalan + _totalDitolak) == 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Pengajuan',
            style: GoogleFonts.inter(
              color: const Color(0xFF0F2E59),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 30,
                    startDegreeOffset: -90,
                    sections: isEmpty
                        ? [
                            PieChartSectionData(
                              color: Colors.grey.shade200,
                              value: 1,
                              title: '',
                              radius: 15,
                            )
                          ]
                        : [
                            if (_totalDisetujui > 0)
                              PieChartSectionData(
                                color: const Color(0xFFD3FBD4),
                                value: _totalDisetujui.toDouble(),
                                title: '',
                                radius: 15,
                              ),
                            if (_totalBerjalan > 0)
                              PieChartSectionData(
                                color: const Color(0xFFFEF9C3),
                                value: _totalBerjalan.toDouble(),
                                title: '',
                                radius: 15,
                              ),
                            if (_totalDitolak > 0)
                              PieChartSectionData(
                                color: const Color(0xFFFFEBEE),
                                value: _totalDitolak.toDouble(),
                                title: '',
                                radius: 15,
                              ),
                          ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildStatusRow(
                      'Disetujui',
                      '$_totalDisetujui',
                      const Color(0xFFD3FBD4),
                      const Color(0xFF125B2A),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusRow(
                      'Berjalan',
                      '$_totalBerjalan',
                      const Color(0xFFFEF9C3),
                      const Color(0xFFD4A72C),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusRow(
                      'Ditolak',
                      '$_totalDitolak',
                      const Color(0xFFFFEBEE),
                      const Color(0xFFE53935),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(
    String label,
    String count,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
          Row(
            children: [
              Text(
                count,
                style: GoogleFonts.inter(
                  color: const Color(0xFF0F2E59),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Pengajuan',
                style: GoogleFonts.inter(
                  color: Colors.grey.shade500,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDurasiPenyelesaianCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rata - rata Durasi Penyelesaian',
            style: GoogleFonts.inter(
              color: const Color(0xFF0F2E59),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nota Dinas',
                style: GoogleFonts.inter(
                  color: const Color(0xFF0F2E59),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _avgDurationNodin > 0 ? (_avgDurationNodin / 5.0).clamp(0.0, 1.0) : 0.0,
                        backgroundColor: Colors.grey.shade100,
                        color: const Color(0xFFFDE08B),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_avgDurationNodin.toStringAsFixed(1)} Hari',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF0F2E59),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'SPT',
                style: GoogleFonts.inter(
                  color: const Color(0xFF0F2E59),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _avgDurationSpt > 0 ? (_avgDurationSpt / 5.0).clamp(0.0, 1.0) : 0.0,
                        backgroundColor: Colors.grey.shade100,
                        color: const Color(0xFFBCE0FD),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_avgDurationSpt.toStringAsFixed(1)} Hari',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF0F2E59),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- KARTU AI ETA PREDICTION (DIPERBARUI) ---
  Widget _buildAIEstimationCard(bool isPejabat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFF0088FF), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'AI Prediksi Selesai',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF0F2E59),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _loadEtaPrediction,
                child: const Icon(Icons.refresh, color: Colors.grey, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _isLoadingEta
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              : _activePredictions.isEmpty
                  ? Center(
                      child: Text(
                        "Tidak ada pengajuan berjalan saat ini",
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : Column(
                      children: _activePredictions.map((prediksi) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F7FA),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFBCE0FD)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.description_outlined, color: Color(0xFF0088FF), size: 16),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      prediksi['title'],
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF0F2E59),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      prediksi['is_error'] == false
                                          ? 'Estimasi: ${prediksi['eta_label']}'
                                          : 'Status: Berjalan (${prediksi['error_msg']})',
                                      style: GoogleFonts.inter(
                                        color: prediksi['is_error'] ? Colors.red : const Color(0xFF0088FF),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
        ],
      ),
    );
  }
}