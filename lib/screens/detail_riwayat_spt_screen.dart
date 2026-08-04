import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../custom_bottom_navbar.dart';
import '../services/spt_service.dart';

class DetailRiwayatSptScreen extends StatefulWidget {
  final String userId;
  final String sptId;
  final String tahun;
  final String tipe;

  const DetailRiwayatSptScreen({
    super.key,
    required this.userId,
    required this.sptId,
    required this.tahun,
    required this.tipe,
  });

  @override
  State<DetailRiwayatSptScreen> createState() => _DetailRiwayatSptScreenState();
}

class _DetailRiwayatSptScreenState extends State<DetailRiwayatSptScreen> {
  bool _isLoading = true;
  String _errorMessage = '';
  Map<String, dynamic>? _detailData;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final data = await SptService().fetchSptDetail(
        id: widget.userId,
        year: widget.tahun,
        tipe: widget.tipe,
        token: widget.sptId,
      );
      if (mounted) {
        setState(() {
          _detailData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          "Detail Riwayat SPT",
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
                    child: _buildBodyContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
    );
  }

  Widget _buildBodyContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                "Gagal Memuat Data",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = '';
                  });
                  _fetchDetail();
                },
                child: const Text("Coba Lagi"),
              ),
            ],
          ),
        ),
      );
    }

    if (_detailData == null) {
      return const Center(child: Text("Data tidak tersedia"));
    }

    final result = _detailData!['result'] as Map<String, dynamic>? ?? {};

    final nmKategori = result['nm_kategori']?.toString() ?? '-';
    final tglSpt = result['tgl_spt']?.toString() ?? '-';
    final noSpt = result['no_spt']?.toString() ?? 'Belum Ada Nomor';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTopBadge(
                nmKategori,
                const Color(0xFFD3FBD4),
                const Color(0xFF125B2A),
              ),
              const SizedBox(width: 8),
              _buildTopBadge(
                tglSpt,
                const Color(0xFFFEF9C3),
                const Color(0xFFD4A72C),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFD3FBD4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              noSpt,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: const Color(0xFF125B2A),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          _buildDasarSptSection(),
          const SizedBox(height: 20),
          _buildDetailInformasiSection(result),
          const SizedBox(height: 20),
          _buildPengikutSection(),
          const SizedBox(height: 24),

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
          const SizedBox(height: 30),
        ],
      ),
    );
  }

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

  Widget _buildDasarSptSection() {
    final dasarList = _detailData!['dasar'] as List<dynamic>? ?? [];

    if (dasarList.isEmpty) {
      return _buildSectionCard(
        title: "Dasar SPT",
        child: const Center(child: Text("Tidak ada dasar SPT")),
      );
    }

    return _buildSectionCard(
      title: "Dasar SPT",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: dasarList.asMap().entries.map((entry) {
          int index = entry.key;
          String val = entry.value.toString();
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == dasarList.length - 1 ? 0 : 10,
            ),
            child: _buildNumberedText("${index + 1}.", val),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDetailInformasiSection(Map<String, dynamic> result) {
    final pemeriksa = result['pemeriksa']?.toString() ?? '-';
    final nmOpd = result['nm_opd']?.toString() ?? '-';
    final keberangkatan = result['tgl_dinas']?.toString() ?? '-';
    final perihal = result['maksud_spt']?.toString() ?? '-';
    final kendaraan = result['kendaraan']?.toString() ?? '-';
    final pembiayaan = result['pembiayaan']?.toString() ?? '-';

    return _buildSectionCard(
      title: "Detail Informasi",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Pemeriksa", pemeriksa),
          const SizedBox(height: 10),
          _buildInfoRow("OPD", nmOpd),
          const SizedBox(height: 10),
          _buildInfoRow("Keberangkatan", keberangkatan),
          const Divider(height: 24, thickness: 1),

          _buildInfoRow("Kendaraan", kendaraan),
          const SizedBox(height: 10),
          _buildInfoRow("Pembiayaan", pembiayaan),
        ],
      ),
    );
  }

  Widget _buildPengikutSection() {
    final pegawaiList = _detailData!['pegawai'] as List<dynamic>? ?? [];

    if (pegawaiList.isEmpty) {
      return _buildSectionCard(
        title: "Pengikut (0)",
        child: const Center(child: Text("Tidak ada pengikut")),
      );
    }

    return _buildSectionCard(
      title: "Pengikut (${pegawaiList.length})",
      child: Column(
        children: pegawaiList.map((p) {
          final pMap = p as Map<String, dynamic>? ?? {};
          final name = pMap['nama_asn']?.toString() ?? '-';
          final nip = pMap['nip_asn']?.toString() ?? '';
          final role = pMap['jabatan']?.toString() ?? '-';
          return _buildPengikutCard(
            name: name,
            nip: nip.isNotEmpty ? nip : "-",
            role: role,
          );
        }).toList(),
      ),
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
                  nip.startsWith("NIP") ? nip : "NIP. $nip",
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

  void _showRiwayatPemeriksaan(BuildContext context) {
    final riwayatListRaw = _detailData!['riwayat'] as List<dynamic>? ?? [];

    // Parse riwayat to UI model
    final List<Map<String, dynamic>> riwayatUiList = [];

    for (var r in riwayatListRaw) {
      final rMap = r as Map<String, dynamic>? ?? {};
      final tindakan = rMap['tindakan']?.toString().toLowerCase() ?? '';
      final jabatan = rMap['jabatan']?.toString() ?? '-';
      final tanggal = rMap['tanggal']?.toString() ?? '-';
      final status = rMap['status']?.toString() ?? '-';
      final catatan = rMap['catatan']?.toString() ?? '-';
      final teruskan = rMap['teruskan']?.toString() ?? '';

      bool isDisetujui = tindakan.contains('setuju');
      bool isDitolak = tindakan.contains('tolak');

      Color iconBg;
      Color iconColor;
      IconData iconData;
      Color statusBg;
      Color statusColor;

      if (isDisetujui) {
        iconBg = const Color(0xFFD3FBD4);
        iconColor = const Color(0xFF125B2A);
        iconData = Icons.check;
        statusBg = const Color(0xFFD3FBD4);
        statusColor = const Color(0xFF125B2A);
      } else if (isDitolak) {
        iconBg = const Color(0xFFFFEBEE);
        iconColor = const Color(0xFFE53935);
        iconData = Icons.close;
        statusBg = const Color(0xFFFFEBEE);
        statusColor = const Color(0xFFE53935);
      } else {
        iconBg = const Color(0xFFFEF9C3);
        iconColor = const Color(0xFFD4A72C);
        iconData = Icons.access_time_rounded;
        statusBg = const Color(0xFFFEF9C3);
        statusColor = const Color(0xFFD4A72C);
      }

      riwayatUiList.add({
        "icon": iconData,
        "iconBg": iconBg,
        "iconColor": iconColor,
        "title": jabatan,
        "teruskan": teruskan,
        "actionLabel": tindakan.isNotEmpty ? rMap['tindakan'] : "Menunggu",
        "actionColor": iconColor,
        "catatan": catatan,
        "time": tanggal,
        "statusBg": statusBg,
        "statusColor": statusColor,
      });
    }

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
                    child: riwayatUiList.isEmpty
                        ? const Center(
                            child: Text("Tidak ada riwayat pemeriksaan"),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                            itemCount: riwayatUiList.length,
                            itemBuilder: (context, index) {
                              final item = riwayatUiList[index];
                              final bool hasNext =
                                  index < riwayatUiList.length - 1;

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
}
