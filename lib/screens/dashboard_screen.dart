import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyek_esign/screens/analisis_persetujuan_screen.dart';
import 'package:proyek_esign/screens/daftar_spt_screen.dart';
import '../utils/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../providers/spt_provider.dart';
import 'daftar_nota_dinas_screen.dart';
import '../widgets/custom_bottom_navbar.dart';
import '../providers/nota_dinas_provider.dart';
import '../models/home_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Aktifitas> _recentActivities = [];
  bool _isLoadingActivities = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }

  Future<void> _loadDashboardData() async {
    final authProv = context.read<AuthProvider>();
    final userId = authProv.user?.userId ?? '';
    final groupId = authProv.user?.group.toString() ?? '';

    context.read<HomeProvider>().fetchHomeData();
    context.read<NotaDinasProvider>().fetchBelumDiperiksa(userId, groupId);
    context.read<SptProvider>().fetchSptList(id: userId, status: 'NEW');

    await Future.wait([
      context.read<NotaDinasProvider>().fetchSudahDiperiksa(userId, groupId),
      context.read<SptProvider>().fetchSptHistory(id: userId),
    ]);

    await _compileRecentActivities();
  }

  Future<void> _compileRecentActivities() async {
    List<Aktifitas> combined = [];

    // 1. Nodin Riwayat Pemeriksaan
    final notaProv = context.read<NotaDinasProvider>();
    for (var item in notaProv.riwayatNotaDinasList) {
      combined.add(
        Aktifitas(
          id: item.idnota,
          perihal: item.perihal,
          statusPemeriksaan: item.nmstatus,
          tanggal: item.tglnota,
        ),
      );
    }

    // 2. SPT Riwayat Pemeriksaan
    final sptProv = context.read<SptProvider>();
    for (var item in sptProv.historyList) {
      combined.add(
        Aktifitas(
          id: item.id,
          perihal: item.perihal,
          statusPemeriksaan: item.statusLabel,
          tanggal: item.rawStartDate.isNotEmpty
              ? item.rawStartDate
              : item.tanggal,
        ),
      );
    }

    // 3. Riwayat Pengajuan
    try {
      final String response = await rootBundle.loadString(
        'assets/riwayat_pengajuan.json',
      );
      final data = await json.decode(response);
      if (data['status'] == true) {
        final ndList = data['data']['nota_dinas'] as List;
        for (var item in ndList) {
          combined.add(
            Aktifitas(
              id: item['id_st'] ?? '',
              perihal: item['maksud'] ?? '',
              statusPemeriksaan: item['status'] ?? '',
              tanggal: item['tgl_st'] ?? '',
            ),
          );
        }

        final sptList = data['data']['spt'] as List;
        for (var item in sptList) {
          combined.add(
            Aktifitas(
              id: item['id_spt'] ?? '',
              perihal: item['maksud'] ?? '',
              statusPemeriksaan: item['status'] ?? '',
              tanggal: item['tgl_spt'] ?? '',
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Error loading riwayat pengajuan: $e");
    }

    // Sort by date (descending)
    combined.sort((a, b) {
      DateTime dateA = _parseDateForSort(a.tanggal);
      DateTime dateB = _parseDateForSort(b.tanggal);
      return dateB.compareTo(dateA);
    });

    // Take top 5
    if (combined.length > 5) {
      combined = combined.sublist(0, 5);
    }

    if (mounted) {
      setState(() {
        _recentActivities = combined;
        _isLoadingActivities = false;
      });
    }
  }

  DateTime _parseDateForSort(String dateStr) {
    if (dateStr.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      final slashParts = dateStr.split(RegExp(r'[\/\-\s]+'));
      if (slashParts.length >= 3) {
        final first = int.tryParse(slashParts[0]);
        final second = int.tryParse(slashParts[1]);
        final third = int.tryParse(slashParts[2]);
        if (first != null && second != null && third != null) {
          if (first > 31) {
            return DateTime(first, second, third);
          }
          return DateTime(third, second, first);
        }
      }
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notaProv = context.watch<NotaDinasProvider>();
    final sptProv = context.watch<SptProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ==========================================
          // 1. BACKGROUND BIRU KHUSUS HEADER
          // ==========================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF132F53), // Biru gelap di kiri atas
                    Color(0xFF5A84AB), // Biru terang di kanan bawah
                  ],
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
                // --- A. AREA HEADER PROFIL ---
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 36,
                          color: Color(0xFF132F53),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Consumer<AuthProvider>(
                          builder: (context, authProv, child) {
                            // 👇 INI DIA OBATNYA LARA! Variabel user dideklarasikan di sini 👇
                            final user = authProv.user;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Halo,",
                                  style: GoogleFonts.inter(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  user?.namaAsn ?? "Pengguna",
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  user?.jabatan ?? "-",
                                  style: GoogleFonts.inter(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // --- B. KERTAS PUTIH BERBAYANG ---
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
                          spreadRadius: 0,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    child: Consumer<HomeProvider>(
                      builder: (context, homeProv, child) {
                        // Tampilkan loading kalau lagi proses baca JSON
                        if (homeProv.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        // Tampilkan pesan error kalau gagal
                        if (homeProv.errorMessage.isNotEmpty) {
                          return Center(child: Text(homeProv.errorMessage));
                        }

                        final data = homeProv.homeData;
                        // Kalau datanya kosong
                        if (data == null) {
                          return const Center(
                            child: Text('Tidak ada data dashboard'),
                          );
                        }

                        // Ambil state isPejabat
                        final bool isPejabat =
                            Provider.of<AuthProvider>(
                              context,
                              listen: false,
                            ).user?.isPejabat ??
                            false;

                        return RefreshIndicator(
                          onRefresh: () async {
                            await _loadDashboardData();
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(
                              top: 32,
                              left: 24,
                              right: 24,
                              bottom: 24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Cek apakah user adalah pejabat (bisa menyetujui)
                                // Jika bukan, sembunyikan widget "Menunggu Persetujuan"
                                if (isPejabat) ...[
                                  // --- KARTU "MENUNGGU PERSETUJUAN" ---
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFF0F2E59),
                                              Color(0xFFC7D7E8),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF0F2E59,
                                              ).withValues(alpha: 0.25),
                                              blurRadius: 20,
                                              spreadRadius: 2,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Menunggu Persetujuan",
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "${notaProv.notaDinasList.length + sptProv.sptList.length}",
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFFFDB913),
                                                fontSize: 48,
                                                fontWeight: FontWeight.bold,
                                                height: 1.1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // GAMBAR CLIPBOARD
                                      Positioned(
                                        right: -4,
                                        bottom: 0,
                                        child: Image.asset(
                                          'assets/images/home.png',
                                          height: 115,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 36),
                                ],

                                // --- RINGKASAN HARI INI ---
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Ringkasan Hari Ini",
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF0F2E59),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder:
                                                (
                                                  context,
                                                  animation,
                                                  secondaryAnimation,
                                                ) =>
                                                    const AnalisisPersetujuanScreen(),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration:
                                                Duration.zero,
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Lihat Ringkasan Bulanan →",
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFF0088FF),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // --- KARTU RINGKASAN (NOTA DINAS & SPT) ---
                                Row(
                                  children: [
                                    // KARTU NOTA DINAS
                                    _buildSummaryCard(
                                      title: "Nota Dinas",
                                      count: isPejabat
                                          ? notaProv.notaDinasList.length
                                                .toString()
                                          : '0',
                                      bgColor: const Color(0xFFFFF9EE),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder:
                                                (
                                                  context,
                                                  animation,
                                                  secondaryAnimation,
                                                ) =>
                                                    const DaftarNotaDinasScreen(),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration:
                                                Duration.zero,
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 16),
                                    // KARTU SPT
                                    _buildSummaryCard(
                                      title: "SPT",
                                      count: isPejabat
                                          ? sptProv.sptList.length.toString()
                                          : '0',
                                      bgColor: const Color(0xFFF2F7FA),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder:
                                                (
                                                  context,
                                                  animation,
                                                  secondaryAnimation,
                                                ) => const DaftarSptScreen(),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration:
                                                Duration.zero,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 36),

                                // --- AKTIVITAS TERAKHIR ---
                                Text(
                                  "Aktivitas Terakhir",
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF0F2E59),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                if (_isLoadingActivities)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                else if (_recentActivities.isEmpty)
                                  const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        'Belum ada aktivitas',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  )
                                else
                                  ..._recentActivities.map((aktivitas) {
                                    // Logika penentuan warna & ikon berdasarkan status
                                    IconData actIcon;
                                    Color actIconColor;
                                    Color actIconBg;

                                    final statusLower = aktivitas
                                        .statusPemeriksaan
                                        .toLowerCase();
                                    if (statusLower.contains('disetujui') ||
                                        statusLower.contains('diperiksa') ||
                                        statusLower.contains('setuju')) {
                                      actIcon = Icons.check;
                                      actIconColor =
                                          AppColors.statusApprovedText;
                                      actIconBg = AppColors.statusApprovedBg;
                                    } else if (statusLower.contains(
                                          'ditolak',
                                        ) ||
                                        statusLower.contains('tolak')) {
                                      actIcon = Icons.close;
                                      actIconColor =
                                          AppColors.statusRejectedText;
                                      actIconBg = AppColors.statusRejectedBg;
                                    } else if (statusLower.contains('belum') ||
                                        statusLower.contains('proses') ||
                                        statusLower.contains('diproses')) {
                                      actIcon = Icons.access_time_rounded;
                                      actIconColor =
                                          AppColors.statusPendingText;
                                      actIconBg = AppColors.statusPendingBg;
                                    } else {
                                      actIcon = Icons.remove_done;
                                      actIconColor =
                                          AppColors.statusDefaultText;
                                      actIconBg = AppColors.statusDefaultBg;
                                    }

                                    return _buildActivityItem(
                                      icon: actIcon,
                                      iconColor: actIconColor,
                                      iconBg: actIconBg,
                                      title: aktivitas.perihal,
                                      subtitle: aktivitas.statusPemeriksaan,
                                      time: aktivitas.tanggal,
                                    );
                                  }),

                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 0),
    );
  }

  // ==========================================
  // WIDGET HELPER
  // ==========================================

  Widget _buildSummaryCard({
    required String title,
    required String count,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    count,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF0F2E59),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0F2E59),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 9),
          ),
        ],
      ),
    );
  }
}
