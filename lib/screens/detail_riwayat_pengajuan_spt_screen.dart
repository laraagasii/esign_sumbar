import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailRiwayatPengajuanSptScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailRiwayatPengajuanSptScreen({
    super.key,
    required this.data,
  });

  @override
  State<DetailRiwayatPengajuanSptScreen> createState() =>
      _DetailRiwayatPengajuanSptScreenState();
}

class _DetailRiwayatPengajuanSptScreenState
    extends State<DetailRiwayatPengajuanSptScreen> {
  late List<Map<String, dynamic>> _riwayatList;

  @override
  void initState() {
    super.initState();
    _riwayatList = _mapRiwayatPemeriksaan(widget.data['detail']?['riwayat_pemeriksaan']);
  }

  List<Map<String, dynamic>> _mapRiwayatPemeriksaan(dynamic riwayatData) {
    if (riwayatData == null || riwayatData is! List) return [];
    
    return riwayatData.map<Map<String, dynamic>>((item) {
      String status = item['status_code'] ?? 'MENUNGGU';
      String statusLabel = item['status_label'] ?? 'Menunggu';
      
      Color statusBg;
      Color statusColor;
      IconData icon;
      Color iconBg;
      Color iconColor;

      if (status.toUpperCase() == 'DISETUJUI' || status.toUpperCase() == 'DIPERIKSA') {
        statusBg = const Color(0xFFD3FBD4);
        statusColor = const Color(0xFF125B2A);
        icon = Icons.check;
        iconBg = const Color(0xFFD3FBD4);
        iconColor = const Color(0xFF125B2A);
        statusLabel = 'Disetujui';
      } else if (status.toUpperCase() == 'DITOLAK') {
        statusBg = const Color(0xFFFFEBEE);
        statusColor = const Color(0xFFE53935);
        icon = Icons.close;
        iconBg = const Color(0xFFFFEBEE);
        iconColor = const Color(0xFFE53935);
        statusLabel = 'Tidak Disetujui';
      } else if (status.toUpperCase() == 'BELUM_DIPERIKSA' || status.toUpperCase() == 'BELUM DIPERIKSA') {
        statusBg = const Color(0xFFFEF9C3);
        statusColor = const Color(0xFFD4A72C);
        icon = Icons.access_time_rounded;
        iconBg = const Color(0xFFFEF9C3);
        iconColor = const Color(0xFFD4A72C);
      } else {
        statusBg = Colors.grey.shade200;
        statusColor = Colors.grey.shade600;
        icon = Icons.remove_done;
        iconBg = Colors.grey.shade200;
        iconColor = Colors.grey.shade500;
      }

      return {
        "icon": icon,
        "iconBg": iconBg,
        "iconColor": iconColor,
        "title": (item['jabatan_pemeriksa'] ?? '-').toString().toUpperCase(),
        "description": item['keterangan'] ?? '',
        "time": item['waktu'] ?? '',
        "actionLabel": statusLabel,
        "actionColor": statusColor,
        "statusBg": statusBg,
        "statusColor": statusColor,
        "catatan": item['catatan'] ?? '',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.data['detail'] ?? {};
    final detailInfo = detail['detail_informasi'] ?? {};
    final pengikutRaw = detail['pengikut'];
    final pengikut = (pengikutRaw is List) 
        ? pengikutRaw 
        : (pengikutRaw != null && pengikutRaw.toString().trim().isNotEmpty 
            ? [pengikutRaw.toString()] 
            : []);
    
    String globalStatus = widget.data['status'] ?? 'PROSES';
    Color globalStatusBg = const Color(0xFFE5E7EB);
    Color globalStatusColor = const Color(0xFF132F53);
    if (globalStatus.toUpperCase() == 'DISETUJUI') {
      globalStatusBg = const Color(0xFFD3FBD4);
      globalStatusColor = const Color(0xFF125B2A);
      globalStatus = 'Disetujui';
    } else if (globalStatus.toUpperCase() == 'DITOLAK') {
      globalStatusBg = const Color(0xFFFFEBEE);
      globalStatusColor = const Color(0xFFE53935);
      globalStatus = 'Ditolak';
    } else {
      globalStatus = 'Proses';
    }

    String kategori = widget.data['kategori_label'] ?? '-';
    Color categoryBg = const Color(0xFFE3F2FD);
    Color categoryColor = const Color(0xFF0088FF);
    if (kategori.toLowerCase().contains('luar')) {
      categoryBg = const Color(0xFFFEF9C3);
      categoryColor = const Color(0xFFD4A72C);
    } else if (kategori.toLowerCase().contains('dalam kota')) {
      categoryBg = const Color(0xFFD3FBD4);
      categoryColor = const Color(0xFF125B2A);
    }

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
                          "Detail Pengajuan SPT",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
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
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 25,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildTopBadge(
                                    kategori,
                                    const Color(0xFFD3FBD4),
                                    const Color(0xFF125B2A),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildTopBadge(
                                    widget.data['tgl_st_formatted'] ?? '-',
                                    const Color(0xFFFEF9C3),
                                    const Color(0xFFD4A72C),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildTopBadge(
                                detailInfo['no_st'] ?? detail['no_st'] ?? '-',
                                const Color(0xFFD3FBD4),
                                const Color(0xFF125B2A),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildSectionCard(
                            title: "Detail Informasi",
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow(
                                  "Pemeriksa",
                                  detailInfo['pemeriksa'] ?? '-',
                                ),
                                const SizedBox(height: 10),
                                _buildInfoRow(
                                  "OPD",
                                  detailInfo['opd'] ?? '-',
                                ),
                                const SizedBox(height: 10),
                                _buildInfoRow("Tujuan", detailInfo['tujuan'] ?? '-'),
                                const SizedBox(height: 10),
                                _buildInfoRow(
                                  "Keberangkatan",
                                  detailInfo['keberangkatan'] ?? '-',
                                ),
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
                                  widget.data['maksud_spt'] ?? detailInfo['maksud_spt'] ?? detailInfo['perihal'] ?? widget.data['maksud'] ?? '-',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 16),
                                _buildInfoRow(
                                  "Kendaraan",
                                  detailInfo['kendaraan'] ?? '-',
                                ),
                                const SizedBox(height: 10),
                                _buildInfoRow(
                                  "Pembiayaan",
                                  detailInfo['pembiayaan'] ?? '-',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildSectionCard(
                            title: "Pengikut (${pengikut.length})",
                            child: pengikut.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
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
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: pengikut.length,
                                    itemBuilder: (context, index) {
                                      final p = pengikut[index];
                                      return _buildMemberCard(
                                        p['nama'] ?? 'Tanpa Nama',
                                        p['nip'] ?? '-',
                                        p['jabatan'] ?? '-',
                                      );
                                    },
                                  ),
                          ),
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
                    ),
                  ),
                ),
              ],
            ),
          ),
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
            color: Colors.black.withValues(alpha: 0.03),
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

  Widget _buildMemberCard(String name, String nip, String role) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.person_outline_rounded,
            color: Color(0xFF132F53),
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
                  nip,
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
                          title: item['title'] ?? '',
                          description: item['description'] ?? '',
                          actionLabel: item['actionLabel'] ?? '',
                          actionColor: item['actionColor'] ?? Colors.black,
                          catatan: item['catatan'] ?? '',
                          time: item['time'] ?? '',
                          statusBg: item['statusBg'] ?? Colors.white,
                          statusColor: item['statusColor'] ?? Colors.black,
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
    required String description,
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
                height: 140,
                color: const Color(0xFF828282).withValues(alpha: 0.3),
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
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    description,
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
