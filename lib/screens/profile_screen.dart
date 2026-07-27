import 'package:flutter/material.dart';
import 'package:proyek_esign/custom_bottom_navbar.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bgDarkBlue = Color(0xFF12355B);

    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProv, child) {
          // Tarik data user dari provider
          final user = authProv.user;

          return Stack(
            children: [
              // Background Gradasi dari Kiri Atas ke Kanan Bawah
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF16385C), // Biru gelap pekat di kiri atas
                        Color(0xFF4A749A), // Biru sedang di tengah
                        Color(
                          0xFF8FA3B8,
                        ), // Abu-abu kebiruan lembut di kanan bawah
                      ],
                      stops: [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    // --- HEADER ---
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12.0,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Text(
                            'Profil',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(
                                Icons.code,
                                color: Colors.transparent,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // --- CARD PROFIL ATAS (Putih Melayang) ---
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24.0),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 35,
                            backgroundColor: Color(0xFFE2EBF1),
                            child: Icon(
                              Icons.person_outline_rounded,
                              size: 40,
                              color: bgDarkBlue,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Halo,',
                            style: TextStyle(
                              color: Color(0xFF767F8D),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.namaAsn ?? 'Nama tidak tersedia',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF122C4F),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.jabatan ?? '-',
                            style: const TextStyle(
                              color: Color(0xFF767F8D),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'NIP. ${user?.nip ?? '-'}',
                            style: const TextStyle(
                              color: Color(0xFF767F8D),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- KONTEN BAWAH (Container Putih Besar Mengisi Sisa Layar) ---
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Data Profil',
                                style: TextStyle(
                                  color: Color(0xFF122C4F),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Card Detail Informasi
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFFEDF1F6),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Bagian Instansi / Unit Kerja
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        user?.nmOpd ?? '-',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Color(0xFF1F2937),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      color: Color(0xFFF1F4F8),
                                      height: 1,
                                    ),

                                    // Baris Eselon
                                    _buildDetailRow(
                                      badgeText: 'Eselon :',
                                      badgeColor: const Color(0xFFDCFCE7),
                                      badgeTextColor: const Color(0xFF166534),
                                      value: user?.eselon ?? '-',
                                    ),
                                    const Divider(
                                      color: Color(0xFFF1F4F8),
                                      height: 1,
                                    ),

                                    // Baris Pangkat
                                    _buildDetailRow(
                                      badgeText: 'Pangkat :',
                                      badgeColor: const Color(0xFFF9EDCB),
                                      badgeTextColor: const Color(0xFF854D0E),
                                      value: user?.pangkat ?? '-',
                                    ),
                                    const Divider(
                                      color: Color(0xFFF1F4F8),
                                      height: 1,
                                    ),

                                    // Baris Golongan
                                    _buildDetailRow(
                                      badgeText: 'Golongan :',
                                      badgeColor: const Color(0xFFFFCDCE),
                                      badgeTextColor: const Color(0xFF991B1B),
                                      value: user?.pangkat ?? '-',
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Tombol Logout Kuning
                              SizedBox(
                                width: 140,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await authProv.logout();

                                    // Navigasi kembali ke halaman login dan hapus riwayat halaman sebelumnya
                                    if (context.mounted) {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/login',
                                        (route) => false,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE8B931),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
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
          ); // 👇 INI PENUTUP YANG HILANG (Return Stack)
        }, // 👇 INI PENUTUP YANG HILANG (Builder Consumer)
      ), // 👇 INI PENUTUP YANG HILANG (Widget Consumer)
      // --- BOTTOM NAVIGATION BAR (CUSTOM) ---
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 3),
    );
  }

  // WIDGET HELPER
  Widget _buildDetailRow({
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                color: badgeTextColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
