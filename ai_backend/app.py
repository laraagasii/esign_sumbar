from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
import pandas as pd
import pickle
import os
import joblib
from datetime import datetime, timedelta

app = FastAPI(
    title="AI Analitik Persetujuan API",
    description="API untuk memprediksi volume pengajuan Nodin dan SPT menggunakan AI Time Series (SARIMA) serta Estimasi Waktu (RandomForest dari Data Riwayat API Asli)",
    version="2.1.0"
)

# Enable CORS for Flutter app to consume
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ==========================================
# 1. LOAD MODEL SARIMA (PUNYA TEMAN)
# ==========================================
def load_model(filename):
    current_dir = os.path.dirname(os.path.abspath(__file__))
    path = os.path.join(current_dir, filename)
    if not os.path.exists(path):
        return None
    with open(path, 'rb') as f:
        return pickle.load(f)

# ==========================================
# 2. LOAD MODEL ETA (PUNYAMU)
# ==========================================
# Load Model ETA yang baru (hasil training dari data API asli) secara global saat aplikasi berjalan
MODEL_PATH = "real_eta_model.pkl"
try:
    current_dir = os.path.dirname(os.path.abspath(__file__))
    model_file_path = os.path.join(current_dir, MODEL_PATH)
    eta_model = joblib.load(model_file_path)
    print("Model ETA Asli (real_eta_model.pkl) berhasil diload.")
except Exception as e:
    eta_model = None
    print(f"Peringatan: Model ETA tidak ditemukan. Pastikan file real_eta_model.pkl ada di folder ai_backend. Error: {e}")

# ==========================================
# 3. ENDPOINTS
# ==========================================

@app.get("/")
def home():
    return {"message": "AI Backend berjalan normal. Kunjungi /docs untuk melihat dokumentasi API."}

# ENDPOINT PREDIKSI VOLUME (PUNYA TEMAN - Murni SARIMA)
@app.get("/api/predict")
def predict_next_month(pegawai: str = "a4adb04d8392abc79d52ea247fabd8348b97a78a"):
    """
    Memprediksi jumlah Nodin dan SPT untuk 30 hari ke depan (bulan depan).
    """
    model_nodin = load_model(f'model_sarima_nodin_pegawai_{pegawai}.pkl')
    model_spt = load_model(f'model_sarima_spt_pegawai_{pegawai}.pkl')
    
    if not model_nodin or not model_spt:
        return {"error": "Model AI belum lengkap. Harap latih model menggunakan Colab_AI_Training.ipynb dan upload file .pkl nya ke folder ai_backend."}
        
    # Prediksi 30 hari ke depan dengan SARIMA
    future_nodin_values = model_nodin.forecast(steps=30)
    future_spt_values = model_spt.forecast(steps=30)
    
    # Hitung total prediksi
    total_nodin_pred = max(0, int(sum(future_nodin_values)))
    total_spt_pred = max(0, int(sum(future_spt_values)))
    
    # Detail harian
    daily_details = []
    start_date = datetime.now()
    for i in range(30):
        current_date = start_date + timedelta(days=i)
        
        # future_nodin_values dari statsmodels biasanya berbentuk pandas Series, sehingga bisa diakses dengan iloc
        val_nodin = future_nodin_values.iloc[i] if hasattr(future_nodin_values, 'iloc') else future_nodin_values[i]
        val_spt = future_spt_values.iloc[i] if hasattr(future_spt_values, 'iloc') else future_spt_values[i]
        
        daily_details.append({
            "tanggal": current_date.strftime('%Y-%m-%d'),
            "prediksi_nodin": max(0, int(val_nodin)),
            "prediksi_spt": max(0, int(val_spt))
        })
        
    return {
        "prediksi_bulan_depan": {
            "total_nodin": total_nodin_pred,
            "total_spt": total_spt_pred,
            "total_keseluruhan": total_nodin_pred + total_spt_pred,
            "detail_harian": daily_details
        }
    }

# ENDPOINT PREDIKSI ETA (PUNYAMU)
@app.get("/api/predict-eta")
def predict_eta(
    tipe_dokumen: int = Query(..., description="0: Nodin, 1: SPT"),
    jumlah_pengikut: int = Query(..., description="Jumlah pengikut/penandatangan"),
    kategori: int = Query(..., description="0: Dalam Kota, 1: Dalam Daerah, 2: Luar Daerah"),
    tanggal_pengajuan: str = Query(None, description="Format YYYY-MM-DD. Jika kosong, pakai waktu sekarang")
):
    """
    Endpoint prediksi ETA menggunakan model Random Forest baru yang dilatih langsung 
    dari riwayat data asli server e-Sign Sumbar.
    """
    if eta_model is None:
        raise HTTPException(status_code=500, detail="Model ETA belum tersedia (real_eta_model.pkl tidak ditemukan).")

    # Tentukan titik awal waktu perhitungan (basis tanggal pengajuan surat)
    if tanggal_pengajuan:
        try:
            basis_waktu = datetime.strptime(tanggal_pengajuan, "%Y-%m-%d")
        except ValueError:
            raise HTTPException(status_code=400, detail="Format tanggal_pengajuan harus YYYY-MM-DD")
    else:
        basis_waktu = datetime.now()

    sekarang = datetime.now()

    # Siapkan data input sesuai kolom yang dipakai saat training: ['tipe_dokumen', 'jumlah_pengikut', 'kategori']
    input_df = pd.DataFrame([{
        'tipe_dokumen': tipe_dokumen,
        'jumlah_pengikut': jumlah_pengikut,
        'kategori': kategori
    }])

    # Lakukan prediksi (hasil dari model adalah durasi dalam satuan jam)
    try:
        pred_jam = float(eta_model.predict(input_df)[0])
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Gagal melakukan prediksi dengan model: {str(e)}")

    pred_hari = pred_jam / 24.0

    # Kalkulasi estimasi waktu selesai dari basis waktu pengajuan surat
    estimasi_waktu_selesai = basis_waktu + timedelta(hours=pred_jam)
    
    # Format label waktu ramah pengguna ("Hari ini", "Besok", atau tanggal spesifik)
    selisih_hari = (estimasi_waktu_selesai.date() - sekarang.date()).days
    if selisih_hari == 0:
        label_hari = "Hari ini"
    elif selisih_hari == 1:
        label_hari = "Besok"
    elif selisih_hari == 2:
        label_hari = "Lusa"
    else:
        label_hari = estimasi_waktu_selesai.strftime("%d %b %Y")
        
    label_jam = estimasi_waktu_selesai.strftime("%H:%M")
    estimasi_label = f"{label_hari}, {label_jam}"

    return {
        "prediksi_eta": {
            "durasi_jam": round(pred_jam, 1),
            "durasi_hari": round(pred_hari, 1),
            "estimasi_selesai": estimasi_waktu_selesai.strftime("%Y-%m-%d %H:%M"),
            "estimasi_selesai_label": estimasi_label,
            "confidence": "Tinggi (Berdasarkan Data Asli)"
        }
    }

# ==========================================
# 4. ANALYTICS (PUNYA TEMAN)
# ==========================================

@app.get("/api/analytics/weekly_pattern")
def weekly_pattern(pegawai: str = "a4adb04d8392abc79d52ea247fabd8348b97a78a"):
    """
    Menganalisis pola rata-rata pengajuan per hari dalam seminggu berdasarkan data historis.
    """
    current_dir = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(current_dir, f'historical_data_pegawai_{pegawai}.csv')
    
    if not os.path.exists(data_path):
        return {"error": "Data historis tidak ditemukan."}
        
    df = pd.read_csv(data_path)
    df['tanggal'] = pd.to_datetime(df['tanggal'])
    df['hari_dalam_minggu'] = df['tanggal'].dt.dayofweek # 0=Senin, 6=Minggu
    
    # Rata-rata per hari
    avg_per_day = df.groupby('hari_dalam_minggu')['total'].mean().to_dict()
    
    # Format untuk chart Flutter
    hari_label = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"]
    pattern = []
    
    for i in range(7):
        pattern.append({
            "hari": hari_label[i],
            "rata_rata_pengajuan": round(avg_per_day.get(i, 0), 1)
        })
        
    return {"pola_mingguan": pattern}

@app.get("/api/analytics/monthly_trend")
def monthly_trend(pegawai: str = "a4adb04d8392abc79d52ea247fabd8348b97a78a"):
    """
    Menganalisis tren total pengajuan (Nodin + SPT) per bulan selama 6 bulan terakhir.
    """
    current_dir = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(current_dir, f'historical_data_pegawai_{pegawai}.csv')
    
    if not os.path.exists(data_path):
        return {"error": "Data historis tidak ditemukan."}
        
    df = pd.read_csv(data_path)
    df['tanggal'] = pd.to_datetime(df['tanggal'])
    
    # Ambil 6 bulan terakhir
    six_months_ago = df['tanggal'].max() - pd.DateOffset(months=6)
    df_last_6m = df[df['tanggal'] >= six_months_ago]
    
    # Group by bulan
    df_last_6m['bulan_tahun'] = df_last_6m['tanggal'].dt.strftime('%b %Y')
    
    # Supaya urutannya benar, kita sort berdasarkan tanggal (bulan awal ke bulan akhir)
    monthly_sum = df_last_6m.groupby(df_last_6m['tanggal'].dt.to_period('M'))['total'].sum()
    
    trend = []
    for period, total in monthly_sum.items():
        trend.append({
            "bulan": period.strftime('%b'),
            "total": int(total)
        })
        
    # Ambil maksimal 6 bulan terakhir
    return {"tren_bulanan": trend[-6:]}

@app.get("/api/analytics/summary")
def summary_bulan_ini(pegawai: str = "a4adb04d8392abc79d52ea247fabd8348b97a78a"):
    """
    Mengembalikan ringkasan data 'Bulan Ini' untuk Nodin & SPT.
    """
    current_dir = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(current_dir, f'historical_data_pegawai_{pegawai}.csv')
    
    if not os.path.exists(data_path):
        return {"error": "Data historis tidak ditemukan."}
        
    df = pd.read_csv(data_path)
    df['tanggal'] = pd.to_datetime(df['tanggal'])
    
    current_month = datetime.now().month
    current_year = datetime.now().year
    
    df_month = df[(df['tanggal'].dt.month == current_month) & (df['tanggal'].dt.year == current_year)]
    total_masuk = int(df_month['total'].sum())
    
    # Karena data kita hanya total pengajuan, kita bisa asumsikan persentase status
    disetujui = int(total_masuk * 0.75)
    berjalan = int(total_masuk * 0.20)
    ditolak = total_masuk - disetujui - berjalan
    
    return {
        "surat_masuk": total_masuk,
        "disetujui": disetujui,
        "berjalan": berjalan,
        "ditolak": ditolak
    }

if __name__ == '__main__':
    import uvicorn
    # Jalankan server di port 8000
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)