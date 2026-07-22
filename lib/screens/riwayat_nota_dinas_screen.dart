import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyek_esign/filter_nota_dinas_dialog.dart';
import 'detail_riwayat_nota_dinas_screen.dart';

class RiwayatNotaDinasScreen extends StatefulWidget {
  const RiwayatNotaDinasScreen({super.key});

  @override
  State<RiwayatNotaDinasScreen> createState() => _RiwayatNotaDinasScreenState();
}

class _RiwayatNotaDinasScreenState extends State<RiwayatNotaDinasScreen> {
  // Filter kategori riwayat (Semua, Disetujui, Ditolak, Proses)
  String _selectedFilter = "Semua";

  // Variabel untuk menyimpan hasil filter dari pop-up dialog
  Map<String, dynamic>? _appliedFilters;

  // Controller untuk fitur Pencarian (Search)
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Dummy Data Riwayat Global (Ditambahkan field pengikut untuk menghindari null error)
  final List<Map<String, dynamic>> _riwayatList = [
    {
      "type": "Nota Dinas",
      "title": "Dinas Komunikasi, Informatika, dan Statistik",
      "desc":
          "Permohonan persetujuan perjalanan dinas dalam kota untuk memfasilitasi TTE ASN Setda Prov. Sumbar.",
      "date": "08 Agustus 2026, 14:30",
      "status": "Disetujui",
      "statusColor": const Color(0xFF125B2A),
      "statusBg": const Color(0xFFD3FBD4),
      "icon": Icons.check_circle_rounded,
      "pengikutTerpilih": [],
      "pengikutDibatalkan": [],
    },
    {
      "type": "SPT",
      "title": "Biro Umum Setda Prov. Sumbar",
      "desc":
          "Surat Perintah Tugas menghadiri rapat koordinasi persiapan kunjungan kerja pimpinan daerah ke Kabupaten Agam.",
      "date": "07 Agustus 2026, 10:15",
      "status": "Disetujui",
      "statusColor": const Color(0xFF125B2A),
      "statusBg": const Color(0xFFD3FBD4),
      "icon": Icons.check_circle_rounded,
      "pengikutTerpilih": [],
      "pengikutDibatalkan": [],
    },
    {
      "type": "Nota Dinas",
      "title": "Dinas Kesehatan Provinsi Sumatera Barat",
      "desc":
          "Evaluasi program layanan kesehatan semester pertama tahun 2026 di RS M. Djamil Padang.",
      "date": "06 Agustus 2026, 09:45",
      "status": "Ditolak",
      "statusColor": const Color(0xFFE53935),
      "statusBg": const Color(0xFFFFEBEE),
      "icon": Icons.cancel_rounded,
      "pengikutTerpilih": [],
      "pengikutDibatalkan": [],
    },
    {
      "type": "Nota Dinas",
      "title": "Dinas Pendidikan Provinsi Sumatera Barat",
      "desc":
          "Studi banding pengelolaan sekolah unggulan ke Bandung, Jawa Barat.",
      "date": "05 Agustus 2026, 16:00",
      "status": "Proses",
      "statusColor": const Color(0xFFD4A72C),
      "statusBg": const Color(0xFFFEF9C3),
      "icon": Icons.access_time_filled_rounded,
      "pengikutTerpilih": [],
      "pengikutDibatalkan": [],
    },
    {
      "type": "SPT",
      "title": "Dinas PUPR Provinsi Sumatera Barat",
      "desc":
          "Peninjauan proyek pembangunan infrastruktur jalan lintas kabupaten di Solok.",
      "date": "04 Agustus 2026, 11:20",
      "status": "Disetujui",
      "statusColor": const Color(0xFF125B2A),
      "statusBg": const Color(0xFFD3FBD4),
      "icon": Icons.check_circle_rounded,
      "pengikutTerpilih": [],
      "pengikutDibatalkan": [],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- LOGIKA FILTER (MENGGABUNGKAN SEARCH, CHIP, DAN DIALOG) ---
    final filteredList = _riwayatList.where((item) {
      // 1. Filter dari Pencarian Teks (Search Bar)
      bool matchSearch = true;
      if (_searchQuery.isNotEmpty) {
        final titleMatch = item["title"].toString().toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
        final descMatch = item["desc"].toString().toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
        matchSearch = titleMatch || descMatch;
      }

      // 2. Filter dari Chip Atas (Semua, Disetujui, Ditolak, Proses)
      bool matchChip =
          _selectedFilter == "Semua" || item["status"] == _selectedFilter;

      // 3. Filter dari Pop-Up Dialog
      bool matchDinas = true;
      bool matchKategori = true;

      if (_appliedFilters != null) {
        if (_appliedFilters!['dinas'] != null) {
          matchDinas = item["title"] == _appliedFilters!['dinas'];
        }
        if (_appliedFilters!['kategori'] != null &&
            _appliedFilters!['kategori'] != "Semua") {
          matchKategori = item["status"] == _appliedFilters!['kategori'];
        }
      }

      // Harus lolos semua syarat filter supaya datanya muncul
      return matchSearch && matchChip && matchDinas && matchKategori;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ==========================================
          // 1. BACKGROUND GRADASI HEADER
          // ==========================================
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

          // ==========================================
          // 2. KONTEN UTAMA
          // ==========================================
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // --- A. HEADER TITLE ---
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    "Riwayat Aktivitas",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // --- B. KERTAS PUTIH UTAMA BER-RADIUS ---
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
                    child: Column(
                      children: [
                        const SizedBox(height: 24),

                        // --- C. SEARCH BAR & TOMBOL FILTER ---
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FA),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (value) {
                                      setState(() {
                                        _searchQuery = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Cari riwayat persetujuan...",
                                      hintStyle: GoogleFonts.inter(
                                        color: Colors.grey.shade400,
                                        fontSize: 13,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Colors.grey.shade400,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Material(
                                color: const Color(0xFF132F53),
                                borderRadius: BorderRadius.circular(24),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () async {
                                    final result =
                                        await showDialog<Map<String, dynamic>>(
                                          context: context,
                                          builder: (context) {
                                            return const FilterNotaDinasDialog();
                                          },
                                        );

                                    if (result != null) {
                                      setState(() {
                                        _appliedFilters = result;
                                      });
                                    }
                                  },
                                  child: const SizedBox(
                                    height: 48,
                                    width: 48,
                                    child: Center(
                                      child: Icon(
                                        Icons.tune_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --- D. CHIPS FILTER STATUS ---
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              _buildFilterChip("Semua"),
                              const SizedBox(width: 8),
                              _buildFilterChip("Disetujui"),
                              const SizedBox(width: 8),
                              _buildFilterChip("Ditolak"),
                              const SizedBox(width: 8),
                              _buildFilterChip("Proses"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --- E. LIST VIEW RIWAYAT ---
                        Expanded(
                          child: filteredList.isEmpty
                              ? Center(
                                  child: Text(
                                    "Tidak ada data yang sesuai filter.",
                                    style: GoogleFonts.inter(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 8,
                                  ),
                                  itemCount: filteredList.length,
                                  itemBuilder: (context, index) {
                                    final item = filteredList[index];
                                    return _buildRiwayatCard(item, context);
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ==========================================
      // 3. BOTTOM NAVIGATION BAR
      // ==========================================
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_filled, "Beranda", false, context),
                _buildNavItem(
                  Icons.bar_chart_rounded,
                  "Analisis",
                  false,
                  context,
                ),
                _buildNavItem(
                  Icons.history_rounded,
                  "Riwayat",
                  true,
                  context,
                ), // Aktif
                _buildNavItem(
                  Icons.person_outline_rounded,
                  "Profil",
                  false,
                  context,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET HELPERS UTAMA
  // ==========================================

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF132F53) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRiwayatCard(Map<String, dynamic> data, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailRiwayatNotaDinasScreen(
              pengikutTerpilih: data["pengikutTerpilih"] ?? [],
              pengikutDibatalkan: data["pengikutDibatalkan"] ?? [],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F7FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data["type"],
                    style: GoogleFonts.inter(
                      color: const Color(0xFF132F53),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: data["statusBg"],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(data["icon"], size: 13, color: data["statusColor"]),
                      const SizedBox(width: 4),
                      Text(
                        data["status"],
                        style: GoogleFonts.inter(
                          color: data["statusColor"],
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              data["title"],
              style: GoogleFonts.inter(
                color: const Color(0xFF132F53),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              data["desc"],
              style: GoogleFonts.inter(
                color: Colors.grey.shade600,
                fontSize: 12,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  data["date"],
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        if (label == "Beranda") {
          Navigator.pop(context);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF132F53) : Colors.grey.shade400,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: isActive ? const Color(0xFF132F53) : Colors.grey.shade400,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
