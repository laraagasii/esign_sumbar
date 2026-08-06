import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detail_riwayat_spt_screen.dart';
import 'detail_spt_screen.dart';
import '../widgets/custom_bottom_navbar.dart';
import '../widgets/filter_spt_dialog.dart';
import '../widgets/status_badge_widget.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/spt_provider.dart';

class DaftarSptScreen extends StatefulWidget {
  final String? id;

  const DaftarSptScreen({super.key, this.id});

  @override
  State<DaftarSptScreen> createState() => _DaftarSptScreenState();
}

class _DaftarSptScreenState extends State<DaftarSptScreen> {
  int _selectedTabIndex = 0; // 0: Belum Diperiksa, 1: Riwayat

  Map<String, dynamic>? _appliedFilters;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<Map<String, dynamic>> _localHistoryData = [];
  final Set<String> _openedSptIds = {};

  late final String _userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProv = context.read<AuthProvider>();
      final provider = context.read<SptProvider>();
      _userId =
          widget.id ??
          authProv.user?.userId ??
          '54a8b8362ebcb16af08c8acf33a2d8d5f335cf5e';
      await provider.fetchSptList(id: _userId, status: 'NEW');
      await provider.fetchSptHistory(id: _userId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleCardTap(Map<String, dynamic> item) async {
    if (_selectedTabIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailRiwayatSptScreen(
            userId: _userId,
            sptId: item["id"]?.toString() ?? "",
            tahun: item["year"]?.toString() ?? "",
            tipe: item["detailType"]?.toString() ?? "",
          ),
        ),
      );
      return;
    }

    final id = item['id']?.toString() ?? '';
    if (id.isNotEmpty) {
      _addToHistoryAsProses(item);
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailSptScreen(userId: _userId, sptItem: item),
      ),
    );
    if (!mounted || id.isEmpty) return;
    if (result != null) {
      context.read<SptProvider>().removeItem(id);
      _updateHistoryStatus(id, item, result);
    }
  }

  void _addToHistoryAsProses(Map<String, dynamic> item) {
    final id = item['id']?.toString() ?? '';
    if (id.isEmpty || _openedSptIds.contains(id)) return;

    _openedSptIds.add(id);
    setState(() {
      _localHistoryData.insert(0, {
        "id": id,
        "title": item["title"],
        "status": item["status"],
        "desc": item["desc"],
        "date": item["date"],
        "approvalStatus": "Proses",
        "approvalColor": const Color(0xFFD4A72C),
        "approvalBg": const Color(0xFFFEF9C3),
        "approvalIcon": Icons.access_time_rounded,
        "sekretarisStatus": "Proses",
        "note": "",
      });
    });
  }

  void _updateHistoryStatus(
    String id,
    Map<String, dynamic> item,
    Map<String, dynamic> result,
  ) {
    final existingIndex = _localHistoryData.indexWhere(
      (history) => history['id']?.toString() == id,
    );
    final isApproved = result['status'] == 'Disetujui';
    final updatedHistory = {
      "id": id,
      "title": item["title"],
      "status": item["status"],
      "desc": item["desc"],
      "date": item["date"],
      "approvalStatus": result['status'],
      "approvalColor": isApproved
          ? const Color(0xFF125B2A)
          : const Color(0xFFE53935),
      "approvalBg": isApproved
          ? const Color(0xFFD3FBD4)
          : const Color(0xFFFFEBEE),
      "approvalIcon": isApproved ? Icons.check : Icons.close,
      "sekretarisStatus": result['status'],
      "note": result['note'] ?? "",
    };

    setState(() {
      if (existingIndex >= 0) {
        _localHistoryData[existingIndex] = updatedHistory;
      } else {
        _localHistoryData.insert(0, updatedHistory);
      }
      _selectedTabIndex = 1;
      _searchController.clear();
      _searchQuery = "";
      _appliedFilters = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "SPT berhasil ${result['status']}!",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isApproved
            ? const Color(0xFF125B2A)
            : const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailRiwayatSptScreen(
            userId: _userId,
            sptId: item["id"]?.toString() ?? "",
            tahun: item["year"]?.toString() ?? "",
            tipe: item["detailType"]?.toString() ?? "",
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isPejabat = true;
    final sptProv = context.watch<SptProvider>();
    List<Map<String, dynamic>> currentList = [];

    final List<Map<String, dynamic>> belumDiperiksaData = sptProv.sptList
        .map((item) => item.toDisplayMap())
        .toList();

    final historyFromProvider = sptProv.historyList
        .map((item) => item.toDisplayMap())
        .toList();

    final List<Map<String, dynamic>> historyData = [];
    final Set<String> processedIds = {};

    for (var item in _localHistoryData) {
      final id = item['id']?.toString() ?? '';
      if (id.isNotEmpty) {
        historyData.add(item);
        processedIds.add(id);
      }
    }
    for (var item in historyFromProvider) {
      final id = item['id']?.toString() ?? '';
      if (id.isNotEmpty && !processedIds.contains(id)) {
        historyData.add(item);
        processedIds.add(id);
      }
    }

    if (!isPejabat) {
      currentList = [];
    } else if (_selectedTabIndex == 0) {
      currentList = belumDiperiksaData.where((item) {
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
      currentList = historyData.where((item) {
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
          if (_appliedFilters!['dinas'] != null &&
              _appliedFilters!['dinas'] != 'Semua') {
            String itemTitleClean = item["title"]
                .toString()
                .toLowerCase()
                .replaceAll(RegExp(r'[^\w\s]+'), ' ')
                .replaceAll(RegExp(r'\s+'), ' ')
                .trim();
            String filterDinasClean = _appliedFilters!['dinas']
                .toString()
                .toLowerCase()
                .replaceAll(RegExp(r'[^\w\s]+'), ' ')
                .replaceAll(RegExp(r'\s+'), ' ')
                .trim();

            matchDinas =
                itemTitleClean.contains(filterDinasClean) ||
                filterDinasClean.contains(itemTitleClean);
            print(
              "FilterDinas: '$filterDinasClean' vs itemTitle: '$itemTitleClean' => $matchDinas",
            );
          }

          if (_appliedFilters!['wilayah'] != null &&
              _appliedFilters!['wilayah'] != "Semua") {
            matchWilayah = item["category"] == _appliedFilters!['wilayah'];
          }

          if (_appliedFilters!['kategori'] != null &&
              _appliedFilters!['kategori'] != "Semua") {
            matchKategori =
                item["approvalStatus"] == _appliedFilters!['kategori'];
          }

          DateTime? filterStartDate = _appliedFilters!['startDate'];
          DateTime? filterEndDate = _appliedFilters!['endDate'];
          if (filterStartDate != null || filterEndDate != null) {
            DateTime? itemStartDate = item['parsedStartDate'];
            if (itemStartDate != null) {
              final itemStart = DateTime(
                itemStartDate.year,
                itemStartDate.month,
                itemStartDate.day,
              );
              if (filterStartDate != null) {
                final fStart = DateTime(
                  filterStartDate.year,
                  filterStartDate.month,
                  filterStartDate.day,
                );
                if (itemStart.isBefore(fStart)) matchDate = false;
              }
              if (filterEndDate != null) {
                final fEnd = DateTime(
                  filterEndDate.year,
                  filterEndDate.month,
                  filterEndDate.day,
                );
                if (itemStart.isAfter(fEnd)) matchDate = false;
              }
            } else {
              matchDate = false;
            }
          }
        }

        return matchSearch &&
            matchDinas &&
            matchWilayah &&
            matchKategori &&
            matchDate;
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
                        _buildCustomTabBar(isPejabat, sptProv.sptList.length),
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
                          child: RefreshIndicator(
                            onRefresh: () async {
                              final authProv = context.read<AuthProvider>();
                              final userId =
                                  authProv.user?.userId ??
                                  '54a8b8362ebcb16af08c8acf33a2d8d5f335cf5e';
                              if (_selectedTabIndex == 0) {
                                await context.read<SptProvider>().fetchSptList(
                                  id: userId,
                                  status: 'NEW',
                                );
                              } else {
                                await context
                                    .read<SptProvider>()
                                    .fetchSptHistory(id: userId);
                              }
                            },
                            child: sptProv.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
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
                                              ? "Tidak ada SPT"
                                              : (sptProv.errorMessage != null
                                                    ? sptProv.errorMessage!
                                                    : "Tidak ada data ditemukan."),
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
                                        child: _buildSptCard(item),
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

  Widget _buildCustomTabBar(bool isPejabat, int pendingCount) {
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
              "Belum Diperiksa (${isPejabat ? pendingCount : 0})",
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
              if (_selectedTabIndex == 1 && data["approvalStatus"] != null)
                StatusBadgeWidget(status: data["approvalStatus"].toString()),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            data["desc"],
            style: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: 13,
              height: 1.5,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              data["category"] != null && data["category"].toString().isNotEmpty
                  ? _buildCategoryBadge(data["category"])
                  : const SizedBox.shrink(),
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

  Widget _buildCategoryBadge(String category) {
    Color bgColor;
    Color textColor;

    switch (category) {
      case "Dalam Daerah":
        bgColor = const Color(0xFFFEF9C3);
        textColor = const Color(0xFFD4A72C);
        break;
      case "Dalam Kota":
        bgColor = const Color(0xFFD3FBD4);
        textColor = const Color(0xFF125B2A);
        break;
      case "Luar Daerah":
        bgColor = const Color(0xFFFEE2B3);
        textColor = const Color(0xFF92400E);
        break;
      default:
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF4B5563);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
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
