import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterAnalitikDialog extends StatefulWidget {
  final String initialPeriode;
  final String? initialDinas;

  const FilterAnalitikDialog({
    super.key,
    this.initialPeriode = 'Bulan Ini',
    this.initialDinas,
  });

  @override
  State<FilterAnalitikDialog> createState() => _FilterAnalitikDialogState();
}

class _FilterAnalitikDialogState extends State<FilterAnalitikDialog> {
  late String _selectedPeriode;
  String? _selectedDinas;

  final List<String> _periodeOptions = [
    'Bulan Ini',
    'Triwulan Ini',
    'Tahun Ini',
    'Pilih Tanggal Sendiri',
  ];

  // Daftar lengkap Biro, Dinas, dan Badan Pemprov Sumbar
  final List<String> _dinasBiroBadanOptions = [
    // --- BIRO ---
    'Biro Umum Setda Provinsi Sumatera Barat',
    'Biro Organisasi',
    'Biro Administrasi Pimpinan',
    'Biro Administrasi Pembangunan',
    'Biro Pemerintahan dan Otonomi Daerah',
    'Biro Hukum',
    'Biro Perekonomian',
    'Biro Kesejahteraan Rakyat',
    'Biro Pengadaan Barang dan Jasa',

    // --- DINAS ---
    'Dinas Komunikasi, Informatika, dan Statistik',
    'Dinas Kesehatan Provinsi Sumatera Barat',
    'Dinas Pendidikan Provinsi Sumatera Barat',
    'Dinas Pekerjaan Umum dan Penataan Ruang',
    'Dinas Pariwisata',
    'Dinas Sosial',
    'Dinas Kehutanan',
    'Dinas Kelautan dan Perikanan',
    'Dinas Perhubungan',
    'Dinas Energi dan Sumber Daya Mineral',
    'Dinas Lingkungan Hidup',
    'Dinas Koperasi dan UKM',
    'Dinas Penanaman Modal dan Pelayanan Terpadu Satu Pintu',
    'Dinas Pemuda dan Olahraga',
    'Dinas Pemberdayaan Masyarakat dan Desa',
    'Dinas Pemberdayaan Perempuan dan Perlindungan Anak',
    'Dinas Tenaga Kerja dan Transmigrasi',
    'Dinas Perkebunan, Tanaman Pangan dan Hortikultura',
    'Dinas Peternakan dan Kesehatan Hewan',
    'Dinas Perindustrian dan Perdagangan',
    'Dinas Kebudayaan',
    'Dinas Perumahan Rakyat, Kawasan Permukiman dan Pertanahan',
    'Dinas Kependudukan dan Pencatatan Sipil',

    // --- BADAN ---
    'Badan Pendapatan Daerah Provinsi Sumatera Barat',
    'Badan Perencanaan Pembangunan Daerah',
    'Badan Kepegawaian Daerah',
    'Badan Penanggulangan Bencana Daerah',
    'Badan Kesatuan Bangsa dan Politik',
    'Badan Penelitian dan Pengembangan',
    'Badan Penghubung',
  ];

  @override
  void initState() {
    super.initState();
    _selectedPeriode = widget.initialPeriode;
    _selectedDinas = widget.initialDinas;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Dashboard Analitik',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF132F53),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Color(0xFF132F53)),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- PERIODE ---
              Text(
                'Periode',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _periodeOptions.map((periode) {
                  return _buildFilterChip(
                    label: periode,
                    isSelected: _selectedPeriode == periode,
                    onTap: () => setState(() => _selectedPeriode = periode),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // --- DROPDOWN DINAS/BIRO/BADAN ---
              Text(
                'Perangkat Daerah',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),

              LayoutBuilder(
                builder: (context, constraints) {
                  return DropdownMenu<String>(
                    width: constraints.maxWidth,
                    menuHeight: 220,
                    enableFilter: true,
                    requestFocusOnTap: true,
                    hintText: 'Cari instansi...',
                    initialSelection: _selectedDinas,
                    textStyle: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF132F53),
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF132F53)),
                      ),
                    ),
                    onSelected: (String? newValue) {
                      setState(() {
                        _selectedDinas = newValue;
                      });
                    },
                    dropdownMenuEntries: _dinasBiroBadanOptions
                        .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                            value: value,
                            label: value,
                            style: MenuItemButton.styleFrom(
                              textStyle: GoogleFonts.inter(fontSize: 13),
                            ),
                          );
                        })
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 32),

              // --- TOMBOL RESET & TERAPKAN ---
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF132F53)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, {
                            'periode': 'Bulan Ini',
                            'dinas': null,
                          });
                        },
                        child: Text(
                          'Reset',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF132F53),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF132F53),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pop(context, {
                            'periode': _selectedPeriode,
                            'dinas': _selectedDinas,
                          });
                        },
                        child: Text(
                          'Terapkan',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF132F53) : Colors.white,
          border: Border.all(
            color: isSelected
                ? const Color(0xFF132F53)
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
