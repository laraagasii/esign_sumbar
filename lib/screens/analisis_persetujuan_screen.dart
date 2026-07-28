import 'package:flutter/material.dart';
import 'package:proyek_esign/custom_bottom_navbar.dart';

class AnalisisPersetujuanScreen extends StatelessWidget {
  const AnalisisPersetujuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Gradasi latar belakang biru gelap ke terang (kiri atas ke kanan bawah)
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF132F53), Color(0xFF1E4879)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // --- 1. HEADER UTAMA ---
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Dashboard Analitik',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // --- 2. KONTEN DENGAN STACK (Posisi Putih Memotong Tengah Toggle) ---
              Expanded(
                child: Stack(
                  children: [
                    // Kontainer Putih Utama (Mulai dari tengah tinggi tombol toggle)
                    Positioned.fill(
                      top: 35,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 45, 20, 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // --- JUDUL ANALITIK PERSETUJUAN ---
                              const Text(
                                'Analitik Persetujuan',
                                style: TextStyle(
                                  color: Color(0xFF132F53),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 14),

                              // --- CONTAINER STROKE BUNGKUS JUDUL & 4 CARD RINGKASAN ---
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Ringkasan',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // 4 Card Ringkasan (Pake Shadow, Tanpa Stroke)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildRingkasanCard(
                                          '136',
                                          'Surat Masuk',
                                          const Color(0xFF3B82F6),
                                          const Color(0xFFEFF6FF),
                                        ),
                                        _buildRingkasanCard(
                                          '100',
                                          'Disetujui',
                                          const Color(0xFF10B981),
                                          const Color(0xFFECFDF5),
                                        ),
                                        _buildRingkasanCard(
                                          '30',
                                          'Berjalan',
                                          const Color(0xFFF59E0B),
                                          const Color(0xFFFEF3C7),
                                        ),
                                        _buildRingkasanCard(
                                          '8',
                                          'Ditolak',
                                          const Color(0xFFEF4444),
                                          const Color(0xFFFEF2F2),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // --- CARD TREN PENGAJUAN ---
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tren Pengajuan Perjalanan Dinas',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Jumlah Nodin dan SPT yang masuk pada periode terpilih',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      height: 150,
                                      width: double.infinity,
                                      child: Stack(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children:
                                                ['200', '150', '100', '50', '0']
                                                    .map(
                                                      (val) => Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 25,
                                                            child: Text(
                                                              val,
                                                              style: TextStyle(
                                                                fontSize: 9,
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              height: 1,
                                                              color: Colors
                                                                  .grey
                                                                  .shade100,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                    .toList(),
                                          ),
                                          Positioned(
                                            left: 25,
                                            right: 0,
                                            top: 10,
                                            bottom: 15,
                                            child: CustomPaint(
                                              painter: LineChartPainter(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 25),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children:
                                            [
                                                  'Jan',
                                                  'Mar',
                                                  'Mai',
                                                  'Juli',
                                                  'Sep',
                                                  'Nov',
                                                ]
                                                .map(
                                                  (bulan) => Text(
                                                    bulan,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color:
                                                          Colors.grey.shade500,
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // --- DUA CARD BAGIAN BAWAH ---
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 180,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Analisis Pola Waktu Pengajuan',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 2,
                                          ),
                                          const SizedBox(height: 8),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children:
                                                      [
                                                            '20',
                                                            '15',
                                                            '10',
                                                            '5',
                                                            '0',
                                                          ]
                                                          .map(
                                                            (val) => Text(
                                                              val,
                                                              style: TextStyle(
                                                                fontSize: 8,
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                            ),
                                                          )
                                                          .toList(),
                                                ),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      _buildMiniBar(45, 'Sen'),
                                                      _buildMiniBar(85, 'Sel'),
                                                      _buildMiniBar(65, 'Rab'),
                                                      _buildMiniBar(35, 'Kam'),
                                                      _buildMiniBar(30, 'Jum'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Container(
                                      height: 180,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Prediksi Beban Bulan Depan',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 2,
                                          ),
                                          const Spacer(),
                                          Center(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    const Text(
                                                      '136',
                                                      style: TextStyle(
                                                        fontSize: 26,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(
                                                          0xFF3B82F6,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                            vertical: 2,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .green
                                                            .shade50,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                      child: const Text(
                                                        '+10%',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Text(
                                                  'Pengajuan',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  'Prediksi berdasarkan tren 6 bulan terakhir',
                                                  style: TextStyle(
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
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // --- TOGGLE & FILTER (Diposisikan Memotong Garis Putih) ---
                    Positioned(
                      top: 12,
                      left: 20,
                      right: 20,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 46,
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
                                            color: Colors.black.withOpacity(
                                              0.08,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Persetujuan',
                                        style: TextStyle(
                                          color: Color(0xFF132F53),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/analisis_pengajuan',
                                        );
                                      },
                                      child: const Center(
                                        child: Text(
                                          'Pengajuan',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
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
                          const SizedBox(width: 12),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 46,
                                width: 46,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF132F53),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.tune_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Filter',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  // --- WIDGET PENDUKUNG ---

  Widget _buildRingkasanCard(
    String value,
    String label,
    Color textColor,
    Color bgColor,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          // Tanpa border/stroke, menggunakan efek shadow halus
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
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

  Widget _buildMiniBar(double height, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 12,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 8, color: Colors.grey.shade500)),
      ],
    );
  }
}

// --- CUSTOM PAINTER UNTUK GRAFIK GARIS (LINE CHART) ---
class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = const Color(0xFF3B82F6)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintDot = Paint()
      ..color = const Color(0xFF3B82F6)
      ..style = PaintingStyle.fill;

    final paintWhiteDot = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final points = [
      Offset(0, size.height * 0.4),
      Offset(size.width * 0.18, size.height * 0.7),
      Offset(size.width * 0.36, size.height * 0.6),
      Offset(size.width * 0.54, size.height * 0.45),
      Offset(size.width * 0.72, size.height * 0.2),
      Offset(size.width, size.height * 0.1),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paintLine);

    for (var point in points) {
      canvas.drawCircle(point, 4, paintDot);
      canvas.drawCircle(point, 2, paintWhiteDot);
    }
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) => false;
}
