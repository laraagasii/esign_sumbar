import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OfflineScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const OfflineScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: 100,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 24),
              Text(
                'Tidak Ada Koneksi',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F2E59),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Aplikasi membutuhkan koneksi internet untuk dapat digunakan. Silakan periksa koneksi internet Anda dan coba lagi.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F2E59),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Coba Lagi',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
