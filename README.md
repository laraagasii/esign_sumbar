# Proyek eSign

Aplikasi mobile berbasis **Flutter** untuk sistem Tanda Tangan Elektronik (eSign), pengelolaan Surat Perintah Tugas (SPT), dan persetujuan Nota Dinas. Aplikasi ini memfasilitasi alur kerja persetujuan dokumen antara pegawai dan pejabat dengan antarmuka yang modern dan responsif.

## Fitur Utama

- **Dashboard Analitik**: Menampilkan ringkasan data statistik SPT dan Nota Dinas menggunakan grafik interaktif (menggunakan `fl_chart`).
- **Manajemen Dokumen**:
  - Daftar & Detail Surat Perintah Tugas (SPT).
  - Daftar & Detail Nota Dinas.
- **Persetujuan Berbasis Peran (Role-based)**:
  - Alur persetujuan yang disesuaikan untuk peran pengguna (misal: Pejabat vs. Pegawai biasa).
  - Fitur tolak atau setujui dokumen dengan catatan.
- **Riwayat Dokumen**: Melacak status dokumen yang telah diproses.
- **Autentikasi**: Sistem login aman dan manajemen sesi pengguna.

## Teknologi & Library

Proyek ini dibangun menggunakan Flutter SDK dan beberapa dependensi utama:

- **State Management**: [`provider`](https://pub.dev/packages/provider)
- **Networking**: [`http`](https://pub.dev/packages/http) untuk komunikasi dengan REST API backend.
- **Data Visualization**: [`fl_chart`](https://pub.dev/packages/fl_chart) untuk grafik analitik di Dashboard.
- **Local Storage**: [`shared_preferences`](https://pub.dev/packages/shared_preferences) untuk menyimpan data sesi token/user lokal.
- **UI & Styling**: 
  - [`google_fonts`](https://pub.dev/packages/google_fonts) (Font Inter)
  - [`flutter_svg`](https://pub.dev/packages/flutter_svg) untuk merender aset vektor SVG.

## Persyaratan Sistem

- Flutter SDK: `>=3.9.2`
- Dart SDK: `>=3.0.0`

## Cara Menjalankan Proyek

1. **Clone repository ini**
   ```bash
   git clone <url-repo-github>
   cd proyek_esign
   ```

2. **Install semua dependensi**
   Jalankan perintah berikut untuk mengunduh semua package yang dibutuhkan:
   ```bash
   flutter pub get
   ```

3. **Jalankan Aplikasi**
   Pastikan Anda memiliki perangkat (fisik atau emulator/simulator) yang terhubung.
   ```bash
   flutter run
   ```

## Struktur Folder Utama

Berikut adalah ringkasan struktur folder utama di dalam `lib/`:

```text
lib/
├── models/       # Model data (blueprint objek)
├── providers/    # State management untuk mengatur state global (contoh: AuthProvider, HomeProvider)
├── screens/      # Halaman/UI dari aplikasi (Dashboard, Login, Daftar SPT, dll)
├── services/     # Layanan API (komunikasi HTTP ke server backend)
├── widgets/      # Komponen UI yang dapat digunakan kembali (Dialog, Card, Button kustom)
└── main.dart     # Titik masuk (entry point) aplikasi
```

## Catatan Tambahan

- Pastikan untuk memperbarui konfigurasi URL API endpoint di dalam folder `services/` sesuai dengan environment server backend yang digunakan (Development/Production).
