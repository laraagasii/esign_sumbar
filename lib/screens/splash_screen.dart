import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyek_esign/providers/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyek_esign/screens/login_screen.dart';
import 'package:proyek_esign/screens/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    _animationController.forward();
    
    _checkStatusLogin();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkStatusLogin() async {
    // 1. Ambil provider SEBELUM ada perintah await biar Flutter nggak ngomel
    final authProv = context.read<AuthProvider>();

    // 2. Buka "brankas" memori HP
    final prefs = await SharedPreferences.getInstance();

    // 3. Cek apakah ada data sesi.
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Tunggu animasi selesai dan tambahan waktu sedikit untuk membaca splash screen
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 4. Arahkan rute sesuai status dengan transisi smooth
    if (isLoggedIn) {
      // Panggil fungsi checkLoginStatus()
      await authProv.checkLoginStatus();
      _navigateToNextScreen(const DashboardScreen());
    } else {
      _navigateToNextScreen(const LoginScreen());
    }
  }

  void _navigateToNextScreen(Widget screen) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Animasi Fade In yang mulus
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        // Durasi transisinya dibuat lumayan pelan biar elegan
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2E59), // Primary Dark Blue
      body: Stack(
        children: [
          // Background Gradient (Optional for depth)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F2E59),
                  Color(0xFF1A467D),
                ],
              ),
            ),
          ),
          
          // Main Content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/ikon.png', // Logo Provinsi/E-Sign
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.security, // Fallback icon
                          size: 100,
                          color: Color(0xFF0F2E59),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // App Name
                  Text(
                    'E-SIGN',
                    style: GoogleFonts.inter(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Subtitle
                  Text(
                    'Provinsi Sumatera Barat',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Loading Indicator at Bottom
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Memuat data...',
                  style: GoogleFonts.inter(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
