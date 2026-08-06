import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyek_esign/providers/auth_provider.dart';
import 'package:proyek_esign/widgets/filter_nota_dinas_dialog.dart';
import 'package:proyek_esign/widgets/status_badge_widget.dart';
import 'package:proyek_esign/screens/detail_nota_dinas_screen.dart';
import 'package:proyek_esign/widgets/custom_bottom_navbar.dart';
import 'package:proyek_esign/providers/nota_dinas_provider.dart';

class DaftarNotaDinasScreen extends StatefulWidget {
  const DaftarNotaDinasScreen({super.key});

  @override
  State<DaftarNotaDinasScreen> createState() => _DaftarNotaDinasScreenState();
}

class _DaftarNotaDinasScreenState extends State<DaftarNotaDinasScreen> {
  int _selectedTabIndex = 0; // 0: Belum Diperiksa, 1: Riwayat

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  Map<String, dynamic>? _appliedFilters;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = Provider.of<NotaDinasProvider>(context, listen: false);
      final authProv = Provider.of<AuthProvider>(context, listen: false);

      final userId =
          authProv.user?.userId ?? 'a4adb04d8392abc79d52ea247fabd8348b97a78a';
      final groupId = authProv.user?.group.toString() ?? '6';

      prov.fetchBelumDiperiksa(userId, groupId);
      prov.fetchSudahDiperiksa(userId, groupId);
    });
  }

  final List<Map<String, dynamic>> _riwayatData = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleCardTap(Map<String, dynamic> item) async {
    final notaProvider = Provider.of<NotaDinasProvider>(context, listen: false);
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final userId =
        authProv.user?.userId ?? 'a4adb04d8392abc79d52ea247fabd8348b97a78a';
    final groupId = authProv.user?.group.toString() ?? '6';

    if (_selectedTabIndex == 1) {
      final notaModel = notaProvider.riwayatNotaDinasList.firstWhere(
        (element) => element.idnota == item['idnota'],
        orElse: () => notaProvider.notaDinasList.firstWhere(
          (element) => element.idnota == item['idnota'],
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailNotaDinasScreen(
            notaDinas: notaModel,
            userId: userId,
            groupId: groupId,
            isRiwayat: true,
          ),
        ),
      );
    } else {
      final notaModel = notaProvider.notaDinasList.firstWhere(
        (element) => element.idnota == item['idnota'],
        orElse: () => notaProvider.notaDinasList.first,
      );

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailNotaDinasScreen(
            notaDinas: notaModel,
            userId: userId,
            groupId: groupId,
          ),
        ),
      );

      if (!mounted) return;

      if (result != null) {
        setState(() {
          Provider.of<NotaDinasProvider>(
            context,
            listen: false,
          ).removeItem(item['idnota'] ?? '');
          _riwayatData.insert(0, {
            "idnota": item["idnota"] ?? "",
            "title": item["title"],
            "status": item["status"],
            "desc": item["desc"],
            "date": item["date"],
            "approvalStatus": result['status'],
            "approvalColor": result['status'] == 'Disetujui'
                ? const Color(0xFF125B2A)
                : const Color(0xFFE53935),
            "approvalBg": result['status'] == 'Disetujui'
                ? const Color(0xFFD3FBD4)
                : const Color(0xFFFFEBEE),
            "approvalIcon": result['status'] == 'Disetujui'
                ? Icons.check
                : Icons.close,
            "sekretarisStatus": result['status'], // <--- Pastikan ini ada
            "note": result['note'] ?? "", // <--- Pastikan ini ada
            "pengikutTerpilih": result['pengikutTerpilih'] ?? [],
            "pengikutDibatalkan": result['pengikutDibatalkan'] ?? [],
          });

          _selectedTabIndex = 1;
          _searchController.clear();
          _searchQuery = "";
          _appliedFilters = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Nota Dinas berhasil ${result['status']}!",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            backgroundColor: result['status'] == 'Disetujui'
                ? const Color(0xFF125B2A)
                : const Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        bool alreadyInRiwayat = _riwayatData.any(
          (r) => r["title"] == item["title"] && r["desc"] == item["desc"],
        );

        if (!alreadyInRiwayat) {
          setState(() {
            _riwayatData.insert(0, {
              "idnota": item["idnota"] ?? "",
              "title": item["title"],
              "status": item["status"],
              "desc": item["desc"],
              "date": item["date"],
              "approvalStatus": "Proses",
              "approvalColor": const Color(0xFFD4A72C),
              "approvalBg": const Color(0xFFFEF9C3),
              "approvalIcon": Icons.access_time_rounded,
              "pengikutTerpilih": [],
              "pengikutDibatalkan": [],
            });
          });
        }
      }
    }
  }

  DateTime? _parseIndonesianDate(String dateStr) {
    if (dateStr.isEmpty) return null;

    // Remove day of week (e.g., "Rabu, ") if exists
    if (dateStr.contains(',')) {
      dateStr = dateStr.split(',')[1].trim();
    }

    // Try ISO format
    DateTime? parsed = DateTime.tryParse(dateStr);
    if (parsed != null) return parsed;

    // Convert Indonesian month names to numbers
    final monthMap = {
      'januari': 1,
      'jan': 1,
      'februari': 2,
      'feb': 2,
      'maret': 3,
      'mar': 3,
      'april': 4,
      'apr': 4,
      'mei': 5,
      'juni': 6,
      'jun': 6,
      'juli': 7,
      'jul': 7,
      'agustus': 8,
      'agu': 8,
      'agt': 8,
      'september': 9,
      'sep': 9,
      'oktober': 10,
      'okt': 10,
      'november': 11,
      'nov': 11,
      'desember': 12,
      'des': 12,
    };

    final parts = dateStr.split(RegExp(r'[\s\-/]+'));
    if (parts.length >= 3) {
      int? d = int.tryParse(parts[0]);
      int? y = int.tryParse(parts[2]);
      int? m = int.tryParse(parts[1]);

      if (m == null) {
        String monthStr = parts[1].toLowerCase();
        m = monthMap[monthStr];
      }

      if (d != null && m != null && y != null && y > 1000) {
        return DateTime(y, m, d);
      } else if (d != null && m != null && y != null && d > 1000) {
        // format yyyy-MM-dd
        return DateTime(d, m, y);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final notaProvider = Provider.of<NotaDinasProvider>(context);
    final bool isPejabat =
        Provider.of<AuthProvider>(context, listen: false).user?.isPejabat ??
        false;
    List<Map<String, dynamic>> currentList = [];

    if (!isPejabat) {
      currentList = [];
    } else if (_selectedTabIndex == 0) {
      currentList = notaProvider.notaDinasList
          .map(
            (model) => {
              "idnota": model.idnota,
              "title": model.nmopd,
              "status": model.nmkategori,
              "desc": model.perihal,
              "location": model.nmkategori,
              "date": model.tglnota,
              "approvalStatus": "Proses",
            },
          )
          .toList();
    } else {
      final List<Map<String, dynamic>> historyFromProvider = notaProvider
          .riwayatNotaDinasList
          .map(
            (model) => {
              "idnota": model.idnota,
              "title": model.nmopd,
              "status": model.nmkategori,
              "desc": model.perihal,
              "location": model.nmkategori,
              "date": model.tglnota,
              // Keep default UI logic for approval if backend doesn't provide it yet
              "approvalStatus": "Disetujui",
              "approvalColor": const Color(0xFF125B2A),
              "approvalBg": const Color(0xFFD3FBD4),
              "approvalIcon": Icons.check,
              "sekretarisStatus": "Disetujui",
            },
          )
          .toList();

      final List<Map<String, dynamic>> historyData = [];
      final Set<String> processedIds = {};

      for (var item in _riwayatData) {
        final id = item['idnota']?.toString() ?? '';
        if (id.isNotEmpty) {
          historyData.add(item);
          processedIds.add(id);
        }
      }

      for (var item in historyFromProvider) {
        final id = item['idnota']?.toString() ?? '';
        if (id.isNotEmpty && !processedIds.contains(id)) {
          historyData.add(item);
          processedIds.add(id);
        }
      }

      currentList = historyData;
    }

    // Terapkan filter dan pencarian untuk kedua tab
    currentList = currentList.where((item) {
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
      bool matchDate = true;

      if (_appliedFilters != null) {
        if (_appliedFilters!['dinas'] != null) {
          String itemTitleClean = item["title"]
              .toString()
              .replaceAll('\n', ' ')
              .toLowerCase();
          String filterDinas = _appliedFilters!['dinas']
              .toString()
              .toLowerCase();
          matchDinas = itemTitleClean.contains(filterDinas);
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

        DateTime? startDate = _appliedFilters!['startDate'];
        DateTime? endDate = _appliedFilters!['endDate'];
        if (startDate != null || endDate != null) {
          String dateStr = item["date"] ?? "";
          DateTime? itemDate = _parseIndonesianDate(dateStr);

          if (itemDate != null) {
            itemDate = DateTime(itemDate.year, itemDate.month, itemDate.day);
            if (startDate != null) {
              DateTime start = DateTime(
                startDate.year,
                startDate.month,
                startDate.day,
              );
              if (itemDate.isBefore(start)) matchDate = false;
            }
            if (endDate != null) {
              DateTime end = DateTime(endDate.year, endDate.month, endDate.day);
              if (itemDate.isAfter(end)) matchDate = false;
            }
          } else {
            // If date parsing fails, we could choose to hide or show.
            // We'll leave it as not matched if we can't parse it.
            if (dateStr.isNotEmpty) {
              matchDate = false;
            }
          }
        }
      }

      return matchSearch &&
          matchDinas &&
          matchWilayah &&
          matchKategori &&
          matchDate;
    }).toList();

    String headerTitle = _selectedTabIndex == 0
        ? "Daftar Nota Dinas"
        : "Riwayat Persetujuan Nota Dinas";

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
                        _buildCustomTabBar(isPejabat),
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
                                              return FilterNotaDinasDialog(
                                                initialFilters: _appliedFilters,
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
                          child: RefreshIndicator(
                            onRefresh: () async {
                              final authProv = Provider.of<AuthProvider>(
                                context,
                                listen: false,
                              );
                              final userId =
                                  authProv.user?.userId ??
                                  '54a8b8362ebcb16af08c8acf33a2d8d5f335cf5e';
                              final groupId =
                                  authProv.user?.group.toString() ?? '6';
                              if (_selectedTabIndex == 0) {
                                await Provider.of<NotaDinasProvider>(
                                  context,
                                  listen: false,
                                ).fetchBelumDiperiksa(userId, groupId);
                              } else {
                                await Provider.of<NotaDinasProvider>(
                                  context,
                                  listen: false,
                                ).fetchSudahDiperiksa(userId, groupId);
                              }
                            },
                            child: notaProvider.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : notaProvider.errorMessage != null
                                ? Center(
                                    child: Text(
                                      notaProvider.errorMessage!,
                                      style: GoogleFonts.inter(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  )
                                : currentList.isEmpty
                                ? ListView(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.3,
                                      ),
                                      Center(
                                        child: Text(
                                          !isPejabat
                                              ? "Tidak ada Nota Dinas"
                                              : "Tidak ada data ditemukan.",
                                          style: GoogleFonts.inter(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
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
                                        child: _buildNotaCard(item),
                                      );
                                    },
                                  ),
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
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: -1),
    );
  }

  Widget _buildCustomTabBar(bool isPejabat) {
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
              "Belum Diperiksa (${isPejabat ? Provider.of<NotaDinasProvider>(context).notaDinasList.length : 0})",
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

  Widget _buildNotaCard(Map<String, dynamic> data) {
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
                StatusBadgeWidget(status: data["approvalStatus"]),
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
              _buildStatusBadge(data["status"]),
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
}
