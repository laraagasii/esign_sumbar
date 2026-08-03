import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyek_esign/screens/analisis_persetujuan_screen.dart';
import 'package:proyek_esign/screens/daftar_spt_screen.dart';
import '../providers/auth_provider.dart';
import '../providers/home_provider.dart';
import 'daftar_nota_dinas_screen.dart';
import '../custom_bottom_navbar.dart';
import '../providers/nota_dinas_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchHomeData();
      context.read<NotaDinasProvider>().fetchBelumDiperiksa(
        "a4adb04d8392abc79d52ea247fabd8348b97a78a",
        "6",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final notaProv = context.watch<NotaDinasProvider>();
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
                          color: Colors.black.withOpacity(0.12),
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

                        return SingleChildScrollView(
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
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF0F2E59,
                                            ).withOpacity(0.25),
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
                                            "${notaProv.notaDinasList.length + int.parse(data.rekap.spt.toString())}",
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
                                        ? data.rekap.spt.toString()
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              ...data.aktifitas.map((aktivitas) {
                                // Logika penentuan warna & ikon berdasarkan status
                                IconData actIcon;
                                Color actIconColor;
                                Color actIconBg;

                                if (aktivitas.statusPemeriksaan.toLowerCase() ==
                                    'disetujui') {
                                  actIcon = Icons.check_circle_rounded;
                                  actIconColor = const Color(0xFF43A047);
                                  actIconBg = const Color(0xFFE8F5E9);
                                } else if (aktivitas.statusPemeriksaan
                                        .toLowerCase() ==
                                    'ditolak') {
                                  actIcon = Icons.cancel_rounded;
                                  actIconColor = const Color(0xFFE53935);
                                  actIconBg = const Color(0xFFFFEBEE);
                                } else {
                                  // Default untuk Menunggu / Proses
                                  actIcon = Icons.access_time_filled_rounded;
                                  actIconColor = const Color(0xFFF57C00);
                                  actIconBg = const Color(0xFFFFF3E0);
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
              color: Colors.black.withOpacity(0.08),
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
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0F2E59),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
