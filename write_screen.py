content = """\
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyek_esign/custom_bottom_navbar.dart';
import 'package:proyek_esign/filter_analitik_dialog.dart';

class AnalisisPersetujuanScreen extends StatefulWidget {
  const AnalisisPersetujuanScreen({super.key});

  @override
  State<AnalisisPersetujuanScreen> createState() =>
      _AnalisisPersetujuanScreenState();
}

class _AnalisisPersetujuanScreenState extends State<AnalisisPersetujuanScreen> {
  String _selectedPeriode = 'Bulan Ini';
  String? _selectedDinas;

  Future<void> _showFilterDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => FilterAnalitikDialog(
        initialPeriode: _selectedPeriode,
        initialDinas: _selectedDinas,
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B1F3A), Color(0xFF1A4070)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // HEADER - compact
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 8),
                child: Text(
                  'Dashboard Analitik',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
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
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(26),
                            topRight: Radius.circular(26),
                          ),
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 48, 16, 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Analitik Persetujuan',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF0F2544),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildRingkasanSection(),
                              const SizedBox(height: 12),
                              _buildTrenCard(),
                              const SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: _buildBarChartCard()),
                                  const SizedBox(width: 10),
                                  Expanded(child: _buildPrediksiCard()),
                                ],
                              ),
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
                      'Persetujuan',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF132F53),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(
                        context, '/analisis_pengajuan'),
                    child: Center(
                      child: Text(
                        'Pengajuan',
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
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
                child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
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

  Widget _buildRingkasanSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan',
            style: GoogleFonts.inter(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildStatCard('136', 'Surat Masuk',
                  const Color(0xFF3B82F6), const Color(0xFFEFF6FF)),
              _buildStatCard('100', 'Disetujui',
                  const Color(0xFF10B981), const Color(0xFFECFDF5)),
              _buildStatCard('30', 'Berjalan',
                  const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
              _buildStatCard('8', 'Ditolak',
                  const Color(0xFFEF4444), const Color(0xFFFEF2F2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String value, String label, Color textColor, Color bgColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrenCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tren Pengajuan Perjalanan Dinas',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Jumlah Nodin dan SPT yang masuk pada periode terpilih',
            style: GoogleFonts.inter(
                fontSize: 9.5, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 172,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    width: 26,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: ['200', '150', '100', '50', '0']
                          .map((v) => Text(v,
                              style: GoogleFonts.inter(
                                  fontSize: 8.5,
                                  color: Colors.grey.shade400)))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomPaint(
                          painter: LineChartPainter(),
                          child: const SizedBox.expand(),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          'Jan', 'Mar', 'Mai', 'Juli', 'Sep', 'Nov'
                        ]
                            .map((m) => Text(m,
                                style: GoogleFonts.inter(
                                    fontSize: 8.5,
                                    color: Colors.grey.shade400)))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartCard() {
    return Container(
      height: 190,
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analisis Pola Waktu Pengajuan',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: SizedBox(
                    width: 14,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: ['20', '15', '10', '5', '0']
                          .map((v) => Text(v,
                              style: GoogleFonts.inter(
                                  fontSize: 7,
                                  color: Colors.grey.shade400)))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBarItem(22, 'Sen'),
                      _buildBarItem(80, 'Sel'),
                      _buildBarItem(53, 'Rab'),
                      _buildBarItem(31, 'Kam'),
                      _buildBarItem(18, 'Jum'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarItem(double height, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 13,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 3),
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 7, color: Colors.grey.shade500)),
      ],
    );
  }

  Widget _buildPrediksiCard() {
    return Container(
      height: 190,
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prediksi Beban Bulan Depan',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
          ),
          const Spacer(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '136',
                      style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3B82F6),
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.arrow_upward_rounded,
                                color: Color(0xFF22C55E), size: 9),
                            Text(
                              '+10%',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF22C55E),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Pengajuan',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 6),
                Text(
                  'Prediksi berdasarkan tren 6 bulan terakhir',
                  style: GoogleFonts.inter(
                      fontSize: 8, color: Colors.grey.shade400),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

// LINE CHART PAINTER
class LineChartPainter extends CustomPainter {
  static const List<double> _values = [
    100, 65, 73, 85, 95, 90, 117, 170, 129, 128, 189, 198
  ];
  static const double _maxVal = 200;
  static const double _topPad = 13.0;

  @override
  void paint(Canvas canvas, Size size) {
    final int n = _values.length;
    final double plotH = size.height - _topPad;

    final List<Offset> pts = List.generate(n, (i) {
      final x = i / (n - 1) * size.width;
      final y = _topPad + plotH - (_values[i] / _maxVal) * plotH;
      return Offset(x, y);
    });

    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFF3F4F6)
      ..strokeWidth = 1.0;
    for (final val in [0.0, 50.0, 100.0, 150.0, 200.0]) {
      final y = _topPad + plotH - (val / _maxVal) * plotH;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Gradient fill
    final fillPath = Path()
      ..moveTo(pts.first.dx, size.height)
      ..lineTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < n; i++) {
      fillPath.lineTo(pts[i].dx, pts[i].dy);
    }
    fillPath
      ..lineTo(pts.last.dx, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF3B82F6).withOpacity(0.13),
            const Color(0xFF3B82F6).withOpacity(0.01),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Line
    final linePath = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < n; i++) {
      linePath.lineTo(pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = const Color(0xFF3B82F6)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Dots + value labels
    for (int i = 0; i < n; i++) {
      canvas.drawCircle(
          pts[i], 4.0, Paint()..color = const Color(0xFF3B82F6));
      canvas.drawCircle(pts[i], 2.0, Paint()..color = Colors.white);

      final tp = TextPainter(
        text: TextSpan(
          text: _values[i].toInt().toString(),
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 7.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      double lx = pts[i].dx - tp.width / 2;
      double ly = pts[i].dy - tp.height - 3;
      lx = lx.clamp(0.0, size.width - tp.width);
      if (ly < 0) ly = pts[i].dy + 5;

      tp.paint(canvas, Offset(lx, ly));
    }
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) => false;
}
"""

with open(r"d:\esign\proyek_esign\lib\screens\analisis_persetujuan_screen.dart", "w", encoding="utf-8") as f:
    f.write(content)

print("SUCCESS - lines written:", len(content.splitlines()))
