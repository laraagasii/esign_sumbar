import pandas as pd
from prophet import Prophet
import json
from prophet.serialize import model_to_json
import os

def train_and_save_models():
    current_dir = os.path.dirname(os.path.abspath(__file__))
    
    for group_id in range(1, 8):
        data_path = os.path.join(current_dir, f'historical_data_group_{group_id}.csv')
        if not os.path.exists(data_path):
            print(f"Data untuk group {group_id} tidak ditemukan. Melewati...")
            continue
            
        df = pd.read_csv(data_path)
        
        # --- TRAINING MODEL NODIN ---
        print(f"Melatih model Nodin untuk Group {group_id}...")
        df_nodin = df[['tanggal', 'nodin']].rename(columns={'tanggal': 'ds', 'nodin': 'y'})
        model_nodin = Prophet(yearly_seasonality=True, weekly_seasonality=True, daily_seasonality=False)
        model_nodin.fit(df_nodin)
        
        with open(os.path.join(current_dir, f'model_nodin_group_{group_id}.json'), 'w') as f:
            json.dump(model_to_json(model_nodin), f)
            
        # --- TRAINING MODEL SPT ---
        print(f"Melatih model SPT untuk Group {group_id}...")
        df_spt = df[['tanggal', 'spt']].rename(columns={'tanggal': 'ds', 'spt': 'y'})
        model_spt = Prophet(yearly_seasonality=True, weekly_seasonality=True, daily_seasonality=False)
        model_spt.fit(df_spt)
        
        with open(os.path.join(current_dir, f'model_spt_group_{group_id}.json'), 'w') as f:
            json.dump(model_to_json(model_spt), f)

    print("✅ Model AI (Prophet) berhasil dilatih dan disimpan untuk semua grup!")

if __name__ == '__main__':
    train_and_save_models()
