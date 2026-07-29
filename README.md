# eSign Project

*Read this in other languages: [English](#english), [Bahasa Indonesia](#bahasa-indonesia).*

---

## English

A **Flutter**-based mobile application for Electronic Signatures (eSign), Task Orders (Surat Perintah Tugas / SPT) management, and official memo (Nota Dinas) approval. This app facilitates document approval workflows between employees and officials with a modern and responsive interface.

### Key Features

- **Analytics Dashboard**: Displays a statistical summary of SPT and Nota Dinas data using interactive charts (powered by `fl_chart`).
- **Document Management**:
  - List & Detail for Task Orders (SPT).
  - List & Detail for Official Memos (Nota Dinas).
- **Role-based Approval**:
  - Tailored approval workflows based on user roles (e.g., Officials vs. Regular Employees).
  - Ability to approve or reject documents with notes.
- **Document History**: Track the status of processed documents.
- **Authentication**: Secure login system and user session management.

### Technologies & Libraries

This project is built using the Flutter SDK and several core dependencies:

- **State Management**: [`provider`](https://pub.dev/packages/provider)
- **Networking**: [`http`](https://pub.dev/packages/http) for communication with the backend REST API.
- **Data Visualization**: [`fl_chart`](https://pub.dev/packages/fl_chart) for analytical charts on the Dashboard.
- **Local Storage**: [`shared_preferences`](https://pub.dev/packages/shared_preferences) for storing local token/user session data.
- **UI & Styling**: 
  - [`google_fonts`](https://pub.dev/packages/google_fonts) (Inter Font)
  - [`flutter_svg`](https://pub.dev/packages/flutter_svg) for rendering SVG vector assets.

### System Requirements

- Flutter SDK: `>=3.9.2`
- Dart SDK: `>=3.0.0`

### How to Run the Project

1. **Clone this repository**
   ```bash
   git clone <url-repo-github>
   cd proyek_esign
   ```

2. **Install all dependencies**
   Run the following command to download all required packages:
   ```bash
   flutter pub get
   ```

3. **Run the Application**
   Ensure you have a device (physical or emulator/simulator) connected.
   ```bash
   flutter run
   ```

### Main Folder Structure

Here is a summary of the main folder structure inside `lib/`:

```text
lib/
├── models/       # Data models (object blueprints)
├── providers/    # State management to handle global state (e.g., AuthProvider, HomeProvider)
├── screens/      # Application screens/UI (Dashboard, Login, SPT List, etc.)
├── services/     # API services (HTTP communication to the backend server)
├── widgets/      # Reusable UI components (Dialogs, Cards, Custom Buttons)
└── main.dart     # Application entry point
```

### Additional Notes

- Make sure to update the API endpoint URL configuration inside the `services/` folder according to the backend server environment being used (Development/Production).

---

## Bahasa Indonesia

Aplikasi mobile berbasis **Flutter** untuk sistem Tanda Tangan Elektronik (eSign), pengelolaan Surat Perintah Tugas (SPT), dan persetujuan Nota Dinas. Aplikasi ini memfasilitasi alur kerja persetujuan dokumen antara pegawai dan pejabat dengan antarmuka yang modern dan responsif.

### Fitur Utama

- **Dashboard Analitik**: Menampilkan ringkasan data statistik SPT dan Nota Dinas menggunakan grafik interaktif (menggunakan `fl_chart`).
- **Manajemen Dokumen**:
  - Daftar & Detail Surat Perintah Tugas (SPT).
  - Daftar & Detail Nota Dinas.
- **Persetujuan Berbasis Peran (Role-based)**:
  - Alur persetujuan yang disesuaikan untuk peran pengguna (misal: Pejabat vs. Pegawai biasa).
  - Fitur tolak atau setujui dokumen dengan catatan.
- **Riwayat Dokumen**: Melacak status dokumen yang telah diproses.
- **Autentikasi**: Sistem login aman dan manajemen sesi pengguna.

### Teknologi & Library

Proyek ini dibangun menggunakan Flutter SDK dan beberapa dependensi utama:

- **State Management**: [`provider`](https://pub.dev/packages/provider)
- **Networking**: [`http`](https://pub.dev/packages/http) untuk komunikasi dengan REST API backend.
- **Data Visualization**: [`fl_chart`](https://pub.dev/packages/fl_chart) untuk grafik analitik di Dashboard.
- **Local Storage**: [`shared_preferences`](https://pub.dev/packages/shared_preferences) untuk menyimpan data sesi token/user lokal.
- **UI & Styling**: 
  - [`google_fonts`](https://pub.dev/packages/google_fonts) (Font Inter)
  - [`flutter_svg`](https://pub.dev/packages/flutter_svg) untuk merender aset vektor SVG.

### Persyaratan Sistem

- Flutter SDK: `>=3.9.2`
- Dart SDK: `>=3.0.0`

### Cara Menjalankan Proyek

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

### Struktur Folder Utama

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

### Catatan Tambahan

- Pastikan untuk memperbarui konfigurasi URL API endpoint di dalam folder `services/` sesuai dengan environment server backend yang digunakan (Development/Production).
