import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'daftar_nota_dinas_screen.dart'; // Import file screen Daftar Nota Dinas

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        child: Column(
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
                              "Oni Fajar Syahdi, S.St.Pi, MMA.",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Sekretaris",
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
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
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        top: 32,
                        left: 24,
                        right: 24,
                        bottom: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      "12",
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

                              // GAMBAR CLIPBOARD (SEJAJAR BAWAH)
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

                          // --- RINGKASAN HARI INI ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Ringkasan Hari Ini",
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF0F2E59),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Lihat Ringkasan Bulanan →",
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF0088FF),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // --- KARTU RINGKASAN (NOTA DINAS & SPT) DENGAN EFEK RIPPLE ---
                          Row(
                            children: [
                              // KARTU NOTA DINAS
                              _buildSummaryCard(
                                title: "Nota Dinas",
                                count: "8",
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
                                          ) => const DaftarNotaDinasScreen(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 16),
                              // KARTU SPT
                              _buildSummaryCard(
                                title: "SPT",
                                count: "4",
                                bgColor: const Color(0xFFF2F7FA),
                                onTap: () {
                                  // Bisa diarahkan ke halaman daftar SPT atau aksi serupa
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => const DaftarNotaDinasScreen(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
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

                          _buildActivityItem(
                            icon: Icons.check_circle_rounded,
                            iconColor: const Color(0xFF43A047),
                            iconBg: const Color(0xFFE8F5E9),
                            title: "SPT Biro Umum",
                            subtitle: "Disetujui oleh Anda",
                            time: "Hari ini\n14.30",
                          ),
                          _buildActivityItem(
                            icon: Icons.access_time_filled_rounded,
                            iconColor: const Color(0xFFF57C00),
                            iconBg: const Color(0xFFFFF3E0),
                            title: "Nota Dinas Kominfo",
                            subtitle: "Menunggu persetujuan Anda",
                            time: "Kemarin\n10.30",
                          ),
                          _buildActivityItem(
                            icon: Icons.cancel_rounded,
                            iconColor: const Color(0xFFE53935),
                            iconBg: const Color(0xFFFFEBEE),
                            title: "Nota Dinas Biro Umum",
                            subtitle: "Dikembalikan",
                            time: "Kemarin\n09.15",
                          ),
                          const SizedBox(height: 20),
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

      // ==========================================
      // 3. BOTTOM NAVIGATION
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
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 1.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_filled, "Beranda", true),
                _buildNavItem(Icons.bar_chart_rounded, "Analisis", false),
                _buildNavItem(Icons.history_rounded, "Riwayat", false),
                _buildNavItem(Icons.person_outline_rounded, "Profil", false),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF132F53) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.grey.shade400,
            size: 22,
          ),
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
    );
  }
}
