import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_bottom_navbar.dart';
import '../services/spt_service.dart';
import '../widgets/pin_signature_dialog.dart';
import '../widgets/rejection_dialog.dart';
import '../widgets/approval_dialog.dart';

class DetailSptScreen extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> sptItem;

  const DetailSptScreen({
    super.key,
    required this.userId,
    required this.sptItem,
  });

  @override
  State<DetailSptScreen> createState() => _DetailSptScreenState();
}

class _DetailSptScreenState extends State<DetailSptScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  final String _dummyPin = "123456";
  final SptService _sptService = SptService();

  bool _isLoadingDetail = true;
  String? _detailError;
  Map<String, dynamic>? _detailData;

  // List Riwayat Pemeriksaan Dinamis
  late List<Map<String, dynamic>> _riwayatList;

  @override
  void initState() {
    super.initState();
    _riwayatList = [
      // 0. KEPALA DINAS (Paling Atas)
      {
        "icon": Icons.access_time_rounded,
        "iconBg": const Color(0xFFFEF9C3),
        "iconColor": const Color(0xFFD4A72C),
        "title":
            "Andi Setiawan (Kepala Dinas Komunikasi, Informatika dan Statistik)",
        "teruskan": "",
        "actionLabel": "Belum Diperiksa",
        "actionColor": const Color(0xFFD4A72C),
        "catatan": "-",
        "time": "-",
        "statusBg": const Color(0xFFFEF9C3),
        "statusColor": const Color(0xFFD4A72C),
      },
      // 1. SEKRETARIS
      {
        "icon": Icons.access_time_rounded,
        "iconBg": const Color(0xFFFEF9C3),
        "iconColor": const Color(0xFFD4A72C),
        "title": "Sekretaris (Anda)",
        "teruskan": "",
        "actionLabel": "Belum Diperiksa",
        "actionColor": const Color(0xFFD4A72C),
        "catatan": "-",
        "time": "-",
        "statusBg": const Color(0xFFFEF9C3),
        "statusColor": const Color(0xFFD4A72C),
      },
      // 2. KEPALA BIDANG
      {
        "icon": Icons.check,
        "iconBg": const Color(0xFFD3FBD4),
        "iconColor": const Color(0xFF125B2A),
        "title": "Budi Santoso (Kepala Bidang Siber dan Sandi)",
        "teruskan": "Nota dinas diteruskan ke Sekretaris Daerah",
        "actionLabel": "Disetujui",
        "actionColor": const Color(0xFF125B2A),
        "catatan": "Diteruskan ke Sekretaris",
        "time": "Rabu, 07 Agustus 2026 13:40:07",
        "statusBg": const Color(0xFFD3FBD4),
        "statusColor": const Color(0xFF125B2A),
      },
      // 3. STAFF
      {
        "icon": Icons.check,
        "iconBg": const Color(0xFFD3FBD4),
        "iconColor": const Color(0xFF125B2A),
        "title": "Dedi (Staff Bidang Siber dan Sandi)",
        "teruskan": "Nota dinas diteruskan ke Kepala Bidang",
        "actionLabel": "Disetujui",
        "actionColor": const Color(0xFF125B2A),
        "catatan": "Pengajuan SPT",
        "time": "Rabu, 07 Agustus 2026 13:29:47",
        "statusBg": const Color(0xFFD3FBD4),
        "statusColor": const Color(0xFF125B2A),
      },
    ];
    _fetchSptDetail();
  }

  Future<void> _fetchSptDetail() async {
    final item = widget.sptItem;
    final year = item['year']?.toString() ?? DateTime.now().year.toString();
    final tipe = _mapCategoryToTipe(item['detailType']?.toString() ?? '');
    final token = item['token']?.toString() ?? item['id']?.toString() ?? '';

    try {
      final response = await _sptService.fetchSptDetail(
        id: widget.userId,
        year: year,
        tipe: tipe,
        token: token,
      );
      setState(() {
        _detailData = response;
        _detailError = null;
      });
    } catch (e) {
      setState(() {
        _detailError = e.toString();
      });
    } finally {
      setState(() {
        _isLoadingDetail = false;
      });
    }
  }

  String _mapCategoryToTipe(String category) {
    final normalized = category.toLowerCase();
    if (normalized.contains('dalam daerah') ||
        normalized == 'dl' ||
        normalized == 'dd') {
      return 'DL';
    }
    if (normalized.contains('dalam kota') || normalized == 'dk') {
      return 'DK';
    }
    if (normalized.contains('luar daerah') || normalized == 'ld') {
      return 'LD';
    }
    return category.toUpperCase();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final haveTteVal = _detailData?['have_tte'];
    final isTte =
        haveTteVal == '1' || haveTteVal == 'true' || haveTteVal == true;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. BACKGROUND BIRU HEADER
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

          // 2. KONTEN UTAMA
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // --- HEADER ---
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          "Detail SPT",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // --- CONTAINER PUTIH BERBAYANG ---
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 25,
                          spreadRadius: 0,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // --- BADGE STATUS DI ATAS ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTopBadge(
                                "Dalam Kota",
                                const Color(0xFFD3FBD4),
                                const Color(0xFF125B2A),
                              ),
                              const SizedBox(width: 8),
                              _buildTopBadge(
                                "08 Agustus 2024",
                                const Color(0xFFFEF9C3),
                                const Color(0xFFD4A72C),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          _buildDasarSptSection(),
                          const SizedBox(height: 20),
                          _buildDetailInformasiSection(),
                          const SizedBox(height: 20),
                          _buildPengikutSection(),
                          const SizedBox(height: 24),

                          // --- TOMBOL AKSI BAWAH ---
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed: () => _showRiwayatPemeriksaan(context),
                              child: Text(
                                "Lihat Riwayat Pemeriksaan",
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF132F53),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _handleApprove(isTte),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD3FBD4),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    isTte ? "Tanda Tangani (TTE)" : "Setuju",
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF125B2A),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _handleReject(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFEBEE),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Tolak",
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFE53935),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Menghubungkan Custom Bottom Navbar ke halaman ini
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
    );
  }

  // ====================================================
  // WIDGET HELPER SECTIONS
  // ====================================================

  Widget _buildDasarSptSection() {
    return _buildSectionCard(
      title: "Dasar SPT",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNumberedText(
            "1.",
            "Surat Kepala Dinas Dinas Penanaman Modal dan Pelayanan terpadu Satu Pintu Provinsi Sumatera Barat Nomor 570/324/DPMPTSP-2024 Tanggal 31 Juli 2024.",
          ),
          const SizedBox(height: 10),
          _buildNumberedText(
            "2.",
            "DPA-OPD Dinas Komunikasi, Informatika dan Statistik Provinsi Sumatera Barat Tahun Anggaran 2024.",
          ),
        ],
      ),
    );
  }

  Widget _buildDetailInformasiSection() {
    final detailInfo = _detailData?['detail']?['detail_informasi'] ?? {};

    return _buildSectionCard(
      title: "Detail Informasi",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Pemeriksa", detailInfo['pemeriksa'] ?? '-'),
          const SizedBox(height: 10),
          _buildInfoRow("OPD", detailInfo['opd'] ?? '-'),
          const SizedBox(height: 10),
          _buildInfoRow("Tujuan", detailInfo['tujuan'] ?? '-'),
          const SizedBox(height: 10),
          _buildInfoRow("Keberangkatan", detailInfo['keberangkatan'] ?? '-'),

          const Divider(height: 24, thickness: 1),

          Text(
            "Perihal :",
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.sptItem['maksud_spt'] ??
                detailInfo['maksud_spt'] ??
                detailInfo['perihal'] ??
                widget.sptItem['maksud'] ??
                '-',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 16),

          _buildInfoRow("Kendaraan", detailInfo['kendaraan'] ?? '-'),
          const SizedBox(height: 10),
          _buildInfoRow("Pembiayaan", detailInfo['pembiayaan'] ?? '-'),
        ],
      ),
    );
  }

  Widget _buildPengikutSection() {
    final pengikutRaw = _detailData?['detail']?['pengikut'];
    final pengikut = (pengikutRaw is List)
        ? pengikutRaw
        : (pengikutRaw != null && pengikutRaw.toString().trim().isNotEmpty
              ? [pengikutRaw.toString()]
              : []);

    return _buildSectionCard(
      title: "Pengikut (${pengikut.length})",
      child: pengikut.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  "Tidak ada pengikut.",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          : Column(
              children: pengikut.map((p) {
                return _buildPengikutCard(
                  name: p['nama'] ?? 'Tanpa Nama',
                  nip: p['nip'] ?? '-',
                  role: p['jabatan'] ?? '-',
                );
              }).toList(),
            ),
    );
  }

  // ====================================================
  // WIDGET HELPER KECIL
  // ====================================================

  Widget _buildTopBadge(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: GoogleFonts.inter(
                color: const Color(0xFF132F53),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildNumberedText(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: GoogleFonts.inter(
            color: Colors.grey.shade600,
            fontSize: 12,
            height: 1.4,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: Colors.grey.shade600,
              fontSize: 12,
              height: 1.4,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF132F53),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPengikutCard({
    required String name,
    required String nip,
    required String role,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF9C3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.person_outline_rounded,
            color: Color(0xFFD4A72C),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF132F53),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "NIP. $nip",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  role,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MODAL RIWAYAT PEMERIKSAAN
  // ==========================================
  void _showRiwayatPemeriksaan(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.67,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Riwayat Pemeriksaan",
                          style: GoogleFonts.inter(
                            color: const Color(0xFF132F53),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFF132F53),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      itemCount: _riwayatList.length,
                      itemBuilder: (context, index) {
                        final item = _riwayatList[index];
                        final bool hasNext = index < _riwayatList.length - 1;

                        return _buildRiwayatItem(
                          icon: item['icon'],
                          iconBg: item['iconBg'],
                          iconColor: item['iconColor'],
                          title: item['title'],
                          teruskan: item['teruskan'],
                          actionLabel: item['actionLabel'],
                          actionColor: item['actionColor'],
                          catatan: item['catatan'],
                          time: item['time'],
                          statusBg: item['statusBg'],
                          statusColor: item['statusColor'],
                          showTimelineLine: hasNext,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRiwayatItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String teruskan,
    required String actionLabel,
    required Color actionColor,
    required String catatan,
    required String time,
    required Color statusBg,
    required Color statusColor,
    required bool showTimelineLine,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            if (showTimelineLine)
              Container(
                width: 2,
                height: 140, // Increased slightly to accommodate all contents
                color: const Color(0xFF828282).withOpacity(0.3),
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF132F53),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (teruskan.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    teruskan,
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
                if (actionLabel.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    actionLabel,
                    style: GoogleFonts.inter(
                      color: actionColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                if (catatan.isNotEmpty && catatan != '-') ...[
                  const SizedBox(height: 6),
                  Text(
                    "Catatan:",
                    style: GoogleFonts.inter(
                      color: const Color(0xFF132F53),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    catatan,
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
                if (time.isNotEmpty && time != '-') ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Diperiksa : $time",
                      style: GoogleFonts.inter(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // DIALOG KONFIRMASI PIN & CATATAN SEKRETARIS
  // ==========================================
  void _handleApprove(bool isTte) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ApprovalDialog(
          onSubmit: (notes) {
            Navigator.pop(dialogContext); // Tutup dialog catatan

            if (isTte) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (pinContext) {
                  return PinSignatureDialog(
                    onSubmit: (pin) {
                      if (pin != _dummyPin) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("PIN salah! Gunakan: 123456"),
                            backgroundColor: Color(0xFFE53935),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      Navigator.pop(pinContext); // Tutup dialog PIN
                      _processAction(isApprove: true, catatan: notes);
                    },
                  );
                },
              );
            } else {
              _processAction(isApprove: true, catatan: notes);
            }
          },
        );
      },
    );
  }

  void _handleReject() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return RejectionDialog(
          onSubmit: (notes) {
            Navigator.pop(dialogContext); // Tutup dialog penolakan
            _processAction(isApprove: false, catatan: notes);
          },
        );
      },
    );
  }

  void _processAction({
    required bool isApprove,
    required String catatan,
  }) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 1)); // Mock API call
    if (!mounted) return;
    Navigator.pop(context); // Tutup loading

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isApprove
              ? "Dokumen berhasil ditandatangani secara elektronik"
              : "Dokumen berhasil ditolak",
        ),
        backgroundColor: isApprove
            ? const Color(0xFF2E7D32)
            : const Color(0xFFC62828),
      ),
    );

    // Update status history list based on approve or reject
    DateTime now = DateTime.now();
    String formattedDate =
        "Rabu, ${now.day.toString().padLeft(2, '0')} Agustus 2026 ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    Map<String, dynamic> riwayatSekretarisBaru = {
      "icon": isApprove ? Icons.check : Icons.close,
      "iconBg": isApprove ? const Color(0xFFD3FBD4) : const Color(0xFFFFEBEE),
      "iconColor": isApprove
          ? const Color(0xFF125B2A)
          : const Color(0xFFE53935),
      "title": "Sekretaris (Anda)",
      "description": "Catatan: $catatan",
      "time": formattedDate,
      "actionLabel": "Tahap: Pemeriksaan Sekretaris",
      "actionColor": isApprove
          ? const Color(0xFF125B2A)
          : const Color(0xFFE53935),
      "statusText": isApprove ? "Disetujui" : "Ditolak",
      "statusBg": isApprove ? const Color(0xFFD3FBD4) : const Color(0xFFFFEBEE),
      "statusColor": isApprove
          ? const Color(0xFF125B2A)
          : const Color(0xFFE53935),
    };

    Navigator.pop(context, {
      'status': isApprove ? 'Disetujui' : 'Ditolak',
      'note': catatan,
      'riwayatBaru': riwayatSekretarisBaru,
    });
  }
}
