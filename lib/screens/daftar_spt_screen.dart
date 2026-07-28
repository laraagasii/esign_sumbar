import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detail_riwayat_spt_screen.dart';
import 'detail_spt_screen.dart';
import '../custom_bottom_navbar.dart';
import 'package:proyek_esign/filter_spt_dialog.dart';

class DaftarSptScreen extends StatefulWidget {
  const DaftarSptScreen({super.key});

  @override
  State<DaftarSptScreen> createState() => _DaftarSptScreenState();
}

class _DaftarSptScreenState extends State<DaftarSptScreen> {
  int _selectedTabIndex = 0; // 0: Belum Diperiksa, 1: Riwayat

  Map<String, dynamic>? _appliedFilters;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<Map<String, dynamic>> _belumDiperiksaData = [
    {
      "title": "Dinas Komunikasi,\nInformatika, dan Statistik",
      "status": "Dalam Daerah",
      "desc":
          "Menghadiri Undangan Pembinaan Nagari Statistik Kabupaten Tanah Datar",
      "location": "Tanah Datar",
      "date": "07 s/d 09 Agustus 2026",
    },
    {
      "title": "Dinas Komunikasi,\nInformatika, dan Statistik",
      "status": "Dalam Kota",
      "desc":
          "Memfasilitasi pembuatan Tanda Tangan Elektronik (TTE) untuk seluruh ASN Sekretariat Daerah Sumatera Barat (Biro Administrasi Pembangunan, Biro Organisasi , Biro Umum dan Biro Administrasi dan Pimpinan)",
      "location": "Padang",
      "date": "05 s/d 07 Agustus 2026",
    },
    {
      "title": "Dinas Komunikasi,\nInformatika, dan Statistik",
      "status": "Luar Daerah",
      "desc":
          "Persiapan penilaian Indeks SPBE Tahun 2024 ke Dinas Komunikasi dan Informatika Provinsi Yogyakarta",
      "location": "Jogyakarta",
      "date": "05 s/d 08 Agustus 2026",
    },
    {
      "title": "Biro Umum\nSetda Provinsi Sumatera Barat",
      "status": "Dalam Daerah",
      "desc":
          "Rapat koordinasi persiapan kunjungan kerja pimpinan daerah ke Kabupaten Agam",
      "location": "Bukittinggi",
      "date": "04 s/d 06 Agustus 2026",
    },
    {
      "title": "Dinas Kesehatan\nProvinsi Sumatera Barat",
      "status": "Dalam Kota",
      "desc":
          "Evaluasi program layanan kesehatan semester pertama tahun 2026 di RS M. Djamil",
      "location": "Padang",
      "date": "03 s/d 04 Agustus 2026",
    },
    {
      "title": "Dinas Pendidikan\nProvinsi Sumatera Barat",
      "status": "Luar Daerah",
      "desc":
          "Studi banding pengelolaan sekolah unggulan ke Bandung, Jawa Barat",
      "location": "Bandung",
      "date": "01 s/d 04 Agustus 2026",
    },
    {
      "title": "Dinas Pekerjaan Umum\ndan Penataan Ruang",
      "status": "Dalam Daerah",
      "desc":
          "Peninjauan proyek pembangunan infrastruktur jalan lintas kabupaten",
      "location": "Solok",
      "date": "31 Juli s/d 02 Agustus 2026",
    },
    {
      "title": "Badan Pendapatan Daerah\nProvinsi Sumatera Barat",
      "status": "Dalam Kota",
      "desc": "Rekonsiliasi data pajak kendaraan bermotor triwulan kedua",
      "location": "Padang",
      "date": "30 s/d 31 Juli 2026",
    },
  ];

  final List<Map<String, dynamic>> _riwayatData = [
    {
      "title": "Dinas Komunikasi,\nInformatika, dan Statistik",
      "status": "Luar Daerah",
      "desc":
          "Persiapan penilaian indeks SPBE Tahun 2024 ke Dinas Komunikasi dan Informatika Provinsi Jogyakarta pada tanggal 7 s/d 9 Agustus 2024",
      "date": "05 s/d 08 Agustus 2026",
      "approvalStatus": "Proses",
      "approvalColor": const Color(0xFF132F53),
      "approvalBg": const Color(0xFFE5E7EB),
      "approvalIcon": Icons.calendar_today_rounded,
      "pengikutTerpilih": [],
      "pengikutDibatalkan": [],
    },
    {
      "title": "Dinas Komunikasi,\nInformatika, dan Statistik",
      "status": "Dalam Kota",
      "desc":
          "Memfasilitasi pembuatan Tanda Tangan Elektronik (TTE) untuk seluruh ASN Sekretariat Daerah Sumatera Barat (Biro Administrasi Pembangunan, Biro Organisasi, Biro Umum dan Biro Administrasi dan Pimpinan)",
      "date": "05 s/d 07 Agustus 2026",
      "approvalStatus": "Ditolak",
      "approvalColor": const Color(0xFFE53935),
      "approvalBg": const Color(0xFFFFEBEE),
      "approvalIcon": Icons.cancel_outlined,
      "pengikutTerpilih": [],
      "pengikutDibatalkan": [],
    },
    {
      "title": "Dinas Komunikasi,\nInformatika, dan Statistik",
      "status": "Dalam Kota",
      "desc":
          "Memfasilitasi pembuatan Tanda Tangan Elektronik (TTE) untuk seluruh ASN Sekretariat Daerah Sumatera Barat (Biro Administrasi Pembangunan, Biro Organisasi, Biro Umum dan Biro Administrasi dan Pimpinan)",
      "date": "05 s/d 07 Agustus 2026",
      "approvalStatus": "Disetujui",
      "approvalColor": const Color(0xFF125B2A),
      "approvalBg": const Color(0xFFD3FBD4),
      "approvalIcon": Icons.check_circle_outline,
      "pengikutTerpilih": [],
      "pengikutDibatalkan": [],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleCardTap(Map<String, dynamic> item) {
    if (_selectedTabIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DetailRiwayatSptScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DetailSptScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> currentList = [];

    if (_selectedTabIndex == 0) {
      currentList = _belumDiperiksaData.where((item) {
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
        return matchSearch;
      }).toList();
    } else {
      currentList = _riwayatData.where((item) {
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

        bool matchDinas = true;
        bool matchWilayah = true;
        bool matchKategori = true;

        if (_appliedFilters != null) {
          if (_appliedFilters!['dinas'] != null) {
            String itemTitleClean = item["title"].toString().replaceAll(
              '\n',
              ' ',
            );
            matchDinas = itemTitleClean == _appliedFilters!['dinas'];
          }

          if (_appliedFilters!['wilayah'] != null &&
              _appliedFilters!['wilayah'] != "Semua") {
            matchWilayah = item["status"] == _appliedFilters!['wilayah'];
          }

          if (_appliedFilters!['kategori'] != null &&
              _appliedFilters!['kategori'] != "Semua") {
            matchKategori =
                item["approvalStatus"] == _appliedFilters!['kategori'];
          }
        }

        return matchSearch && matchDinas && matchWilayah && matchKategori;
      }).toList();
    }

    String headerTitle = _selectedTabIndex == 0
        ? "Daftar SPT"
        : "Riwayat Persetujuan SPT";

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
                          headerTitle,
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
                        _buildCustomTabBar(),
                        const SizedBox(height: 16),
                        if (_selectedTabIndex == 1) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
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
                                        hintText: "Cari riwayat dokumen...",
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
                                          await showDialog<
                                            Map<String, dynamic>
                                          >(
                                            context: context,
                                            builder: (context) {
                                              return FilterSPTDialog(
                                                currentFilters: _appliedFilters,
                                              );
                                            },
                                          );

                                      if (!mounted) return;

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
                          const SizedBox(height: 12),
                        ],
                        Expanded(
                          child: currentList.isEmpty
                              ? Center(
                                  child: Text(
                                    "Tidak ada data ditemukan.",
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
                                  itemCount: currentList.length,
                                  itemBuilder: (context, index) {
                                    final item = currentList[index];
                                    return GestureDetector(
                                      onTap: () => _handleCardTap(item),
                                      child: _buildSptCard(item),
                                    );
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

      // ✅ MEMANGGIL CUSTOM BOTTOM NAVBAR DI SINI
      // Sesuaikan currentIndex berdasarkan representasi halaman ini (misal 2 untuk Riwayat)
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 0),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              "Belum Diperiksa (${_belumDiperiksaData.length})",
              0,
            ),
          ),
          Expanded(child: _buildTabButton("Riwayat", 1)),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
          _searchController.clear();
          _searchQuery = "";
          _appliedFilters = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          title,
          style: GoogleFonts.inter(
            color: isSelected ? const Color(0xFF132F53) : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSptCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  data["title"],
                  style: GoogleFonts.inter(
                    color: const Color(0xFF132F53),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              if (_selectedTabIndex == 1 && data.containsKey("approvalStatus"))
                _buildApprovalBadge(
                  data["approvalStatus"],
                  data["approvalBg"],
                  data["approvalColor"],
                  data["approvalIcon"],
                )
              else
                _buildStatusBadge(data["status"]),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            data["desc"],
            style: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: 13,
              height: 1.4,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_selectedTabIndex == 1)
                _buildStatusBadge(data["status"])
              else
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Color(0xFF0088FF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      data["location"],
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0088FF),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Color(0xFFD4A72C),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    data["date"],
                    style: GoogleFonts.inter(
                      color: const Color(0xFFD4A72C),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case "Dalam Daerah":
        bgColor = const Color(0xFFDDEEFC);
        textColor = const Color(0xFF0088FF);
        break;
      case "Dalam Kota":
        bgColor = const Color(0xFFD3FBD4);
        textColor = const Color(0xFF125B2A);
        break;
      case "Luar Daerah":
      default:
        bgColor = const Color(0xFFFEF9C3);
        textColor = const Color(0xFFD4A72C);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildApprovalBadge(
    String text,
    Color bgColor,
    Color textColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.inter(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
