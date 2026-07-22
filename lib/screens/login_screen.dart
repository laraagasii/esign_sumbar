import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void _prosesLogin() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    });
  }

  // Widget custom untuk Input Field agar persis desain Figma
  Widget _buildCustomTextField({
    required String label,
    required String hint,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F2E59),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: TextField(
            obscureText: isPassword,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF0F2E59),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                color: Colors.grey.shade400, // Dibuat sedikit lebih soft
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil lebar layar HP dinamis
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // Latar belakang putih/abu-abu terang untuk bagian bawah layar
      backgroundColor: const Color(0xFFF5F7FA),

      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // 1. LATAR BELAKANG BIRU MELENGKUNG (DENGAN EFEK CAHAYA/GLOW)
            Container(
              height: 420,
              decoration: BoxDecoration(
                // Pakai RadialGradient biar ada efek cahaya dari tengah
                gradient: const RadialGradient(
                  center: Alignment(
                    0.0,
                    -0.1,
                  ), // Titik pusat cahaya pas di area belakang HP
                  radius: 0.75, // Seberapa lebar cahayanya menyebar
                  colors: [
                    Color(0xFF77899D), // 0% - Paling dalam (belakang HP)
                    Color(0xFF225894), // 48% - Transisi tengah
                    Color(0xFF1D3E62), // 100% - Paling luar / gelap
                  ],
                  stops: [
                    0.2, // Setara dengan 0% di Figma
                    0.48, // Setara dengan 48% di Figma
                    1.0, // Setara dengan 100% di Figma
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(screenWidth, 120),
                ),
              ),
            ),

            // 2. ILUSTRASI CEWEK & HP
            Padding(
              padding: const EdgeInsets.only(
                top: 100.0,
              ), // Jarak dari atas layar
              child: Image.asset(
                'assets/images/login.png',
                height: 230, // Disesuaikan agar proposional dengan lengkungan
                fit: BoxFit.contain,
              ),
            ),

            // 3. KARTU PUTIH LOGIN
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                top:
                    280, // <-- Ini juga aku turunin dikit (dari 270) biar proporsi numpaknya pas sama gambar
                left: 24,
                right: 24,
                bottom: 40,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    // Opacity (kepekatan) dinaikkan dari 0.12 jadi 0.25
                    color: const Color(0xFF668EB9).withOpacity(1.0),
                    blurRadius: 50, // <-- Makin besar makin ngeblur/halus
                    spreadRadius:
                        5, // <-- Bikin bayangannya makin melebar keluar
                    offset: const Offset(
                      0,
                      15,
                    ), // <-- Bikin bayangannya makin jatuh ke bawah
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // KUNCI UTAMA: Biar tinggi kolom pas-pasan aja
                children: [
                  // Typografi Judul
                  Text(
                    "Masuk Akun",
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F2E59),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "E-SIGN Provinsi Sumatera Barat",
                    style: GoogleFonts.inter(
                      fontSize: 13, // Sedikit dikecilkan menyesuaikan figma
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF334A66),
                    ),
                  ),

                  const SizedBox(height: 32), // Jarak judul ke form
                  // Field NIP
                  _buildCustomTextField(
                    label: "NIP / Username",
                    hint: "Masukkan NIP Anda",
                  ),
                  const SizedBox(
                    height: 20,
                  ), // Jarak antar input field dirapatkan sedikit
                  // Field Password
                  _buildCustomTextField(
                    label: "Password",
                    hint: "........",
                    isPassword: true,
                  ),

                  const SizedBox(height: 36), // Jarak ke tombol Masuk
                  // Tombol Masuk Centered
                  SizedBox(
                    width: 220, // Lebar tombol disesuaikan desain
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF132F53), // Navy Button
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isLoading ? null : _prosesLogin,
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : Text(
                              "Masuk",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
