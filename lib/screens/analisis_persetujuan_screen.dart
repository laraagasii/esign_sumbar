import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyek_esign/providers/auth_provider.dart';
import 'package:proyek_esign/widgets/custom_bottom_navbar.dart';
import 'package:proyek_esign/widgets/filter_analitik_dialog.dart';
import 'package:proyek_esign/services/ai_analytic_service.dart';

class AnalisisPersetujuanScreen extends StatefulWidget {
  const AnalisisPersetujuanScreen({super.key});

  @override
  State<AnalisisPersetujuanScreen> createState() =>
      _AnalisisPersetujuanScreenState();
}

class _AnalisisPersetujuanScreenState extends State<AnalisisPersetujuanScreen> {
  String _selectedPeriode = 'Bulan Ini';
  String? _selectedDinas;

  bool _isLoading = true;
  Map<String, dynamic>? _predictData;
  Map<String, dynamic>? _weeklyData;
  Map<String, dynamic>? _monthlyData;
  Map<String, dynamic>? _summaryData;

  @override
  void initState() {
    super.initState();
    _fetchAiData();
  }

  Future<void> _fetchAiData() async {
    final groupId = Provider.of<AuthProvider>(context, listen: false).user?.group.toString() ?? '6';
    final service = AiAnalyticService();
    try {
      final results = await Future.wait([
        service.fetchPrediction(groupId),
        service.fetchWeeklyPattern(groupId),
        service.fetchMonthlyTrend(groupId),
        service.fetchSummary(groupId),
      ]);
      if (mounted) {
        setState(() {
          _predictData = results[0];
          _weeklyData = results[1];
          _monthlyData = results[2];
          _summaryData = results[3];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching AI data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF132F53), Color(0xFF5A84AB)],
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
                                  color: const Color(0xFF0F2E59),
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
                                  Expanded(
                                    child: _buildBarChartCard(),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildPrediksiCard(),
                                  ),
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
                      context,
                      '/analisis_pengajuan',
                    ),
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

  Widget _buildRingkasanSection() {
    final bool isPejabat =
        Provider.of<AuthProvider>(context, listen: false).user?.isPejabat ??
            false;

    if (_isLoading) {
      return Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    String totalMasuk = '0';
    String totalSetuju = '0';
    String totalBerjalan = '0';
    String totalTolak = '0';

    if (_summaryData != null) {
      totalMasuk = _summaryData!['surat_masuk'].toString();
      totalSetuju = _summaryData!['disetujui'].toString();
      totalBerjalan = _summaryData!['berjalan'].toString();
      totalTolak = _summaryData!['ditolak'].toString();
    }

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
            'Bulan Ini',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildStatCard(
                isPejabat ? totalMasuk : '0',
                'Surat Masuk',
                const Color(0xFF3B82F6),
                const Color(0xFFEFF6FF),
              ),
              _buildStatCard(
                isPejabat ? totalSetuju : '0',
                'Disetujui',
                const Color(0xFF125B2A),
                const Color(0xFFD3FBD4),
              ),
              _buildStatCard(
                isPejabat ? totalBerjalan : '0',
                'Berjalan',
                const Color(0xFFD4A72C),
                const Color(0xFFFEF9C3),
              ),
              _buildStatCard(
                isPejabat ? totalTolak : '0',
                'Ditolak',
                const Color(0xFFE53935),
                const Color(0xFFFFEBEE),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    Color textColor,
    Color bgColor,
  ) {
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
    if (_isLoading) {
      return Container(
        height: 172,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    List<double> values = [0, 0, 0, 0, 0, 0];
    List<String> labels = ['', '', '', '', '', ''];

    if (_monthlyData != null && _monthlyData!['tren_bulanan'] != null) {
      final list = _monthlyData!['tren_bulanan'] as List;
      for (int i = 0; i < list.length && i < 6; i++) {
        values[i] = (list[i]['total'] as num).toDouble();
        labels[i] = list[i]['bulan'].toString();
      }
    }

    double maxVal = 50;
    for (var v in values) {
      if (v > maxVal) maxVal = v;
    }
    maxVal = ((maxVal / 50).ceil() * 50).toDouble();
    if (maxVal < 50) maxVal = 50;

    // Y-axis labels dynamically generated based on maxVal
    List<String> yLabels = [];
    for (int i = 4; i >= 0; i--) {
      yLabels.add((maxVal * (i / 4)).toInt().toString());
    }

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
            'Jumlah Nodin dan SPT yang masuk 6 bulan terakhir',
            style: GoogleFonts.inter(
              fontSize: 9.5,
              color: Colors.grey.shade500,
            ),
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
                      children: yLabels
                          .map(
                            (v) => Text(
                              v,
                              style: GoogleFonts.inter(
                                fontSize: 8.5,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          )
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
                          painter: LineChartPainter(values, maxVal),
                          child: const SizedBox.expand(),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: labels
                            .map(
                              (m) => Text(
                                m,
                                style: GoogleFonts.inter(
                                  fontSize: 8.5,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            )
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
    if (_isLoading) {
      return Container(
        height: 190,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    List<double> weeklyVals = [0, 0, 0, 0, 0];
    if (_weeklyData != null && _weeklyData!['pola_mingguan'] != null) {
      final list = _weeklyData!['pola_mingguan'] as List;
      for (int i = 0; i < 5; i++) {
        // Senin - Jumat
        weeklyVals[i] = (list[i]['rata_rata_pengajuan'] as num).toDouble();
      }
    }

    // Dynamic scaling for bar chart
    double maxVal = 20;
    for (var v in weeklyVals) {
      if (v > maxVal) maxVal = v;
    }
    maxVal = ((maxVal / 5).ceil() * 5).toDouble();
    if (maxVal < 20) maxVal = 20;

    List<String> yLabels = [];
    for (int i = 4; i >= 0; i--) {
      yLabels.add((maxVal * (i / 4)).toInt().toString());
    }

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
                    width: 16,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: yLabels
                          .map(
                            (v) => Text(
                              v,
                              style: GoogleFonts.inter(
                                fontSize: 7,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double chartHeight = constraints.maxHeight - 14;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildBarItem(
                            (weeklyVals[0] / maxVal) * chartHeight,
                            'Sen',
                          ),
                          _buildBarItem(
                            (weeklyVals[1] / maxVal) * chartHeight,
                            'Sel',
                          ),
                          _buildBarItem(
                            (weeklyVals[2] / maxVal) * chartHeight,
                            'Rab',
                          ),
                          _buildBarItem(
                            (weeklyVals[3] / maxVal) * chartHeight,
                            'Kam',
                          ),
                          _buildBarItem(
                            (weeklyVals[4] / maxVal) * chartHeight,
                            'Jum',
                          ),
                        ],
                      );
                    },
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
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 7, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildPrediksiCard() {
    if (_isLoading) {
      return Container(
        height: 190,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    String totalPred = '0';
    int totalPredInt = 0;
    int totalMasukInt = 0;
    String percentageStr = '0%';
    bool isIncrease = true;

    if (_predictData != null && _predictData!['prediksi_bulan_depan'] != null) {
      totalPredInt = _predictData!['prediksi_bulan_depan']['total_keseluruhan'];
      totalPred = totalPredInt.toString();
    }

    if (_summaryData != null && _summaryData!['surat_masuk'] != null) {
      totalMasukInt = _summaryData!['surat_masuk'];
    }

    if (totalMasukInt > 0) {
      double diff = (totalPredInt - totalMasukInt) / totalMasukInt * 100;
      isIncrease = diff >= 0;
      percentageStr = '${diff.abs().toStringAsFixed(1)}%';
    } else if (totalPredInt > 0) {
      isIncrease = true;
      percentageStr = '100%';
    }

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
                      totalPred,
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
                          horizontal: 5,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isIncrease ? const Color(0xFFF0FDF4) : const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isIncrease ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                              color: isIncrease ? const Color(0xFF22C55E) : const Color(0xFFE53935),
                              size: 9,
                            ),
                            Text(
                              percentageStr,
                              style: GoogleFonts.inter(
                                color: isIncrease ? const Color(0xFF22C55E) : const Color(0xFFE53935),
                                fontSize: 8,
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
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Prediksi AI berdasarkan\nTime Series Data',
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    color: Colors.grey.shade400,
                  ),
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
  final List<double> values;
  final double maxVal;

  LineChartPainter(this.values, this.maxVal);

  static const double _topPad = 13.0;

  @override
  void paint(Canvas canvas, Size size) {
    final List<double> actualValues = values;
    final int n = actualValues.length;

    if (n == 0) return;

    final double plotH = size.height - _topPad;

    final List<Offset> pts = List.generate(n, (i) {
      final x = i / (n - 1) * size.width;
      final y = _topPad + plotH - (actualValues[i] / maxVal) * plotH;
      return Offset(x, y);
    });

    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFF3F4F6)
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 4; i++) {
      final val = maxVal * (i / 4);
      final y = _topPad + plotH - (val / maxVal) * plotH;
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
      canvas.drawCircle(pts[i], 4.0, Paint()..color = const Color(0xFF3B82F6));
      canvas.drawCircle(pts[i], 2.0, Paint()..color = Colors.white);

      final tp = TextPainter(
        text: TextSpan(
          text: actualValues[i].toInt().toString(),
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
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.maxVal != maxVal;
  }
}
