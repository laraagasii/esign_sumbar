import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/pin_signature_dialog.dart';
import '../widgets/rejection_dialog.dart';
import '../widgets/approval_dialog.dart';
import 'package:provider/provider.dart';
import '../models/nota_dinas_model.dart';
import '../models/nota_dinas_detail_model.dart';
import '../providers/nota_dinas_provider.dart';

class DetailNotaDinasScreen extends StatefulWidget {
  final NotaDinasModel notaDinas;
  final String userId;
  final String groupId;
  final bool isRiwayat;

  const DetailNotaDinasScreen({
    super.key,
    required this.notaDinas,
    required this.userId,
    required this.groupId,
    this.isRiwayat = false,
  });

  @override
  State<DetailNotaDinasScreen> createState() => _DetailNotaDinasScreenState();
}

class _DetailNotaDinasScreenState extends State<DetailNotaDinasScreen> {
  bool _isAllSelected = false;

  // Controller untuk Password/PIN dan Catatan
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  // Dummy PIN Sekretaris
  final String _dummyPin = "123456";

  List<Map<String, dynamic>> _pengikutList = [];
  List<Map<String, dynamic>> _batalList = [];
  late final List<Map<String, dynamic>> _riwayatList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<NotaDinasProvider>().fetchNotaDinasDetail(
        widget.userId,
        widget.notaDinas.tahun,
        widget.groupId,
        widget.notaDinas.kategori,
        widget.notaDinas.idnota,
      );

      if (!mounted) return;
      final prov = context.read<NotaDinasProvider>();
      final detail = prov.notaDinasDetail;

      if (detail != null) {
        setState(() {
          _pengikutList = detail.pegawai
              .map(
                (p) => {
                  "name": p.namaAsn,
                  "nip": p.nipAsn,
                  "role": p.jabatan,
                  "badge": "Jumlah perjadin: ${p.blnhari}",
                  "selected": false,
                },
              )
              .toList();

          _batalList = detail.asnbatal
              .map(
                (p) => {
                  "name": p.namaAsn,
                  "nip": p.nipAsn,
                  "role": p.jabatan,
                  "badge": "Jumlah perjadin: ${p.blnhari}",
                },
              )
              .toList();
        });
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<NotaDinasProvider>();
    final detail = prov.notaDinasDetail;
    final isLoading = prov.isDetailLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 260,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF132F53), Color(0xFF5A84AB)],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          "Detail Nota Dinas",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 25,
                          spreadRadius: 0,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : (detail == null)
                        ? Center(
                            child: Text(
                              prov.detailErrorMessage ?? "Gagal memuat detail",
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildTopTag(
                                      detail.result.nmKategori,
                                      const Color(0xFFD3FBD4),
                                      const Color(0xFF125B2A),
                                    ),
                                    const SizedBox(width: 12),
                                    _buildTopTag(
                                      detail.result.tglnota,
                                      const Color(0xFFFEF9C3),
                                      const Color(0xFFD4A72C),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                _buildDetailInformasiCard(detail),
                                const SizedBox(height: 24),
                                _buildPengikutCard(),
                                if (widget.isRiwayat) ...[
                                  const SizedBox(height: 24),
                                  _buildDibatalkanCard(),
                                ],
                                const SizedBox(height: 24),
                                _buildLampiranCard(detail),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      _showRiwayatPemeriksaan(context, detail);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      "Lihat Riwayat Pemeriksaan",
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF132F53),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                if (!widget.isRiwayat) ...[
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _handleApprove();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFFD3FBD4,
                                            ),
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Text(
                                            "Setujui",
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF125B2A),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _handleReject();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFFFFEBEE,
                                            ),
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Text(
                                            "Tolak",
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFFE53935),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailInformasiCard(NotaDinasDetailModel detail) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Detail Informasi",
              style: GoogleFonts.inter(
                color: const Color(0xFF132F53),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow("Pemohon", detail.result.dari),
          _buildInfoRow("Unit Kerja", detail.result.nmOpd),
          _buildInfoRow(
            "Tujuan",
            detail.pegawai.isNotEmpty ? detail.pegawai.first.tujuan : "-",
          ),
          _buildInfoRow(
            "Tanggal Pelaksanaan",
            detail.pegawai.isNotEmpty ? detail.pegawai.first.tgldinas : "-",
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(color: Color(0xFFE5E7EB)),
          ),
          Text(
            "Perihal:",
            style: GoogleFonts.inter(
              color: Colors.grey.shade500,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            detail.result.perihal,
            style: GoogleFonts.inter(
              color: const Color(0xFF132F53),
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: InkWell(
              onTap: () => _showIsiSuratDialog(context, detail.result.isiNota),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Isi Surat",
                  style: GoogleFonts.inter(
                    color: const Color(0xFF132F53),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showIsiSuratDialog(BuildContext context, String htmlContent) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Isi Surat",
            style: GoogleFonts.inter(
              color: const Color(0xFF132F53),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Html(
                data: htmlContent,
                style: {
                  "body": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    fontFamily: 'Inter',
                    color: const Color(0xFF132F53),
                  ),
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Tutup",
                style: GoogleFonts.inter(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPdfDialog(BuildContext context, String url, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF132F53),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.7,
            child: SfPdfViewer.network(
              url,
              canShowScrollHead: false,
              canShowScrollStatus: false,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Tutup",
                style: GoogleFonts.inter(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                color: const Color(0xFF132F53),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, Color> _getPerjadinBadgeColors(String badgeText) {
    final regExp = RegExp(r'\d+');
    final match = regExp.firstMatch(badgeText);
    int count = match != null ? int.parse(match.group(0)!) : 0;

    if (count >= 6) {
      return {'bg': const Color(0xFFFFEBEE), 'text': const Color(0xFFE53935)};
    } else if (count >= 4) {
      return {'bg': const Color(0xFFFEF9C3), 'text': const Color(0xFFD4A72C)};
    } else {
      return {'bg': const Color(0xFFE3F2FD), 'text': const Color(0xFF1976D2)};
    }
  }

  Widget _buildPengikutCard() {
    int totalTerpilih = _pengikutList
        .where((e) => e["selected"] == true)
        .length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Pengikut (${_pengikutList.length})",
              style: GoogleFonts.inter(
                color: const Color(0xFF132F53),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!widget.isRiwayat) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _isAllSelected,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        activeColor: const Color(0xFF125B2A),
                        onChanged: (val) {
                          setState(() {
                            _isAllSelected = val ?? false;
                            for (var item in _pengikutList) {
                              item["selected"] = _isAllSelected;
                            }
                          });
                        },
                      ),
                      Text(
                        "Pilih Semua",
                        style: GoogleFonts.inter(
                          color: const Color(0xFF132F53),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "$totalTerpilih Terpilih",
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _pengikutList.length,
            itemBuilder: (context, index) {
              final pengikut = _pengikutList[index];
              final colors = _getPerjadinBadgeColors(pengikut["badge"]);

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: widget.isRiwayat
                      ? const Color(0xFFFEF9C3)
                      : Colors.white,
                  border: Border.all(
                    color: widget.isRiwayat
                        ? const Color(0xFFFEF08A)
                        : Colors.grey.shade200,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    if (!widget.isRiwayat) ...[
                      Checkbox(
                        value: pengikut['selected'],
                        activeColor: const Color(0xFF125B2A),
                        onChanged: (bool? newValue) {
                          setState(() {
                            pengikut['selected'] = newValue ?? false;
                            _isAllSelected = _pengikutList.every(
                              (e) => e['selected'] == true,
                            );
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (widget.isRiwayat) ...[
                      const Icon(
                        Icons.person_outline,
                        color: Color(0xFFCA8A04),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pengikut["name"],
                            style: GoogleFonts.inter(
                              color: widget.isRiwayat
                                  ? const Color(0xFF854D0E)
                                  : const Color(0xFF132F53),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          if (widget.isRiwayat &&
                              pengikut["nip"] != null &&
                              pengikut["nip"].toString().isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              pengikut["nip"],
                              style: GoogleFonts.inter(
                                color: const Color(0xFFA16207),
                                fontSize: 11,
                              ),
                            ),
                          ],
                          const SizedBox(height: 2),
                          Text(
                            pengikut["role"],
                            style: GoogleFonts.inter(
                              color: widget.isRiwayat
                                  ? const Color(0xFFA16207)
                                  : Colors.grey.shade500,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (!widget.isRiwayat) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colors['bg'],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                pengikut["badge"],
                                style: GoogleFonts.inter(
                                  color: colors['text'],
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDibatalkanCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Dibatalkan (${_batalList.length})",
              style: GoogleFonts.inter(
                color: const Color(0xFF132F53),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_batalList.isEmpty)
            Center(
              child: Text(
                "Tidak ada pengikut yang dibatalkan",
                style: GoogleFonts.inter(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _batalList.length,
              itemBuilder: (context, index) {
                final pengikut = _batalList[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    border: Border.all(color: const Color(0xFFFECACA)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        color: Color(0xFFDC2626),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pengikut["name"],
                              style: GoogleFonts.inter(
                                color: const Color(0xFF991B1B),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            if (pengikut["nip"] != null &&
                                pengikut["nip"].toString().isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                pengikut["nip"],
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFB91C1C),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                            const SizedBox(height: 2),
                            Text(
                              pengikut["role"],
                              style: GoogleFonts.inter(
                                color: const Color(0xFFB91C1C),
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildLampiranCard(NotaDinasDetailModel detail) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Lampiran (${detail.lampiran.length})",
              style: GoogleFonts.inter(
                color: const Color(0xFF132F53),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          if (detail.lampiran.isNotEmpty) const SizedBox(height: 12),
          ...detail.lampiran.map(
            (file) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InkWell(
                onTap: () async {
                  String urlString = file.urlFile;
                  if (urlString.toLowerCase().endsWith('.pdf')) {
                    _showPdfDialog(context, urlString, "Pratinjau Dokumen");
                  } else {
                    final Uri url = Uri.parse(urlString);
                    if (!await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    )) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gagal membuka tautan dokumen.'),
                          ),
                        );
                      }
                    }
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          file.namaFile,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF132F53),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.visibility,
                        size: 18,
                        color: Color(0xFF132F53),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRiwayatPemeriksaan(
    BuildContext context,
    NotaDinasDetailModel detail,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.67,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Riwayat Pemeriksaan",
                          style: GoogleFonts.inter(
                            color: const Color(0xFF132F53),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFF132F53),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      itemCount: detail.tracking.length,
                      itemBuilder: (context, index) {
                        final item = detail.tracking[index];
                        final bool hasNext = index < detail.tracking.length - 1;

                        // Customize logic based on item.status or other logic.
                        IconData icon = Icons.check;
                        Color iconBg = const Color(0xFFD3FBD4);
                        Color iconColor = const Color(0xFF125B2A);
                        Color? actionColor;

                        String tindakanLower = (item.tindakan ?? "").toLowerCase();

                        String statusText = item.status.isNotEmpty
                            ? item.status
                            : "Disetujui";
                        Color statusBg = const Color(0xFFD3FBD4);
                        Color statusColor = const Color(0xFF125B2A);

                        if (tindakanLower.isEmpty) {
                          icon = Icons.access_time;
                          iconBg = const Color(0xFFFEF9C3);
                          iconColor = const Color(0xFFD4A72C);
                          actionColor = const Color(0xFFD4A72C);
                          statusBg = const Color(0xFFFEF9C3);
                          statusColor = const Color(0xFFD4A72C);
                        } else if (tindakanLower.contains("tidak disetujui") || tindakanLower.contains("tolak")) {
                          icon = Icons.close;
                          iconBg = const Color(0xFFFFEBEE);
                          iconColor = const Color(0xFFE53935);
                          actionColor = const Color(0xFFE53935);
                          statusBg = const Color(0xFFFFEBEE);
                          statusColor = const Color(0xFFE53935);
                        } else {
                          icon = Icons.check;
                          iconBg = const Color(0xFFD3FBD4);
                          iconColor = const Color(0xFF125B2A);
                          actionColor = const Color(0xFF125B2A);
                        }

                        return _buildRiwayatItem(
                          icon: icon,
                          iconBg: iconBg,
                          iconColor: iconColor,
                          title: item.jabatan,
                          description: item.teruskan,
                          time: null, 
                          actionLabel: item.tindakan,
                          actionColor: actionColor,
                          statusText: statusText, 
                          statusBg: statusBg,
                          statusColor: statusColor,
                          catatan: item.catatan,
                          showTimelineLine: hasNext,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRiwayatItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    String? description,
    String? time,
    String? actionLabel,
    Color? actionColor,
    String? statusText,
    Color? statusBg,
    Color? statusColor,
    String? catatan,
    required bool showTimelineLine,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            if (showTimelineLine)
              Container(
                width: 2,
                height: 105,
                color: const Color(0xFF828282).withOpacity(0.3),
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF132F53),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
                if (time != null && time.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
                if (actionLabel != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    actionLabel,
                    style: GoogleFonts.inter(
                      color: actionColor ?? const Color(0xFFD4A72C),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  "Catatan:",
                  style: GoogleFonts.inter(
                    color: const Color(0xFF132F53),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  (catatan == null || catatan.isEmpty || catatan == "-")
                      ? "Belum ada catatan"
                      : catatan,
                  style: GoogleFonts.inter(
                    color: (catatan == null || catatan.isEmpty || catatan == "-")
                        ? Colors.grey.shade500
                        : Colors.black87,
                    fontStyle: (catatan == null || catatan.isEmpty || catatan == "-")
                        ? FontStyle.italic
                        : FontStyle.normal,
                    fontSize: 12,
                  ),
                ),
                if (statusText != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: GoogleFonts.inter(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleApprove() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ApprovalDialog(
          onSubmit: (notes) {
            Navigator.pop(dialogContext); // Tutup dialog catatan
            // Setelah input catatan, tampilkan dialog PIN
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (pinContext) {
                return PinSignatureDialog(
                  onSubmit: (pin) {
                    if (pin != _dummyPin) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("PIN salah! Gunakan: 123456"),
                          backgroundColor: Color(0xFFE53935),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                    Navigator.pop(pinContext); // Tutup dialog PIN
                    _processAction(isApprove: true, catatan: notes);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void _handleReject() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return RejectionDialog(
          onSubmit: (notes) {
            Navigator.pop(dialogContext); // Tutup dialog penolakan
            _processAction(isApprove: false, catatan: notes);
          },
        );
      },
    );
  }

  void _processAction({
    required bool isApprove,
    required String catatan,
  }) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(
      const Duration(seconds: 1),
    ); // Mock proses penandatanganan
    if (!mounted) return;
    Navigator.pop(context); // Tutup loading

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isApprove
              ? "Dokumen berhasil ditandatangani secara elektronik"
              : "Dokumen berhasil ditolak",
        ),
        backgroundColor: isApprove
            ? const Color(0xFF2E7D32)
            : const Color(0xFFC62828),
      ),
    );

    List<Map<String, dynamic>> pengikutTerpilih = _pengikutList
        .where((p) => p["selected"] == true)
        .toList();

    List<Map<String, dynamic>> pengikutDibatalkan = _pengikutList
        .where((p) => p["selected"] == false)
        .toList();

    DateTime now = DateTime.now();
    String formattedDate =
        "${_getDayName(now.weekday)}, ${now.day.toString().padLeft(2, '0')} Agustus ${_formatYear(now)} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    Map<String, dynamic> riwayatSekretarisBaru = {
      "icon": isApprove ? Icons.check : Icons.close_rounded,
      "iconBg": isApprove ? const Color(0xFFD3FBD4) : const Color(0xFFFFEBEE),
      "iconColor": isApprove
          ? const Color(0xFF125B2A)
          : const Color(0xFFE53935),
      "title": "Sekretaris (Anda)",
      "description": "Catatan: $catatan",
      "time": formattedDate,
      "actionLabel": "Tahap: Pemeriksaan Sekretaris",
      "actionColor": isApprove
          ? const Color(0xFF125B2A)
          : const Color(0xFFE53935),
      "statusText": isApprove ? "Disetujui" : "Ditolak",
      "statusBg": isApprove ? const Color(0xFFD3FBD4) : const Color(0xFFFFEBEE),
      "statusColor": isApprove
          ? const Color(0xFF125B2A)
          : const Color(0xFFE53935),
    };

    setState(() {
      _riwayatList[1] =
          riwayatSekretarisBaru; // Update indeks ke-1 (Sekretaris)
    });

    Navigator.pop(context, {
      'status': isApprove ? 'Disetujui' : 'Ditolak',
      'note': catatan,
      'pengikutTerpilih': pengikutTerpilih,
      'pengikutDibatalkan': pengikutDibatalkan,
      'riwayatBaru': riwayatSekretarisBaru,
    });
  }

  String _getDayName(int weekday) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[weekday - 1];
  }

  String _formatYear(DateTime date) {
    return date.year.toString();
  }
}
