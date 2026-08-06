class SptModel {
  final String id;
  final String opd;
  final String nmopd;
  final String perihal;
  final String tanggal;
  final String lokasi;
  final String category;
  final String detailType;
  final String status;
  final String statusLabel;
  final String rawStartDate;
  final String rawEndDate;
  final String year;

  SptModel({
    required this.id,
    required this.opd,
    required this.nmopd,
    required this.perihal,
    required this.tanggal,
    required this.lokasi,
    required this.category,
    required this.detailType,
    required this.status,
    required this.statusLabel,
    required this.rawStartDate,
    required this.rawEndDate,
    required this.year,
  });

  factory SptModel.fromJson(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);

    final dateStart =
        map['pergi']?.toString().trim() ??
        map['tglspt']?.toString().trim() ??
        map['tanggal']?.toString().trim() ??
        map['tgl']?.toString().trim() ??
        '';
    final dateEnd = map['pulang']?.toString().trim();
    final displayDate = _formatDateRange(dateStart, dateEnd);
    final rawCategory =
        map['kategori']?.toString().trim() ??
        map['nmkategori']?.toString().trim() ??
        '';
    final year = map['tahun']?.toString().trim().isNotEmpty == true
        ? map['tahun']!.toString().trim()
        : _extractYear(dateStart);

    return SptModel(
      id:
          map['sptid']?.toString() ??
          map['id']?.toString() ??
          map['idsurat']?.toString() ??
          '',
      opd: map['nopd']?.toString() ?? map['opd']?.toString() ?? '',
      nmopd: map['nmopd']?.toString() ?? '',
      perihal:
          map['maksud']?.toString() ??
          map['perihal']?.toString() ??
          map['judul']?.toString() ??
          '',
      tanggal: displayDate,
      lokasi: map['lokasi']?.toString() ?? map['tujuan']?.toString() ?? '',
      category:
          map['nmkategori']?.toString() ?? map['kategori']?.toString() ?? '',
      detailType: rawCategory,
      status: map['status']?.toString() ?? '',
      statusLabel:
          map['nmstatus']?.toString() ??
          map['status_label']?.toString() ??
          map['nama_status']?.toString() ??
          '',
      rawStartDate: dateStart,
      rawEndDate: dateEnd ?? '',
      year: year,
    );
  }

  static String _formatDateRange(String start, String? end) {
    if (start.isEmpty) return '';

    final parsedStart = _parseDate(start);
    final parsedEnd = end != null && end.isNotEmpty ? _parseDate(end) : null;

    if (parsedStart == null) {
      return end != null && end.isNotEmpty ? '$start - $end' : start;
    }

    if (parsedEnd == null) {
      return _formatDate(parsedStart);
    }

    if (parsedStart.year == parsedEnd.year &&
        parsedStart.month == parsedEnd.month) {
      if (parsedStart.day == parsedEnd.day) {
        return _formatDate(parsedStart);
      }
      return '${parsedStart.day.toString().padLeft(2, '0')}-${parsedEnd.day.toString().padLeft(2, '0')} ${_monthName(parsedStart.month)} ${parsedStart.year}';
    }

    if (parsedStart.year == parsedEnd.year) {
      return '${_formatDate(parsedStart)} - ${_formatDate(parsedEnd)}';
    }

    return '${_formatDate(parsedStart)} - ${_formatDate(parsedEnd)}';
  }

  static String _extractYear(String value) {
    final parsed = _parseDate(value);
    return parsed?.year.toString() ?? DateTime.now().year.toString();
  }

  static DateTime? _parseDate(String value) {
    final raw = value.trim();
    if (raw.isEmpty) return null;

    try {
      return DateTime.parse(raw);
    } catch (_) {}

    final slashParts = raw.split(RegExp(r'[\/\-\s]+'));
    if (slashParts.length == 3) {
      final first = int.tryParse(slashParts[0]);
      final second = int.tryParse(slashParts[1]);
      final third = int.tryParse(slashParts[2]);
      if (first != null && second != null && third != null) {
        if (first > 31) {
          return DateTime(first, second, third);
        }
        return DateTime(third, second, first);
      }
    }

    final parts = raw.split(' ');
    if (parts.length >= 3) {
      final day = int.tryParse(parts[0]);
      final month = _monthNameToNumber(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    return null;
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}';
  }

  static String _monthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  static int? _monthNameToNumber(String name) {
    final lower = name.toLowerCase();
    final months = {
      'januari': 1,
      'februari': 2,
      'maret': 3,
      'april': 4,
      'mei': 5,
      'juni': 6,
      'juli': 7,
      'agustus': 8,
      'september': 9,
      'oktober': 10,
      'november': 11,
      'desember': 12,
    };
    return months[lower];
  }

  static String _cleanStatus(String rawStatus) {
    return rawStatus
        .replaceAll(RegExp(r'Surat Tugas\s+', caseSensitive: false), '')
        .trim();
  }

  String get title => nmopd.isNotEmpty ? nmopd : opd;
  String get description => perihal;
  String get categoryLabel => category.isNotEmpty ? category : statusLabel;
  String get location => lokasi;
  String get date => tanggal;

  Map<String, dynamic> toDisplayMap() {
    final cleanStatusStr = _cleanStatus(
      statusLabel.isNotEmpty ? statusLabel : status,
    );
    return {
      'id': id,
      'title': title,
      'category': categoryLabel,
      'detailType': detailType,
      'token': id,
      'year': year,
      'status': cleanStatusStr,
      'approvalStatus': cleanStatusStr,
      'desc': description,
      'maksud_spt': description,
      'perihal': description,
      'location': location,
      'date': date,
      'parsedStartDate': _parseDate(rawStartDate),
      'parsedEndDate': _parseDate(rawEndDate),
    };
  }
}
