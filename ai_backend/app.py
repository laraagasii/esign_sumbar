from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import pandas as pd
from prophet.serialize import model_from_json
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
    with open(path, 'r') as f:
        return model_from_json(json.load(f))

@app.get("/")
def home():
    return {"message": "AI Backend berjalan normal. Kunjungi /docs untuk melihat dokumentasi API."}

@app.get("/api/predict")
def predict_next_month(group: int = 6):
    """
    Memprediksi jumlah Nodin dan SPT untuk 30 hari ke depan (bulan depan).
    """
    model_nodin = load_model(f'model_nodin_group_{group}.json')
    model_spt = load_model(f'model_spt_group_{group}.json')
    
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

@app.get("/api/analytics/weekly_pattern")
def weekly_pattern(group: int = 6):
    """
    Menganalisis pola rata-rata pengajuan per hari dalam seminggu berdasarkan data historis.
    """
    current_dir = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(current_dir, f'historical_data_group_{group}.csv')
    
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
def monthly_trend(group: int = 6):
    """
    Menganalisis tren total pengajuan (Nodin + SPT) per bulan selama 6 bulan terakhir.
    """
    current_dir = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(current_dir, f'historical_data_group_{group}.csv')
    
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
def summary_bulan_ini(group: int = 6):
    """
    Mengembalikan ringkasan data 'Bulan Ini' untuk Nodin & SPT.
    """
    current_dir = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(current_dir, f'historical_data_group_{group}.csv')
    
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
