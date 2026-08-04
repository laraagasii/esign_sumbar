class UserModel {
  final String userId;
  final String pegawai;
  final String username;
  final String opd;
  final String nmOpd;
  final String subOpd;
  final String nmSubOpd;
  final String jabatan;
  final String nip;
  final String namaAsn;
  final String idEselon;
  final String eselon;
  final String pangkat;
  final String jenjang;
  final int group;
  final String kategori;

  UserModel({
    required this.userId,
    required this.pegawai,
    required this.username,
    required this.opd,
    required this.nmOpd,
    required this.subOpd,
    required this.nmSubOpd,
    required this.jabatan,
    required this.nip,
    required this.namaAsn,
    required this.idEselon,
    required this.eselon,
    required this.pangkat,
    required this.jenjang,
    required this.group,
    required this.kategori,
  });

  // Factory untuk memetakan key dari JSON menjadi tipe data Object di Dart
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId:
          json['userId']?.toString() ??
          json['user_id']?.toString() ??
          json['id']?.toString() ??
          json['pegawai']?.toString() ??
          '',
      pegawai: json['pegawai'] ?? '',
      username: json['username'] ?? '',
      opd: json['opd'] ?? '',
      nmOpd: json['nm_opd'] ?? '',
      subOpd: json['sub_opd'] ?? '',
      nmSubOpd: json['nm_sub_opd'] ?? '',
      jabatan: json['jabatan'] ?? '',
      nip: json['nip'] ?? '',
      namaAsn: json['nama_asn'] ?? '',
      idEselon: json['id_eselon'] ?? '',
      eselon: json['eselon'] ?? '',
      pangkat: json['pangkat'] ?? '',
      jenjang: json['jenjang'] ?? '',
      group: json['group'] ?? 0,
      kategori: json['kategori'] ?? '',
    );
  }

  // Fungsi untuk mengembalikan Object Dart ke bentuk JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'pegawai': pegawai,
      'username': username,
      'opd': opd,
      'nm_opd': nmOpd,
      'sub_opd': subOpd,
      'nm_sub_opd': nmSubOpd,
      'jabatan': jabatan,
      'nip': nip,
      'nama_asn': namaAsn,
      'id_eselon': idEselon,
      'eselon': eselon,
      'pangkat': pangkat,
      'jenjang': jenjang,
      'group': group,
      'kategori': kategori,
    };
  }

  // Cek apakah user adalah Pejabat (Bisa menyetujui dokumen)
  // Berdasarkan jenjang atau eselon yang tidak kosong (kecuali PELAKSANA)
  bool get isPejabat {
    return eselon.isNotEmpty ||
        jenjang == 'JPT' ||
        jenjang == 'ADMINISTRATOR' ||
        jenjang == 'PENGAWAS';
  }
}
