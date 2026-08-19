import requests
import pandas as pd
from datetime import datetime
from sklearn.ensemble import RandomForestRegressor
import pickle
import os

# Base URL API e-Sign Sumbar
BASE_URL = "https://espj.sumbarprov.go.id/sumbarapis/spj"

# Daftar kredensial pejabat lengkap berdasarkan data login.json kamu
LIST_PEJABAT = [
    {
        "nama": "Surya Agung Putra (Staff)",
        "id": "1a2394378ddbb186f6f622e8b3c872ee6872623f",
        "group": "1"
    },
    {
        "nama": "Ibnu (PPTK)",
        "id": "54a8b8362ebcb16af08c8acf33a2d8d5f335cf5e",
        "group": "1"
    },
    {
        "nama": "Tedi Rafdianto (Kabid)",
        "id": "ae914d89870f2450ca4c6ca9f34e3080317546e5",
        "group": "3"
    },
    {
        "nama": "Gugun Herlambang (Asekda)",
        "id": "8018dcd81ff171aa9629c08d95422c20e45e307b",
        "group": "5"
    },
    {
        "nama": "Andi Setiawan (Sekda)",
        "id": "a4adb04d8392abc79d52ea247fabd8348b97a78a",
        "group": "6"
    }
]

def parse_indo_datetime(date_str):
    """Mengubah format tanggal string Indonesia (misal: 'Jumat, 14 Agustus 2026 16:30:17' atau 'Diperiksa : Kamis, 13 Agustus 2026 14:00:00') menjadi datetime"""
    try:
        # Bersihkan teks jika mengandung prefix seperti "Diperiksa : " atau "Diteruskan : "
        if ":" in date_str and "10 Agustus" in date_str or "Agustus" in date_str or "Januari" in date_str:
            # Ambil bagian setelah " : " jika ada
            if " : " in date_str:
                date_str = date_str.split(" : ")[1]

        parts = date_str.split(', ')
        if len(parts) < 2: return None
        time_parts = parts[1].split(' ')
        if len(time_parts) < 4: return None
        
        day = time_parts[0]
        month_str = time_parts[1].lower()
        year = time_parts[2]
        time = time_parts[3]

        months = {
            'januari': '01', 'februari': '02', 'maret': '03', 'april': '04',
            'mei': '05', 'juni': '06', 'juli': '07', 'agustus': '08',
            'september': '09', 'oktober': '10', 'november': '11', 'desember': '12'
        }
        month = months.get(month_str, '01')
        return datetime.strptime(f"{year}-{month}-{day.zfill(2)} {time}", "%Y-%m-%d %H:%M:%S")
    except:
        return None

def parse_indo_date_only(date_str):
    """Mengubah format tanggal seperti '10 Agustus 2026' menjadi objek datetime"""
    try:
        parts = date_str.split(' ')
        if len(parts) < 3: return None
        day = parts[0]
        month_str = parts[1].lower()
        year = parts[2]
        
        months = {
            'januari': '01', 'februari': '02', 'maret': '03', 'april': '04',
            'mei': '05', 'juni': '06', 'juli': '07', 'agustus': '08',
            'september': '09', 'oktober': '10', 'november': '11', 'desember': '12'
        }
        month = months.get(month_str, '01')
        return datetime.strptime(f"{year}-{month}-{day.zfill(2)}", "%Y-%m-%d")
    except:
        return None

def extract_and_transform_data():
    dataset_rows = []

    print("Memulai pengambilan data riwayat asli dari API e-Sign...")

    for pejabat in LIST_PEJABAT:
        pid = pejabat["id"]
        group = pejabat["group"]
        nama_pejabat = pejabat["nama"]

        print(f"Merayapi data untuk: {nama_pejabat}...")

        # --- 1. AMBIL DATA NOTA DINAS (STATUS MSB = Sudah Diproses) ---
        nodin_list_url = f"{BASE_URL}/nota-dinas/list/id/{pid}/group/{group}/status/MSB"
        try:
            response = requests.get(nodin_list_url)
            if response.status_code == 200:
                result_json = response.json()
                nodin_items = result_json.get('result', [])
                
                for item in nodin_items:
                    idnota = item.get('idnota')
                    tahun = item.get('tahun')
                    tipe_pd = item.get('kategori')
                    tgl_nota_str = item.get('tglnota')
                    
                    if not tgl_nota_str or not idnota: continue
                    tgl_submit = parse_indo_date_only(tgl_nota_str)
                    if not tgl_submit: continue

                    detail_url = f"{BASE_URL}/nota-dinas/detail/id/{pid}/tahun/{tahun}/group/{group}/tipe/{tipe_pd}/token/{idnota}"
                    detail_res = requests.get(detail_url)
                    
                    if detail_res.status_code == 200:
                        detail_data = detail_res.json()
                        tracking = detail_data.get('tracking', [])
                        pegawai_list = detail_data.get('pegawai', [])
                        total_pengikut = len(pegawai_list) if len(pegawai_list) > 0 else 1

                        if tracking:
                            waktu_selesai_str = tracking[0].get('tanggal', '')
                            waktu_selesai = parse_indo_datetime(waktu_selesai_str)

                            if waktu_selesai:
                                durasi_jam = (waktu_selesai - tgl_submit).total_seconds() / 3600
                                if durasi_jam > 0:
                                    kat_map = {'DK': 0, 'DD': 1, 'DL': 2}
                                    dataset_rows.append({
                                        'tipe_dokumen': 0, # Nota Dinas
                                        'kategori': kat_map.get(tipe_pd, 1),
                                        'jumlah_pengikut': total_pengikut,
                                        'durasi_jam': durasi_jam
                                    })
        except Exception as e:
            print(f"Gagal mengambil Nota Dinas untuk {nama_pejabat}: {e}")

        # --- 2. AMBIL DATA SPT (SURAT TUGAS) ---
        spt_list_url = f"{BASE_URL}/surat-tugas/list/id/{pid}"
        try:
            response = requests.get(spt_list_url)
            if response.status_code == 200:
                result_json = response.json()
                spt_items = result_json.get('result', [])

                for item in spt_items:
                    if item.get('status') == 'AP': # Surat Tugas Disetujui
                        idspt = item.get('idspt') or item.get('sptid')
                        tahun = item.get('tahun')
                        tipe_pd = item.get('kategori')
                        tgl_spt_str = item.get('tgl_spt') # Menggunakan 'tgl_spt' sesuai JSON detail
                        
                        if not tgl_spt_str or not idspt: continue
                        tgl_submit = parse_indo_date_only(tgl_spt_str)
                        if not tgl_submit: continue

                        detail_url = f"{BASE_URL}/surat-tugas/detail/id/{pid}/tahun/{tahun}/tipe/{tipe_pd}/token/{idspt}"
                        detail_res = requests.get(detail_url)

                        if detail_res.status_code == 200:
                            detail_data = detail_res.json()
                            
                            # SPT menggunakan key 'riwayat', bukan 'tracking'
                            riwayat = detail_data.get('riwayat', [])
                            pegawai_list = detail_data.get('pegawai', [])
                            total_pengikut = len(pegawai_list) if len(pegawai_list) > 0 else 1

                            if riwayat:
                                # Ambil waktu selesai dari field 'status' (misal: "Diperiksa : Kamis, 13 Agustus 2026 14:00:00") atau 'tanggal'
                                status_teks = riwayat[0].get('status', '')
                                waktu_selesai_str = status_teks if "Diperiksa" in status_teks else riwayat[0].get('tanggal', '')
                                waktu_selesai = parse_indo_datetime(waktu_selesai_str)

                                if waktu_selesai:
                                    durasi_jam = (waktu_selesai - tgl_submit).total_seconds() / 3600
                                    if durasi_jam > 0:
                                        kat_map = {'DK': 0, 'DD': 1, 'DL': 2}
                                        dataset_rows.append({
                                            'tipe_dokumen': 1, # SPT
                                            'kategori': kat_map.get(tipe_pd, 1),
                                            'jumlah_pengikut': total_pengikut,
                                            'durasi_jam': durasi_jam
                                        })
        except Exception as e:
            print(f"Gagal mengambil SPT untuk {nama_pejabat}: {e}")

    df = pd.DataFrame(dataset_rows)
    if df.empty:
        print("PERINGATAN: Tidak ada data riwayat yang berhasil ditarik. Pastikan koneksi atau parameter endpoint valid.")
        return False

    df.to_csv('real_api_training_data.csv', index=False)
    print(f"Berhasil mengekstrak {len(df)} baris data riwayat asli ke 'real_api_training_data.csv'.")
    return True

def train_model():
    if not os.path.exists('real_api_training_data.csv'):
        print("File CSV pelatihan tidak ditemukan.")
        return

    df = pd.read_csv('real_api_training_data.csv')
    
    X = df[['tipe_dokumen', 'jumlah_pengikut', 'kategori']]
    y = df['durasi_jam']

    model = RandomForestRegressor(n_estimators=100, random_state=42)
    model.fit(X, y)

    with open('real_eta_model.pkl', 'wb') as f:
        pickle.dump(model, f)
    
    print("Model AI berhasil dilatih ulang menggunakan data riwayat asli dan disimpan sebagai 'real_eta_model.pkl'!")

if __name__ == "__main__":
    success = extract_and_transform_data()
    if success:
        train_model()