import 'package:flutter_test/flutter_test.dart';
import 'package:proyek_esign/models/spt_model.dart';

void main() {
  group('SptModel', () {
    test('maps API payload fields into display-friendly values', () {
      final model = SptModel.fromJson({
        'id': '123',
        'perihal': 'Rapat koordinasi',
        'opd': 'ABC',
        'nmopd': 'Dinas Komunikasi',
        'tanggal': '2026-08-05',
        'lokasi': 'Padang',
        'status': 'NEW',
        'nmstatus': 'Belum Diperiksa',
      });

      expect(model.id, '123');
      expect(model.title, 'Dinas Komunikasi');
      expect(model.description, 'Rapat koordinasi');
      expect(model.location, 'Padang');
      expect(model.date, '2026-08-05');
      expect(model.status, 'NEW');
      expect(model.statusLabel, 'Belum Diperiksa');
    });
  });
}
