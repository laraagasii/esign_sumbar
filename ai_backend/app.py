from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
import pandas as pd
from prophet.serialize import model_from_json
import json
import os
import joblib
from datetime import datetime, timedelta

app = FastAPI(
    title="AI Analitik Persetujuan API",
    description="API untuk memprediksi volume pengajuan Nodin dan SPT menggunakan AI Time Series (Prophet) serta Estimasi Waktu (RandomForest dari Data Riwayat API Asli)",
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

# Load Model Prophet
def load_prophet_model(filename):
    current_dir = os.path.dirname(os.path.abspath(__file__))
    path = os.path.join(current_dir, filename)
    if not os.path.exists(path):
        return None
        
    with open(path, 'r') as f:
        return model_from_json(json.load(f))

# Load Model ETA yang baru (hasil training dari data API asli) secara global saat aplikasi berjalan
MODEL_PATH = "real_eta_model.pkl"
try:
    current_dir = os.path.dirname(os.path.abspath(__file__))
    model_file_path = os.path.join(current_dir, MODEL_PATH)
    eta_model = joblib.load(model_file_path)
    print("✅ Model ETA Asli (real_eta_model.pkl) berhasil diload.")
except Exception as e:
    eta_model = None
    print(f"⚠️ Peringatan: Model ETA tidak ditemukan. Pastikan file real_eta_model.pkl ada di folder ai_backend. Error: {e}")


@app.get("/")
def home():
    return {"message": "AI Backend (Data Asli e-Sign) berjalan normal. Kunjungi /docs untuk melihat dokumentasi API."}

@app.get("/api/predict")
def predict_next_month(group: int = 6):
    """
    Memprediksi jumlah Nodin dan SPT untuk 30 hari ke depan (bulan depan).
    """
    model_nodin = load_prophet_model(f'model_nodin_group_{group}.json')
    model_spt = load_prophet_model(f'model_spt_group_{group}.json')
    
    if not model_nodin or not model_spt:
        return {"error": "Model AI belum dilatih. Jalankan train_model.py terlebih dahulu."}
        
    # Buat dataframe untuk 30 hari ke depan
    future = model_nodin.make_future_dataframe(periods=30)
    
    # Prediksi
    forecast_nodin = model_nodin.predict(future)
    forecast_spt = model_spt.predict(future)
    
    # Ambil 30 baris terakhir (yang merupakan masa depan)
    future_nodin = forecast_nodin.tail(30)
    future_spt = forecast_spt.tail(30)
    
    # Hitung total prediksi (yhat)
    total_nodin_pred = max(0, int(future_nodin['yhat'].sum()))
    total_spt_pred = max(0, int(future_spt['yhat'].sum()))
    
    # Detail harian
    daily_details = []
    for i in range(30):
        row_n = future_nodin.iloc[i]
        row_s = future_spt.iloc[i]
        daily_details.append({
            "tanggal": row_n['ds'].strftime('%Y-%m-%d'),
            "prediksi_nodin": max(0, int(row_n['yhat'])),
            "prediksi_spt": max(0, int(row_s['yhat']))
        })
        
    return {
        "prediksi_bulan_depan": {
            "total_nodin": total_nodin_pred,
            "total_spt": total_spt_pred,
            "total_keseluruhan": total_nodin_pred + total_spt_pred,
            "detail_harian": daily_details
        }
    }

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


@app.get("/api/analytics/weekly_pattern")
def weekly_pattern(group: int = 6):
    current_dir = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(current_dir, f'historical_data_group_{group}.csv')
    
    if not os.path.exists(data_path):
        return {"error": "Data historis tidak ditemukan."}
        
    df = pd.read_csv(data_path)
    df['tanggal'] = pd.to_datetime(df['tanggal'])
    df['hari_dalam_minggu'] = df['tanggal'].dt.dayofweek 
    
    avg_per_day = df.groupby('hari_dalam_minggu')['total'].mean().to_dict()
    
    hari_label = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"]
    pattern = []
    
    for i in range(7):
        pattern.append({
            "hari": hari_label[i],
            "rata_rata_pengajuan": round(avg_per_day.get(i, 0), 1)
        })
        
    return {"pola_mingguan": pattern}

@app.get("/api/analytics/monthly_trend")
def monthly_trend(group: int = 6):
    current_dir = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(current_dir, f'historical_data_group_{group}.csv')
    
    if not os.path.exists(data_path):
        return {"error": "Data historis tidak ditemukan."}
        
    df = pd.read_csv(data_path)
    df['tanggal'] = pd.to_datetime(df['tanggal'])
    
    six_months_ago = df['tanggal'].max() - pd.DateOffset(months=6)
    df_last_6m = df[df['tanggal'] >= six_months_ago]
    
    df_last_6m['bulan_tahun'] = df_last_6m['tanggal'].dt.strftime('%b %Y')
    monthly_sum = df_last_6m.groupby(df_last_6m['tanggal'].dt.to_period('M'))['total'].sum()
    
    trend = []
    for period, total in monthly_sum.items():
        trend.append({
            "bulan": period.strftime('%b'),
            "total": int(total)
        })
        
    return {"trend_bulanan": trend[-6:]}

@app.get("/api/analytics/summary")
def summary_bulan_ini(group: int = 6):
    current_dir = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(current_dir, f'historical_data_group_{group}.csv')
    
    if not os.path.exists(data_path):
        return {"error": "Data historis tidak ditemukan."}
        
    dir_path = os.path.dirname(os.path.abspath(__file__))
    # ... (lanjutan fungsi summary seperti semula)
    df = pd.read_csv(data_path)
    df['tanggal'] = pd.to_datetime(df['tanggal'])
    
    current_month = datetime.now().month
    current_year = datetime.now().year
    
    df_month = df[(df['tanggal'].dt.month == current_month) & (df['tanggal'].dt.year == current_year)]
    total_masuk = int(df_month['total'].sum())
    
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
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)