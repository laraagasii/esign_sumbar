import 'package:flutter/material.dart';
import 'package:proyek_esign/screens/riwayat_nota_dinas_screen.dart';
import 'package:proyek_esign/screens/detail_riwayat_nota_dinas_screen.dart';

import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/daftar_nota_dinas_screen.dart';
import 'screens/detail_nota_dinas_screen.dart';

void main() {
  runApp(const MyApp());
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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/nota_dinas': (context) => const DaftarNotaDinasScreen(),
        '/detail_nota_dinas': (context) => const DetailNotaDinasScreen(),
        '/riwayat': (context) => const RiwayatNotaDinasScreen(),
        '/detail_riwayat_nota_dinas': (context) =>
            const DetailRiwayatNotaDinasScreen(
              pengikutTerpilih: [],
              pengikutDibatalkan: [],
            ),
      },
    );
  }
}
