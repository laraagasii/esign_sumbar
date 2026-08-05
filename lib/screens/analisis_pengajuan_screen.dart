import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:proyek_esign/custom_bottom_navbar.dart';
import 'package:proyek_esign/providers/auth_provider.dart';
import 'package:proyek_esign/widgets/filter_analitik_dialog.dart';

class AnalisisPengajuanScreen extends StatefulWidget {
  const AnalisisPengajuanScreen({super.key});

  @override
  State<AnalisisPengajuanScreen> createState() =>
      _AnalisisPengajuanScreenState();
}

class _AnalisisPengajuanScreenState extends State<AnalisisPengajuanScreen> {
  String _selectedPeriode = 'Bulan Ini';
  String? _selectedDinas;

  Future<void> _showFilterDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => FilterAnalitikDialog(
        initialPeriode: _selectedPeriode,
        initialDinas: _selectedDinas,
        showDinasFilter: false,
      ),
    );
    if (result != null) {
      setState(() {
        _selectedPeriode = result['periode'] as String;
        _selectedDinas = result['dinas'] as String?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // [RBAC] Jika Pejabat (Kepala Dinas/Kabid), maka pengajuannya kosong
    final isPejabat =
        Provider.of<AuthProvider>(context, listen: false).user?.isPejabat ??
            false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Header Gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 260,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF132F53), Color(0xFF5A84AB)],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child: Center(
                    child: Text(
                      'Dashboard Analitik',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // CONTENT STACK
                Expanded(
                  child: Stack(
                    children: [
                      // White card
                      Positioned.fill(
                        top: 32,
                        child: Container(
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
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 48, 16, 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Analitik Pengajuan Saya',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF0F2E59),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildRingkasanSection(isPejabat),
                                const SizedBox(height: 12),
                                _buildStatusPengajuanCard(isPejabat),
                                const SizedBox(height: 12),
                                _buildDurasiPenyelesaianCard(isPejabat),
                                const SizedBox(height: 12),
                                _buildInsightCard(isPejabat),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Toggle + Filter overlay
                      Positioned(
                        top: 9,
                        left: 16,
                        right: 16,
                        child: _buildToggleRow(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 1),
    );
  }

  Widget _buildToggleRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      '/analisis',
                    ),
                    child: Center(
                      child: Text(
                        'Persetujuan',
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.09),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Pengajuan',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF132F53),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _showFilterDialog(context),
              child: Container(
                height: 44,
                width: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF132F53),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Filter',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRingkasanSection(bool isPejabat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan',
            style: GoogleFonts.inter(
              color: const Color(0xFF0F2E59),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9EE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nota Dinas',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFDB913),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isPejabat ? '0' : '25',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF0F2E59),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Pengajuan',
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F7FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SPT',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF0088FF),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isPejabat ? '0' : '18',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF0F2E59),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Pengajuan',
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPengajuanCard(bool isPejabat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Pengajuan',
            style: GoogleFonts.inter(
              color: const Color(0xFF0F2E59),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 30,
                    startDegreeOffset: -90,
                    sections: [
                      PieChartSectionData(
                        color: const Color(0xFFE8F5E9),
                        value: isPejabat ? 1 : 20,
                        title: '',
                        radius: 15,
                      ),
                      PieChartSectionData(
                        color: isPejabat ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                        value: isPejabat ? 0 : 15,
                        title: '',
                        radius: 15,
                      ),
                      PieChartSectionData(
                        color: isPejabat ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                        value: isPejabat ? 0 : 8,
                        title: '',
                        radius: 15,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildStatusRow(
                      'Disetujui',
                      isPejabat ? '0' : '20',
                      const Color(0xFFD3FBD4),
                      const Color(0xFF125B2A),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusRow(
                      'Berjalan',
                      isPejabat ? '0' : '15',
                      const Color(0xFFFEF9C3),
                      const Color(0xFFD4A72C),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusRow(
                      'Ditolak',
                      isPejabat ? '0' : '8',
                      const Color(0xFFFFEBEE),
                      const Color(0xFFE53935),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String count, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
          Row(
            children: [
              Text(
                count,
                style: GoogleFonts.inter(
                  color: const Color(0xFF0F2E59),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Pengajuan',
                style: GoogleFonts.inter(
                  color: Colors.grey.shade500,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDurasiPenyelesaianCard(bool isPejabat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rata - rata Durasi Penyelesaian',
            style: GoogleFonts.inter(
              color: const Color(0xFF0F2E59),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Nota Dinas',
            style: GoogleFonts.inter(
              color: const Color(0xFF0F2E59),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: isPejabat ? 0.0 : 0.6,
                    backgroundColor: Colors.grey.shade100,
                    color: const Color(0xFFFDE08B),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isPejabat ? '0 Hari' : '2,4 Hari',
                style: GoogleFonts.inter(
                  color: const Color(0xFF0F2E59),
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'SPT',
            style: GoogleFonts.inter(
              color: const Color(0xFF0F2E59),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: isPejabat ? 0.0 : 0.4,
                    backgroundColor: Colors.grey.shade100,
                    color: const Color(0xFFBCE0FD),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isPejabat ? '0 Hari' : '1,2 Hari',
                style: GoogleFonts.inter(
                  color: const Color(0xFF0F2E59),
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(bool isPejabat) {
    if (isPejabat) {
      return const SizedBox.shrink(); // Hide insight if no data
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Insight',
            style: GoogleFonts.inter(
              color: const Color(0xFF0F2E59),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9EE),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '70% pengajuan selesai kurang dari 3 hari',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF0F2E59),
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F7FA),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'SPT rata-rata selesai 0,9 hari lebih cepat',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF0F2E59),
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
