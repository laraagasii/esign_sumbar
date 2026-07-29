import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterAnalitikDialog extends StatefulWidget {
  final String initialPeriode;
  final String? initialDinas;
  final bool showDinasFilter;

  const FilterAnalitikDialog({
    super.key,
    this.initialPeriode = 'Bulan Ini',
    this.initialDinas,
    this.showDinasFilter = true,
  });

  @override
  State<FilterAnalitikDialog> createState() => _FilterAnalitikDialogState();
}

class _FilterAnalitikDialogState extends State<FilterAnalitikDialog> {
  late String _selectedPeriode;
  String? _selectedDinas;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  final List<String> _presetPeriodeOptions = [
    'Bulan Ini',
    'Triwulan Ini',
    'Tahun Ini',
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
    if (_selectedPeriode == 'Pilih Tanggal Sendiri') {
      _selectedPeriode = 'Pilih Tanggal';
    }
    _selectedDinas = widget.initialDinas;
  }

  String _formatStartEndDates(DateTime start, DateTime end) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    if (start.year == end.year &&
        start.month == end.month &&
        start.day == end.day) {
      return "${start.day} ${months[start.month - 1]} ${start.year}";
    } else if (start.year == end.year && start.month == end.month) {
      return "${start.day} - ${end.day} ${months[start.month - 1]} ${start.year}";
    } else if (start.year == end.year) {
      return "${start.day} ${months[start.month - 1]} - ${end.day} ${months[end.month - 1]} ${start.year}";
    } else {
      return "${start.day} ${months[start.month - 1]} ${start.year} - ${end.day} ${months[end.month - 1]} ${end.year}";
    }
  }

  Future<void> _pickCustomDateRange() async {
    final now = DateTime.now();

    // 1. Pilih Tanggal Mulai (Tampil di tengah, 1 bulan)
    final DateTime? startDate = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'PILIH TANGGAL MULAI',
      cancelText: 'BATAL',
      confirmText: 'LANJUT',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF132F53),
              onPrimary: Colors.white,
              onSurface: Color(0xFF132F53),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF132F53),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (startDate == null) return;

    if (!mounted) return;

    // 2. Pilih Tanggal Selesai (Tampil di tengah, 1 bulan)
    final DateTime? endDate = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? startDate,
      firstDate: startDate,
      lastDate: DateTime(2030),
      helpText: 'PILIH TANGGAL SELESAI',
      cancelText: 'BATAL',
      confirmText: 'SIMPAN',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF132F53),
              onPrimary: Colors.white,
              onSurface: Color(0xFF132F53),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF132F53),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    final finalEndDate = endDate ?? startDate;

    setState(() {
      _selectedStartDate = startDate;
      _selectedEndDate = finalEndDate;
      _selectedPeriode = _formatStartEndDates(startDate, finalEndDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isCustomDate = !_presetPeriodeOptions.contains(_selectedPeriode);
    String customChipLabel =
        (isCustomDate && _selectedPeriode != 'Pilih Tanggal')
        ? _selectedPeriode
        : 'Pilih Tanggal';

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
                children: [
                  ..._presetPeriodeOptions.map((periode) {
                    return _buildFilterChip(
                      label: periode,
                      isSelected: _selectedPeriode == periode,
                      onTap: () => setState(() => _selectedPeriode = periode),
                    );
                  }),
                  _buildFilterChip(
                    label: customChipLabel,
                    isSelected: isCustomDate,
                    icon: Icons.calendar_today_rounded,
                    onTap: _pickCustomDateRange,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (widget.showDinasFilter) ...[
                // --- DROPDOWN DINAS/BIRO/BADAN ---
                Text(
                  'Dinas/Biro/Badan',
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
                          borderSide: const BorderSide(
                            color: Color(0xFF132F53),
                          ),
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
              ],
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
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF132F53) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF132F53) : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.inter(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
