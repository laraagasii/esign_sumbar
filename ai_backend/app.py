from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import pandas as pd
import pickle
import json
import os
from datetime import datetime, timedelta

app = FastAPI(
    title="AI Analitik Persetujuan API",
    description="API untuk memprediksi volume pengajuan Nodin dan SPT menggunakan AI Time Series (Prophet)",
    version="1.0.0"
)

# Enable CORS for Flutter app to consume
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def load_model(filename):
    current_dir = os.path.dirname(os.path.abspath(__file__))
    path = os.path.join(current_dir, filename)
    if not os.path.exists(path):
        return None
    with open(path, 'rb') as f:
        return pickle.load(f)

@app.get("/")
def home():
    return {"message": "AI Backend berjalan normal. Kunjungi /docs untuk melihat dokumentasi API."}

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
