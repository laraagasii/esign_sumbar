import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailRiwayatNotaDinasScreen extends StatefulWidget {
  final List<dynamic> pengikutTerpilih;
  final List<dynamic> pengikutDibatalkan;

  const DetailRiwayatNotaDinasScreen({
    super.key,
    required this.pengikutTerpilih,
    required this.pengikutDibatalkan,
  });

  @override
  State<DetailRiwayatNotaDinasScreen> createState() =>
      _DetailRiwayatNotaDinasScreenState();
}

class _DetailRiwayatNotaDinasScreenState
    extends State<DetailRiwayatNotaDinasScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  final String _dummyPin = "123456";

  // List Riwayat Pemeriksaan Dinamis (Index 1 adalah posisi Sekretaris)
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
        "title": "Kepala Dinas Komunikasi,\nInformatika dan Statistik",
        "description": "Menunggu persetujuan Sekretaris terlebih dahulu",
        "time": "Kamis, 08 Agustus 2026 14:10:28",
        "actionLabel": "Mohon Persetujuan",
        "statusText": "Belum Diperiksa",
        "statusBg": const Color(0xFFFEF9C3),
        "statusColor": const Color(0xFFD4A72C),
      },
      // 1. SEKRETARIS (Posisi Kita - Ini yang akan berubah saat disetujui & dicatat)
      {
        "icon": Icons.access_time_rounded,
        "iconBg": const Color(0xFFFEF9C3),
        "iconColor": const Color(0xFFD4A72C),
        "title": "Sekretaris",
        "description": "Menunggu pemeriksaan & persetujuan Sekretaris",
        "time": "Kamis, 08 Agustus 2026 14:10:28",
        "actionLabel": "Mohon Persetujuan",
        "statusText": "Belum Diperiksa",
        "statusBg": const Color(0xFFFEF9C3),
        "statusColor": const Color(0xFFD4A72C),
      },
      // 2. KEPALA BIDANG
      {
        "icon": Icons.check,
        "iconBg": const Color(0xFFD3FBD4),
        "iconColor": const Color(0xFF125B2A),
        "title": "Kepala Bidang Siber dan Sandi",
        "description": "Diteruskan ke Sekretaris",
        "time": "Rabu, 07 Agustus 2026 13:40:07",
        "actionLabel": "Mohon Persetujuan",
        "statusText": "Diperiksa",
        "statusBg": const Color(0xFFD3FBD4),
        "statusColor": const Color(0xFF125B2A),
      },
      // 3. STAFF
      {
        "icon": Icons.check,
        "iconBg": const Color(0xFFD3FBD4),
        "iconColor": const Color(0xFF125B2A),
        "title": "Staff Bidang Siber dan Sandi",
        "description": "Diteruskan ke Kepala Bidang Siber dan Sandi",
        "time": "Rabu, 07 Agustus 2026 13:29:47",
        "actionLabel": "Mengajukan Nota Dinas",
        "actionColor": const Color(0xFFD4A72C),
        "statusText": "Diteruskan",
        "statusBg": const Color(0xFFE3F2FD),
        "statusColor": const Color(0xFF1976D2),
      },
    ];
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          "Detail Riwayat Persetujuan Nota Dinas",
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
                          color: Colors.black.withOpacity(0.12),
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
                                "05 Agustus 2026",
                                const Color(0xFFFEF9C3),
                                const Color(0xFFD4A72C),
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
                                  "Kepada",
                                  "Kepala Dinas Komunikasi, Informatika dan Statistik",
                                ),
                                const SizedBox(height: 10),
                                _buildInfoRow(
                                  "Dari",
                                  "Kepala Bidang Sandi dan Siber",
                                ),
                                const SizedBox(height: 10),
                                _buildInfoRow("Tujuan", "Padang"),
                                const SizedBox(height: 10),
                                _buildInfoRow(
                                  "Tanggal Pelaksanaan",
                                  "5 Agustus 2026",
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
                                  "Permohonan persetujuan melaksanakan perjalanan dinas dalam kota dalam rangka memfasilitasi pembuatan Tanda Tangan Elektronik (TTE) untuk seluruh ASN Sekretariat Daerah Sumatera Barat.",
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildSectionCard(
                            title:
                                "Pengikut (${widget.pengikutTerpilih.length})",
                            child: widget.pengikutTerpilih.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Tidak ada pengikut yang dipilih.",
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: widget.pengikutTerpilih.length,
                                    itemBuilder: (context, index) {
                                      final pengikut =
                                          widget.pengikutTerpilih[index];
                                      return _buildMemberCard(
                                        pengikut['name'] ?? 'Tanpa Nama',
                                        pengikut['badge'] ?? '-',
                                        pengikut['role'] ?? '-',
                                      );
                                    },
                                  ),
                          ),
                          const SizedBox(height: 20),
                          _buildSectionCard(
                            title:
                                "Dibatalkan (${widget.pengikutDibatalkan.length})",
                            child: widget.pengikutDibatalkan.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Tidak ada pengikut yang dibatalkan.",
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: widget.pengikutDibatalkan.length,
                                    itemBuilder: (context, index) {
                                      final batal =
                                          widget.pengikutDibatalkan[index];
                                      return _buildCanceledMemberCard(
                                        batal['name'] ?? 'Tanpa Nama',
                                        batal['badge'] ?? '-',
                                        batal['role'] ?? '-',
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
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _showKonfirmasiDialog(
                                    context,
                                    isApprove: true,
                                  ),
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
                                    "Setuju",
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
                                  onPressed: () => _showKonfirmasiDialog(
                                    context,
                                    isApprove: false,
                                  ),
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

  Widget _buildMemberCard(String name, String badge, String role) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
                  role,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  badge,
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

  Widget _buildCanceledMemberCard(String name, String badge, String role) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.person_outline_rounded,
            color: Color(0xFFE53935),
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
                    color: const Color(0xFFE53935),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  badge,
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
  // MODAL RIWAYAT PEMERIKSAAN (Dinamis dari _riwayatList)
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
                          description: item['description'],
                          time: item['time'],
                          actionLabel: item['actionLabel'],
                          actionColor: item['actionColor'],
                          statusText: item['statusText'],
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
    String? description,
    required String time,
    String? actionLabel,
    Color? actionColor,
    String? statusText,
    Color? statusBg,
    Color? statusColor,
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
                height: 105,
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
                if (description != null) ...[
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
                const SizedBox(height: 4),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
                if (actionLabel != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    actionLabel,
                    style: GoogleFonts.inter(
                      color: actionColor ?? const Color(0xFFD4A72C),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                if (statusText != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
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
  void _showKonfirmasiDialog(BuildContext context, {required bool isApprove}) {
    _passwordController.clear();
    _catatanController.clear();

    String title = isApprove
        ? "Konfirmasi Persetujuan Nota Dinas"
        : "Konfirmasi Penolakan Nota Dinas";
    String confirmText = isApprove
        ? "Apakah anda yakin menyetujui nota dinas ini?"
        : "Apakah anda yakin menolak nota dinas ini?";
    String btnLabel = isApprove ? "Setuju" : "Tolak";
    Color btnBgColor = isApprove
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFEBEE);
    Color btnTextColor = isApprove
        ? const Color(0xFF2E7D32)
        : const Color(0xFFC62828);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF132F53),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Masukkan Password (PIN: 123456)",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Contoh: 123456",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF132F53),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Tambahkan Catatan",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _catatanController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: "Tulis catatan verifikasi...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF132F53),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        confirmText,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "Kembali",
                                style: GoogleFonts.inter(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_passwordController.text != _dummyPin) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Password / PIN salah! Gunakan: 123456",
                                      ),
                                      backgroundColor: Color(0xFFE53935),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }

                                DateTime now = DateTime.now();
                                String formattedDate =
                                    "Kamis, 08 Agustus 2026 ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

                                // Mengambil teks catatan yang diketik user
                                String catatanInput = _catatanController.text
                                    .trim();
                                String finalDescription =
                                    catatanInput.isNotEmpty
                                    ? "Catatan: $catatanInput"
                                    : (isApprove
                                          ? "Diteruskan ke Kepala Dinas Komunikasi, Informatika dan Statistik"
                                          : "Nota Dinas ditolak oleh Sekretaris");

                                Map<String, dynamic> riwayatSekretarisBaru = {
                                  "icon": isApprove
                                      ? Icons.check
                                      : Icons.close_rounded,
                                  "iconBg": isApprove
                                      ? const Color(0xFFD3FBD4)
                                      : const Color(0xFFFFEBEE),
                                  "iconColor": isApprove
                                      ? const Color(0xFF125B2A)
                                      : const Color(0xFFE53935),
                                  "title": "Sekretaris",
                                  "description":
                                      finalDescription, // Catatan masuk ke sini
                                  "time": formattedDate,
                                  "actionLabel": isApprove
                                      ? "Disetujui Sekretaris"
                                      : "Ditolak Sekretaris",
                                  "actionColor": isApprove
                                      ? const Color(0xFF125B2A)
                                      : const Color(0xFFE53935),
                                  "statusText": isApprove
                                      ? "Diperiksa"
                                      : "Ditolak",
                                  "statusBg": isApprove
                                      ? const Color(0xFFD3FBD4)
                                      : const Color(0xFFFFEBEE),
                                  "statusColor": isApprove
                                      ? const Color(0xFF125B2A)
                                      : const Color(0xFFE53935),
                                };

                                // Memperbarui state list riwayat di index 1 (Sekretaris)
                                setState(() {
                                  _riwayatList[1] = riwayatSekretarisBaru;
                                });

                                Navigator.pop(
                                  dialogContext,
                                ); // Tutup dialog konfirmasi

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isApprove
                                          ? "Nota Dinas berhasil disetujui!"
                                          : "Nota Dinas ditolak.",
                                    ),
                                    backgroundColor: isApprove
                                        ? const Color(0xFF125B2A)
                                        : const Color(0xFFE53935),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: btnBgColor,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                btnLabel,
                                style: GoogleFonts.inter(
                                  color: btnTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
