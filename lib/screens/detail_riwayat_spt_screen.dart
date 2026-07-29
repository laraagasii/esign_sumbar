import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../custom_bottom_navbar.dart';

class DetailRiwayatSptScreen extends StatefulWidget {
  final String approvalStatus;
  final String sekretarisStatus;
  final String note;

  const DetailRiwayatSptScreen({
    super.key,
    this.approvalStatus = 'Proses',
    this.sekretarisStatus = 'Belum Diperiksa',
    this.note = '',
  });

  @override
  State<DetailRiwayatSptScreen> createState() => _DetailRiwayatSptScreenState();
}

class _DetailRiwayatSptScreenState extends State<DetailRiwayatSptScreen> {
  // Variabel untuk menyimpan Nomor Surat (Ubah menjadi null atau "" untuk test kondisi)
  final String? _nomorSurat = "094.2/130/Diskominfotik/II/2024";

  // List Riwayat Pemeriksaan Dinamis
  late List<Map<String, dynamic>> _riwayatList;

  @override
  void initState() {
    super.initState();

    Color secStatusBg;
    Color secStatusColor;
    IconData secIcon;
    Color secIconBg;
    Color secIconColor;
    String secDescription;

    if (widget.sekretarisStatus == 'Disetujui') {
      secStatusBg = const Color(0xFFD3FBD4);
      secStatusColor = const Color(0xFF125B2A);
      secIcon = Icons.check;
      secIconBg = const Color(0xFFD3FBD4);
      secIconColor = const Color(0xFF125B2A);
      secDescription = widget.note.isNotEmpty
          ? "Catatan: ${widget.note}"
          : "Catatan: Disetujui oleh Sekretaris";
    } else if (widget.sekretarisStatus == 'Ditolak') {
      secStatusBg = const Color(0xFFFFEBEE);
      secStatusColor = const Color(0xFFE53935);
      secIcon = Icons.close;
      secIconBg = const Color(0xFFFFEBEE);
      secIconColor = const Color(0xFFE53935);
      secDescription = widget.note.isNotEmpty
          ? "Catatan: ${widget.note}"
          : "Catatan: Ditolak oleh Sekretaris";
    } else {
      secStatusBg = const Color(0xFFFEF9C3);
      secStatusColor = const Color(0xFFD4A72C);
      secIcon = Icons.access_time_rounded;
      secIconBg = const Color(0xFFFEF9C3);
      secIconColor = const Color(0xFFD4A72C);
      secDescription = "Catatan: -";
    }

    _riwayatList = [
      // 0. KEPALA DINAS (Paling Atas)
      {
        "icon": widget.sekretarisStatus == 'Disetujui'
            ? Icons.access_time_rounded
            : Icons.remove_done,
        "iconBg": widget.sekretarisStatus == 'Disetujui'
            ? const Color(0xFFFEF9C3)
            : Colors.grey.shade200,
        "iconColor": widget.sekretarisStatus == 'Disetujui'
            ? const Color(0xFFD4A72C)
            : Colors.grey.shade500,
        "title": "Andi Setiawan (Kepala Dinas Komunikasi, Informatika dan Statistik)",
        "description": "Catatan: -",
        "time": "-",
        "actionLabel": "Tahap: Pemeriksaan Kepala Dinas",
        "statusText": widget.sekretarisStatus == 'Disetujui'
            ? "Belum Diperiksa"
            : "Menunggu",
        "statusBg": widget.sekretarisStatus == 'Disetujui'
            ? const Color(0xFFFEF9C3)
            : Colors.grey.shade200,
        "statusColor": widget.sekretarisStatus == 'Disetujui'
            ? const Color(0xFFD4A72C)
            : Colors.grey.shade600,
      },
      // 1. SEKRETARIS
      {
        "icon": secIcon,
        "iconBg": secIconBg,
        "iconColor": secIconColor,
        "title": "Sekretaris (Anda)",
        "description": secDescription,
        "time": widget.sekretarisStatus == 'Proses' ? "-" : "Kamis, 08 Agustus 2026 14:10:28",
        "actionLabel": "Tahap: Pemeriksaan Sekretaris",
        "statusText": widget.sekretarisStatus == 'Proses' ? "Belum Diperiksa" : widget.sekretarisStatus,
        "statusBg": secStatusBg,
        "statusColor": secStatusColor,
      },
      // 2. KEPALA BIDANG
      {
        "icon": Icons.check,
        "iconBg": const Color(0xFFD3FBD4),
        "iconColor": const Color(0xFF125B2A),
        "title": "Budi Santoso (Kepala Bidang Siber dan Sandi)",
        "description": "Catatan: Diteruskan ke Sekretaris",
        "time": "Rabu, 07 Agustus 2026 13:40:07",
        "actionLabel": "Tahap: Pemeriksaan Kepala Bidang",
        "actionColor": const Color(0xFFD4A72C),
        "statusText": "Disetujui",
        "statusBg": const Color(0xFFD3FBD4),
        "statusColor": const Color(0xFF125B2A),
      },
      // 3. STAFF
      {
        "icon": Icons.check,
        "iconBg": const Color(0xFFD3FBD4),
        "iconColor": const Color(0xFF125B2A),
        "title": "Dedi (Staff Bidang Siber dan Sandi)",
        "description": "Catatan: Pengajuan SPT",
        "time": "Rabu, 07 Agustus 2026 13:29:47",
        "actionLabel": "Tahap: Pembuatan Pengajuan",
        "actionColor": const Color(0xFFD4A72C),
        "statusText": "Disetujui",
        "statusBg": const Color(0xFFD3FBD4),
        "statusColor": const Color(0xFF125B2A),
      },
    ];
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
                          "Detail Riwayat SPT", // Mengikuti gambar referensi
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
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Ubah ke center untuk badge nomor
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
                                "09 Agustus 2024",
                                const Color(0xFFFEF9C3),
                                const Color(0xFFD4A72C),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // --- BADGE NOMOR SURAT DINAMIS ---
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD3FBD4), // Hijau muda
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              // Logika: Jika null/kosong tampilkan teks default
                              (_nomorSurat != null && _nomorSurat.isNotEmpty)
                                  ? _nomorSurat
                                  : "Nomor belum tersedia",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF125B2A), // Hijau tua
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
    return _buildSectionCard(
      title: "Detail Informasi",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Pemeriksa", "Kepala Bidang Siber dan Sandi"),
          const SizedBox(height: 10),
          _buildInfoRow("OPD", "Dinas Komunikasi, Informatika, dan Statistika"),
          const SizedBox(height: 10),
          _buildInfoRow("Tujuan", "Padang"),
          const SizedBox(height: 10),
          _buildInfoRow("Keberangkatan", "08 - 10 Agustus 2024"),

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
            "Permohonan persetujuan melaksanakan perjalanan dinas dalam kota dalam rangka memfasilitasi pembuatan Tanda Tangan Elektronik (TTE) untuk seluruh ASN Sekretariat Daerah Sumatera Barat (Biro Administrasi Pembangunan, Biro Organisasi, Biro Umum dan Biro Administrasi dan Pimpinan).",
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 16),

          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE5E7EB),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 10,
                ),
              ),
              child: Text(
                "Isi Surat",
                style: GoogleFonts.inter(
                  color: const Color(0xFF1F2937),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          _buildInfoRow("Kendaraan", "Kendaraan Dinas /BA 1241 HJ"),
          const SizedBox(height: 10),
          _buildInfoRow(
            "Pembiayaan",
            "2.16.011.05.0006 /\nPenyelenggaraan Rapat Koordinasi dan Konsultasi SKPD",
          ),
        ],
      ),
    );
  }

  Widget _buildPengikutSection() {
    return _buildSectionCard(
      title: "Pengikut (6)",
      child: Column(
        children: [
          _buildPengikutCard(
            name: "Eko Faisal, S.Kom.,M.M.",
            nip: "19730523 1234256 2 004",
            role: "Kepala Bidang Aplikasi dan Informatika",
          ),
          _buildPengikutCard(
            name: "Boby Charma, S.Kom.",
            nip: "19830523 1234256 2 004",
            role: "Kepala Seksi Tata Kelola Keamanan Siber dan Sandi",
          ),
          _buildPengikutCard(
            name: "David Rainir Pratama, S.Kom.",
            nip: "19430523 1234256 2 004",
            role: "Pengadministrasi Umum",
          ),
          _buildPengikutCard(
            name: "Andry Kurniawan, S.Kom",
            nip: "19430523 1234256 2 004",
            role: "Pranata Komputer",
          ),
          _buildPengikutCard(
            name: "Alimir",
            nip: "19430523 1234256 2 004",
            role: "Pengadministrasi Umum",
          ),
          _buildPengikutCard(
            name: "Fajri Kurniawan",
            nip: "19430523 1234256 2 004",
            role: "Tim IT",
          ),
        ],
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            if (showTimelineLine)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  children: List.generate(
                    4,
                    (index) => Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: iconColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF132F53),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
                if (time.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
                if (actionLabel != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    actionLabel,
                    style: GoogleFonts.inter(
                      color: actionColor ?? const Color(0xFFD4A72C),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                if (statusText != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      statusText,
                      style: GoogleFonts.inter(
                        color: statusColor,
                        fontSize: 10,
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
