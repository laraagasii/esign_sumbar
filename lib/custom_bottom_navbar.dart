import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex; // 0: Beranda, 1: Analisis, 2: Riwayat, 3: Profil, -1: Kosong / Tidak Aktif

  const CustomBottomNavBar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              _buildNavItem(
                context,
                Icons.home_filled,
                "Beranda",
                0,
                '/dashboard',
              ),
              _buildNavItem(
                context,
                Icons.bar_chart_rounded,
                "Analisis",
                1,
                '/analisis',
              ),
              _buildNavItem(
                context,
                Icons.history_rounded,
                "Riwayat",
                2,
                '/riwayat',
              ),
              _buildNavItem(
                context,
                Icons.person_outline_rounded,
                "Profil",
                3,
                '/profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi helper untuk membangun tiap item menu
  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    String routeName,
  ) {
    bool isActive = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        final currentRoute = ModalRoute.of(context)?.settings.name;
        if (currentRoute != routeName) {
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
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
      ),
    );
  }
}
