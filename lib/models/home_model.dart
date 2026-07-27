class HomeData {
  final Rekap rekap;
  final List<Aktifitas> aktifitas;

  HomeData({required this.rekap, required this.aktifitas});

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      // Memetakan objek 'rekap'
      rekap: Rekap.fromJson(json['rekap'] ?? {}),
      // Memetakan array 'aktifitas' menjadi list of Aktifitas
      aktifitas: (json['aktifitas'] as List)
          .map((item) => Aktifitas.fromJson(item))
          .toList(),
    );
  }
}

class Rekap {
  final String jumlah;
  final String nodin;
  final String spt;

  Rekap({required this.jumlah, required this.nodin, required this.spt});

  factory Rekap.fromJson(Map<String, dynamic> json) {
    return Rekap(
      jumlah: json['jumlah'] ?? '0',
      nodin: json['nodin'] ?? '0',
      spt: json['spt'] ?? '0',
    );
  }
}

class Aktifitas {
  final String id;
  final String perihal;
  final String statusPemeriksaan;
  final String tanggal;

  Aktifitas({
    required this.id,
    required this.perihal,
    required this.statusPemeriksaan,
    required this.tanggal,
  });

  factory Aktifitas.fromJson(Map<String, dynamic> json) {
    return Aktifitas(
      id: json['id'] ?? '',
      perihal: json['perihal'] ?? '',
      statusPemeriksaan: json['status_pemeriksaan'] ?? '',
      tanggal: json['tanggal'] ?? '',
    );
  }
}