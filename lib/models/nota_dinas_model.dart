class NotaDinasModel {
  final String idnota;
  final String opd;
  final String nmopd;
  final String tahun;
  final String bulan;
  final String tglnota;
  final String numnota;
  final String kategori;
  final String nmkategori;
  final String perihal;
  final String status;
  final String nmstatus;
  final String tindakan;
  final String nmtindakan;

  NotaDinasModel({
    required this.idnota,
    required this.opd,
    required this.nmopd,
    required this.tahun,
    required this.bulan,
    required this.tglnota,
    required this.numnota,
    required this.kategori,
    required this.nmkategori,
    required this.perihal,
    required this.status,
    required this.nmstatus,
    required this.tindakan,
    required this.nmtindakan,
  });

  factory NotaDinasModel.fromJson(Map<String, dynamic> json) {
    return NotaDinasModel(
      idnota: json['idnota'] ?? '',
      opd: json['opd'] ?? '',
      nmopd: json['nmopd'] ?? '',
      tahun: json['tahun'] ?? '',
      bulan: json['bulan'] ?? '',
      tglnota: json['tglnota'] ?? '',
      numnota: json['numnota'] ?? '',
      kategori: json['kategori'] ?? '',
      nmkategori: json['nmkategori'] ?? '',
      perihal: json['perihal'] ?? '',
      status: json['status'] ?? '',
      nmstatus: json['nmstatus'] ?? '',
      tindakan: json['tindakan'] ?? '',
      nmtindakan: json['nmtindakan'] ?? '',
    );
  }
}
