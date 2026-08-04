import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyek_esign/providers/auth_provider.dart';
import 'package:proyek_esign/providers/home_provider.dart';
import 'package:proyek_esign/providers/nota_dinas_provider.dart';
import 'package:proyek_esign/providers/spt_provider.dart';
import 'package:proyek_esign/screens/analisis_persetujuan_screen.dart';
import 'package:proyek_esign/screens/analisis_pengajuan_screen.dart';
import 'package:proyek_esign/screens/riwayat_pengajuan_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/daftar_nota_dinas_screen.dart';
import 'screens/detail_riwayat_nota_dinas_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  // Wajib ditambahkan agar sistem native Flutter (seperti storage) siap sebelum menjalankan aplikasi
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // Daftarkan Provider di akar aplikasi
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => NotaDinasProvider()),
        ChangeNotifierProvider(create: (_) => SptProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-SIGN Provinsi Sumatera Barat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0F2E59),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F2E59),
          primary: const Color(0xFF0F2E59),
        ),
        useMaterial3: true,
      ),
      home: const AuthChecker(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/nota_dinas': (context) => const DaftarNotaDinasScreen(),
        '/analisis': (context) => const AnalisisPersetujuanScreen(),
        '/analisis_pengajuan': (context) => const AnalisisPengajuanScreen(),
        '/riwayat': (context) => const RiwayatPengajuanNodinScreen(),
        '/detail_riwayat_nota_dinas': (context) =>
            const DetailRiwayatNotaDinasScreen(
              pengikutTerpilih: [],
              pengikutDibatalkan: [],
            ),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  @override
  void initState() {
    super.initState();
    _checkStatusLogin();
  }

  Future<void> _checkStatusLogin() async {
    // 1. Ambil provider SEBELUM ada perintah await biar Flutter nggak ngomel
    final authProv = context.read<AuthProvider>();

    // 2. Buka "brankas" memori HP
    final prefs = await SharedPreferences.getInstance();

    // 3. Cek apakah ada data sesi.
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Kasih delay dikit biar transisinya lebih smooth (opsional)
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // 4. Arahkan rute sesuai status
    if (isLoggedIn) {
      // Panggil fungsi checkLoginStatus() yang ada di AuthProvider milikmu
      await authProv.checkLoginStatus();
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        // Ini akan jadi Splash Screen sementara (animasi loading muter)
        child: CircularProgressIndicator(),
      ),
    );
  }
}
