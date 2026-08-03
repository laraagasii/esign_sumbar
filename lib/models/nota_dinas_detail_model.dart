class NotaDinasDetailModel {
  final DetailResult result;
  final List<Pegawai> pegawai;
  final List<Lampiran> lampiran;
  final List<Tracking> tracking;

  NotaDinasDetailModel({
    required this.result,
    required this.pegawai,
    required this.lampiran,
    required this.tracking,
  });

  factory NotaDinasDetailModel.fromJson(Map<String, dynamic> json) {
    return NotaDinasDetailModel(
      result: DetailResult.fromJson(json['result'] ?? {}),
      pegawai: (json['pegawai'] as List<dynamic>?)
              ?.map((e) => Pegawai.fromJson(e))
              .toList() ??
          [],
      lampiran: (json['lampiran'] as List<dynamic>?)
              ?.map((e) => Lampiran.fromJson(e))
              .toList() ??
          [],
      tracking: (json['tracking'] as List<dynamic>?)
              ?.map((e) => Tracking.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DetailResult {
  final String idnota;
  final String kategori;
  final String opd;
  final String subOpd;
  final String nmOpd;
  final String tglnota;
  final String noNota;
  final String nmKategori;
  final String perihal;
  final String isiNota;
  final String signer;
  final String kepada;
  final String melaluiSatu;
  final String melaluiDua;
  final String dari;
  final String haveTte;
  final String statusAcc;

  DetailResult({
    required this.idnota,
    required this.kategori,
    required this.opd,
    required this.subOpd,
    required this.nmOpd,
    required this.tglnota,
    required this.noNota,
    required this.nmKategori,
    required this.perihal,
    required this.isiNota,
    required this.signer,
    required this.kepada,
    required this.melaluiSatu,
    required this.melaluiDua,
    required this.dari,
    required this.haveTte,
    required this.statusAcc,
  });

  factory DetailResult.fromJson(Map<String, dynamic> json) {
    return DetailResult(
      idnota: json['idnota'] ?? '',
      kategori: json['kategori'] ?? '',
      opd: json['opd'] ?? '',
      subOpd: json['sub_opd'] ?? '',
      nmOpd: json['nm_opd'] ?? '',
      tglnota: json['tglnota'] ?? '',
      noNota: json['no_nota'] ?? '',
      nmKategori: json['nm_kategori'] ?? '',
      perihal: json['perihal'] ?? '',
      isiNota: json['isi_nota'] ?? '',
      signer: json['signer'] ?? '',
      kepada: json['kepada'] ?? '',
      melaluiSatu: json['melalui_satu'] ?? '',
      melaluiDua: json['melalui_dua'] ?? '',
      dari: json['dari'] ?? '',
      haveTte: json['have_tte'] ?? '',
      statusAcc: json['status_acc'] ?? '',
    );
  }
}

class Pegawai {
  final String idAsn;
  final String namaAsn;
  final String nipAsn;
  final String pangkat;
  final String eselon;
  final String instansi;
  final String jabatan;
  final String tujuan;
  final String tgldinas;
  final String blnhari;

  Pegawai({
    required this.idAsn,
    required this.namaAsn,
    required this.nipAsn,
    required this.pangkat,
    required this.eselon,
    required this.instansi,
    required this.jabatan,
    required this.tujuan,
    required this.tgldinas,
    required this.blnhari,
  });

  factory Pegawai.fromJson(Map<String, dynamic> json) {
    return Pegawai(
      idAsn: json['id_asn'] ?? '',
      namaAsn: json['nama_asn'] ?? '',
      nipAsn: json['nip_asn'] ?? '',
      pangkat: json['pangkat'] ?? '',
      eselon: json['eselon'] ?? '',
      instansi: json['instansi'] ?? '',
      jabatan: json['jabatan'] ?? '',
      tujuan: json['tujuan'] ?? '',
      tgldinas: json['tgldinas'] ?? '',
      blnhari: json['blnhari'] ?? '',
    );
  }
}

class Lampiran {
  final String namaFile;
  final String sizeFile;
  final String urlFile;

  Lampiran({
    required this.namaFile,
    required this.sizeFile,
    required this.urlFile,
  });

  factory Lampiran.fromJson(Map<String, dynamic> json) {
    return Lampiran(
      namaFile: json['nama_file'] ?? '',
      sizeFile: json['size_file'] ?? '',
      urlFile: json['url_file'] ?? '',
    );
  }
}

class Tracking {
  final String teruskan;
  final String jabatan;
  final String tanggal;
  final String status;
  final String tindakan;
  final String catatan;

  Tracking({
    required this.teruskan,
    required this.jabatan,
    required this.tanggal,
    required this.status,
    required this.tindakan,
    required this.catatan,
  });

  factory Tracking.fromJson(Map<String, dynamic> json) {
    return Tracking(
      teruskan: json['teruskan'] ?? '',
      jabatan: json['jabatan'] ?? '',
      tanggal: json['tanggal'] ?? '',
      status: json['status'] ?? '',
      tindakan: json['tindakan'] ?? '',
      catatan: json['catatan'] ?? '',
    );
  }
}
