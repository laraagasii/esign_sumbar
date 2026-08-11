import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// Pastikan path import ini sesuai dengan struktur folder kamu
import 'package:proyek_esign/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = "";
  String password = "";

  // _isLoading dihapus dari sini karena sekarang diurus oleh AuthProvider

  void _handleLogin() async {
    // Validasi input kosong
    if (username.isEmpty || password.isEmpty) {
      snackBarCustom("NIP/Username dan Password tidak boleh kosong!", 0);
      return;
    }

    // Panggil AuthProvider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      // Tunggu hasil dari authProvider (true jika sukses, false jika gagal)
      bool isSuccess = await authProvider.login(username, password);

      if (isSuccess && mounted) {
        // Ambil data user yang berhasil login dari provider
        final user = authProvider.user;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Berhasil Login, ${user?.namaAsn ?? ''}",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF125B2A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );

        Navigator.pushReplacementNamed(context, '/dashboard');
      } else if (mounted) {
        snackBarCustom("Username/Password Salah", 0);
      }
    } catch (e) {
      if (mounted) snackBarCustom('Gagal memuat data: $e', 0);
    }
  }

  void snackBarCustom(String message, int status) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Widget custom untuk Input Field agar persis desain Figma
  Widget _buildCustomTextField({
    required String label,
    required String hint,
    bool isPassword = false,
    Function(String)? onChanged,
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
            border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          ),
          child: TextField(
            obscureText: isPassword,
            onChanged: onChanged,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF0F2E59),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                color: Colors.grey.shade400,
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
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // 1. LATAR BELAKANG BIRU MELENGKUNG
            Container(
              height: 420,
              decoration: BoxDecoration(
                gradient: const RadialGradient(
                  center: Alignment(0.0, -0.1),
                  radius: 0.75,
                  colors: [
                    Color(0xFF77899D),
                    Color(0xFF225894),
                    Color(0xFF1D3E62),
                  ],
                  stops: [0.2, 0.48, 1.0],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(screenWidth, 120),
                ),
              ),
            ),

            // 2. ILUSTRASI CEWEK & HP
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Image.asset(
                'assets/images/login.png',
                height: 230,
                fit: BoxFit.contain,
              ),
            ),

            // 3. KARTU PUTIH LOGIN
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                top: 280,
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
                    color: const Color(0xFF668EB9).withValues(alpha: 1.0),
                    blurRadius: 50,
                    spreadRadius: 5,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF334A66),
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildCustomTextField(
                    label: "NIP / Username",
                    hint: "Masukkan NIP Anda",
                    onChanged: (String value) {
                      username = value;
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildCustomTextField(
                    label: "Password",
                    hint: "........",
                    isPassword: true,
                    onChanged: (String value) {
                      password = value;
                    },
                  ),
                  const SizedBox(height: 36),

                  // Tombol Masuk dibungkus Consumer agar reaktif terhadap state loading
                  SizedBox(
                    width: 220,
                    height: 50,
                    child: Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF132F53),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          // Disable tombol saat loading
                          onPressed: auth.isLoading ? null : _handleLogin,
                          child: auth.isLoading
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
                        );
                      },
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
