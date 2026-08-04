import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterNotaDinasDialog extends StatefulWidget {
  final Map<String, dynamic>? initialFilters;
  const FilterNotaDinasDialog({super.key, this.initialFilters});

  @override
  State<FilterNotaDinasDialog> createState() => _FilterNotaDinasDialogState();
}

class _FilterNotaDinasDialogState extends State<FilterNotaDinasDialog> {
  String? _selectedDinas;
  String _selectedKategori = "Semua";
  String _selectedWilayah = "Semua";

  // Variabel untuk menyimpan tanggal yang dipilih
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialFilters != null) {
      _selectedDinas = widget.initialFilters!['dinas'];
      _selectedKategori = widget.initialFilters!['kategori'] ?? "Semua";
      _selectedWilayah = widget.initialFilters!['wilayah'] ?? "Semua";
      _startDate = widget.initialFilters!['startDate'];
      _endDate = widget.initialFilters!['endDate'];
    }
  }

  final List<String> _kategoriOptions = [
    "Semua",
    "Ditolak",
    "Disetujui",
    "Proses",
  ];

  final List<String> _wilayahOptions = [
    "Semua",
    "Dalam Kota",
    "Dalam Daerah",
    "Luar Daerah",
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

  // Fungsi memanggil kalender bawaan Flutter
  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF132F53), // Warna dongker
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // Format tanggal ke string DD/MM/YY
  String _formatDate(DateTime? date) {
    if (date == null) return "DD/MM/YY";
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}";
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
                    "Filter Nota Dinas",
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

              // --- DROPDOWN DINAS/BIRO/BADAN ---
              Text(
                "Dinas/Biro/Badan",
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
                    hintText: "Cari instansi...",
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
              const SizedBox(height: 20),

              // --- INPUT TANGGAL ---
              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker("Tanggal Awal", _startDate, true),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("-", style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(
                    child: _buildDatePicker("Tanggal Akhir", _endDate, false),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- KATEGORI ---
              Text(
                "Kategori",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _kategoriOptions.map((kategori) {
                  return _buildFilterChip(
                    label: kategori,
                    isSelected: _selectedKategori == kategori,
                    onTap: () => setState(() => _selectedKategori = kategori),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // --- WILAYAH ---
              Text(
                "Wilayah",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _wilayahOptions.map((wilayah) {
                  return _buildFilterChip(
                    label: wilayah,
                    isSelected: _selectedWilayah == wilayah,
                    onTap: () => setState(() => _selectedWilayah = wilayah),
                  );
                }).toList(),
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
                            'dinas': null,
                            'kategori': "Semua",
                            'wilayah': "Semua",
                            'startDate': null,
                            'endDate': null,
                          });
                        },
                        child: Text(
                          "Reset",
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
                            'dinas': _selectedDinas,
                            'kategori': _selectedKategori,
                            'wilayah': _selectedWilayah,
                            'startDate': _startDate,
                            'endDate': _endDate,
                          });
                        },
                        child: Text(
                          "Terapkan",
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

  // --- Helpers Dialog ---
  Widget _buildDatePicker(String label, DateTime? selectedDate, bool isStart) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _pickDate(context, isStart),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      _formatDate(selectedDate),
                      style: GoogleFonts.inter(
                        color: selectedDate != null
                            ? const Color(0xFF132F53)
                            : Colors.grey.shade400,
                        fontSize: 12,
                        fontWeight: selectedDate != null
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Icon(
                    Icons.calendar_month_rounded,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
            color: isSelected ? const Color(0xFF132F53) : Colors.grey.shade300,
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
