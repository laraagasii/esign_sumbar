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
import 'package:connectivity_plus/connectivity_plus.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/daftar_nota_dinas_screen.dart';
import 'screens/detail_riwayat_nota_dinas_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/offline_screen.dart';
import 'screens/splash_screen.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables dari file .env
  await dotenv.load(fileName: ".env");

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    // Check initial status
    Connectivity().checkConnectivity().then((result) {
      setState(() {
        _isOffline = result.contains(ConnectivityResult.none);
      });
    });

    // Listen for changes
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      setState(() {
        _isOffline = result.contains(ConnectivityResult.none);
      });
    });
  }

  void _checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _isOffline = result.contains(ConnectivityResult.none);
    });
  }

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
      builder: (context, child) {
        if (_isOffline) {
          return OfflineScreen(onRetry: _checkConnection);
        }
        return child!;
      },
      home: const SplashScreen(),
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
