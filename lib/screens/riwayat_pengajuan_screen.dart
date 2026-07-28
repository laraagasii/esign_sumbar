import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../filter_riwayat_pengajuan_dialog.dart';
import '../custom_bottom_navbar.dart'; // Import Custom Bottom Nav Bar

class RiwayatPengajuanNodinScreen extends StatefulWidget {
  const RiwayatPengajuanNodinScreen({super.key});

  @override
  State<RiwayatPengajuanNodinScreen> createState() =>
      _RiwayatPengajuanNodinScreenState();
}

class _RiwayatPengajuanNodinScreenState
    extends State<RiwayatPengajuanNodinScreen> {
  int _selectedTab = 0; // 0 untuk Nota Dinas, 1 untuk SPT

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  String? _appliedStatus = 'Semua';
  String? _tanggalAwal;
  String? _tanggalAkhir;

  final List<Map<String, dynamic>> _notaDinasData = [
    {
      "title":
          'Menghadiri Undangan Pembinaan Nagari Statistik Kabupaten Tanah Datar pada tanggal 9 s/d 11 Agustus 2026',
      "statusText": 'Proses',
      "statusBgColor": const Color(0xFFE5E7EB),
      "statusTextColor": const Color(0xFF132F53),
      "statusIcon": Icons.calendar_today_rounded,
      "categoryText": 'Dalam Daerah',
      "categoryColor": const Color(0xFF0088FF),
      "dateText": '07 Agustus 2026',
    },
    {
      "title":
          'Persiapan penilaian indeks SPBE Tahun 2024 ke Dinas Komunikasi dan Informatika Provinsi Yogyakarta pada tanggal 7 s/d 9 Agustus 2026',
      "statusText": 'Ditolak',
      "statusBgColor": const Color(0xFFFFEBEE),
      "statusTextColor": const Color(0xFFE53935),
      "statusIcon": Icons.cancel_outlined,
      "categoryText": 'Luar Daerah',
      "categoryColor": const Color(0xFFD4A72C),
      "dateText": '05 Agustus 2026',
    },
    {
      "title":
          'Memfasilitasi pembuatan Tanda Tangan Elektronik (TTE) untuk seluruh ASN Sekretariat Daerah Sumatera Barat pada tanggal 8 Juli 2026',
      "statusText": 'Disetujui',
      "statusBgColor": const Color(0xFFD3FBD4),
      "statusTextColor": const Color(0xFF125B2A),
      "statusIcon": Icons.check_circle_outline,
      "categoryText": 'Dalam Kota',
      "categoryColor": const Color(0xFF125B2A),
      "dateText": '05 Juli 2026',
    },
    {
      "title":
          'Menjadi narasumber pada kegiatan Bimbingan Teknis Pemanfaatan Aplikasi SIPOPEI untuk pengelolaan data potensi dan peluang investasi...',
      "statusText": 'Disetujui',
      "statusBgColor": const Color(0xFFD3FBD4),
      "statusTextColor": const Color(0xFF125B2A),
      "statusIcon": Icons.check_circle_outline,
      "categoryText": 'Dalam Kota',
      "categoryColor": const Color(0xFF125B2A),
      "dateText": '28 Juni 2026',
    },
  ];

  final List<Map<String, dynamic>> _sptData = [
    {
      "title":
          'SPT Perjalanan Dinas Dalam Daerah Kabupaten Tanah Datar tanggal 9 s/d 11 Agustus 2026',
      "statusText": 'Proses',
      "statusBgColor": const Color(0xFFE5E7EB),
      "statusTextColor": const Color(0xFF132F53),
      "statusIcon": Icons.calendar_today_rounded,
      "categoryText": 'Dalam Daerah',
      "categoryColor": const Color(0xFF0088FF),
      "dateText": '07 Agustus 2026',
    },
    {
      "title":
          'SPT Perjalanan Dinas Luar Daerah ke Provinsi Yogyakarta tanggal 7 s/d 9 Agustus 2026',
      "statusText": 'Ditolak',
      "statusBgColor": const Color(0xFFFFEBEE),
      "statusTextColor": const Color(0xFFE53935),
      "statusIcon": Icons.cancel_outlined,
      "categoryText": 'Luar Daerah',
      "categoryColor": const Color(0xFFD4A72C),
      "dateText": '05 Agustus 2026',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Helper untuk mengubah string tanggal teks menjadi DateTime
  DateTime? _parseItemDate(String dateStr) {
    try {
      final parts = dateStr.split(' ');
      if (parts.length >= 3) {
        int day = int.parse(parts[0]);
        int month = _monthNameToNumber(parts[1]);
        int year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (_) {}
    return null;
  }

  int _monthNameToNumber(String name) {
    switch (name.toLowerCase()) {
      case 'januari':
        return 1;
      case 'februari':
        return 2;
      case 'maret':
        return 3;
      case 'april':
        return 4;
      case 'mei':
        return 5;
      case 'juni':
        return 6;
      case 'juli':
        return 7;
      case 'agustus':
        return 8;
      case 'september':
        return 9;
      case 'oktober':
        return 10;
      case 'november':
        return 11;
      case 'desember':
        return 12;
      default:
        return 1;
    }
  }

  // Helper untuk mengubah string format dialog "DD/MM/YY" menjadi DateTime
  DateTime? _parseFilterDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse("20${parts[2]}");
        return DateTime(year, month, day);
      }
    } catch (_) {}
    return null;
  }

  void _openFilterDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return FilterRiwayatPengajuanNodinDialog(
          initialStatus: _appliedStatus,
          initialTanggalAwal: _tanggalAwal,
          initialTanggalAkhir: _tanggalAkhir,
        );
      },
    );

    if (result != null) {
      setState(() {
        _appliedStatus = result['status'];
        _tanggalAwal = result['tanggalAwal'];
        _tanggalAkhir = result['tanggalAkhir'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> activeData = _selectedTab == 0
        ? _notaDinasData
        : _sptData;

    List<Map<String, dynamic>> filteredList = activeData.where((item) {
      // 1. Filter Pencarian Teks
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final titleMatch = item["title"].toString().toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
        final categoryMatch = item["categoryText"]
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
        final statusMatch = item["statusText"]
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
        matchesSearch = titleMatch || categoryMatch || statusMatch;
      }

      // 2. Filter Status / Kategori
      bool matchesStatus = true;
      if (_appliedStatus != null && _appliedStatus != 'Semua') {
        matchesStatus = item["statusText"] == _appliedStatus;
      }

      // 3. Filter Rentang Tanggal (Tanggal Awal & Tanggal Akhir)
      bool matchesDate = true;
      DateTime? itemDate = _parseItemDate(item["dateText"]);

      if (itemDate != null) {
        DateTime normalizedItemDate = DateTime(
          itemDate.year,
          itemDate.month,
          itemDate.day,
        );

        if (_tanggalAwal != null && _tanggalAwal!.isNotEmpty) {
          DateTime? startDate = _parseFilterDate(_tanggalAwal!);
          if (startDate != null) {
            DateTime normalizedStart = DateTime(
              startDate.year,
              startDate.month,
              startDate.day,
            );
            if (normalizedItemDate.isBefore(normalizedStart)) {
              matchesDate = false;
            }
          }
        }

        if (_tanggalAkhir != null && _tanggalAkhir!.isNotEmpty) {
          DateTime? endDate = _parseFilterDate(_tanggalAkhir!);
          if (endDate != null) {
            DateTime normalizedEnd = DateTime(
              endDate.year,
              endDate.month,
              endDate.day,
            );
            if (normalizedItemDate.isAfter(normalizedEnd)) {
              matchesDate = false;
            }
          }
        }
      }

      return matchesSearch && matchesStatus && matchesDate;
    }).toList();

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
                      'Riwayat Pengajuan Nodin & SPT',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          height: 48,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    _selectedTab = 0;
                                    _searchController.clear();
                                    _searchQuery = "";
                                    _appliedStatus = 'Semua';
                                    _tanggalAwal = null;
                                    _tanggalAkhir = null;
                                  }),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: _selectedTab == 0
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: _selectedTab == 0
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
                                      'Nota Dinas',
                                      style: GoogleFonts.inter(
                                        color: _selectedTab == 0
                                            ? const Color(0xFF132F53)
                                            : Colors.grey[600],
                                        fontWeight: _selectedTab == 0
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    _selectedTab = 1;
                                    _searchController.clear();
                                    _searchQuery = "";
                                    _appliedStatus = 'Semua';
                                    _tanggalAwal = null;
                                    _tanggalAkhir = null;
                                  }),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: _selectedTab == 1
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: _selectedTab == 1
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
                                      'SPT',
                                      style: GoogleFonts.inter(
                                        color: _selectedTab == 1
                                            ? const Color(0xFF132F53)
                                            : Colors.grey[600],
                                        fontWeight: _selectedTab == 1
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FA),
                                    borderRadius: BorderRadius.circular(26),
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
                                      hintText: 'Cari pengajuan...',
                                      hintStyle: GoogleFonts.inter(
                                        color: Colors.grey.shade400,
                                        fontSize: 13,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Colors.grey.shade400,
                                        size: 20,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Material(
                                color: const Color(0xFF132F53),
                                shape: const CircleBorder(),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: _openFilterDialog,
                                  child: SizedBox(
                                    height: 52,
                                    width: 56,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.tune_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "Filter",
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: filteredList.isEmpty
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
                                  itemCount: filteredList.length,
                                  itemBuilder: (context, index) {
                                    final item = filteredList[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16.0,
                                      ),
                                      child: _buildSubmissionCard(
                                        title: item['title']!,
                                        statusText: item['statusText']!,
                                        statusBgColor: item['statusBgColor'],
                                        statusTextColor:
                                            item['statusTextColor'],
                                        statusIcon: item['statusIcon'],
                                        categoryText: item['categoryText']!,
                                        categoryColor: item['categoryColor'],
                                        dateText: item['dateText']!,
                                      ),
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

      // ==========================================
      // 3. BOTTOM NAVIGATION (MENGGUNAKAN CUSTOM WIDGET)
      // ==========================================
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 2),
    );
  }

  // ==========================================
  // WIDGET HELPER
  // ==========================================

  Widget _buildSubmissionCard({
    required String title,
    required String statusText,
    required Color statusBgColor,
    required Color statusTextColor,
    required IconData statusIcon,
    required String categoryText,
    required Color categoryColor,
    required String dateText,
  }) {
    return Container(
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
                  title,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF132F53),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 13, color: statusTextColor),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: GoogleFonts.inter(
                        color: statusTextColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  categoryText,
                  style: GoogleFonts.inter(
                    color: categoryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    dateText,
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
}
