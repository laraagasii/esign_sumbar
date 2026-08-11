import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import os

def generate_synthetic_data(num_days=365):
    current_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Konfigurasi beban per pegawai
    pegawai_configs = {
        '1a2394378ddbb186f6f622e8b3c872ee6872623f': {'base_nodin': 0, 'base_spt': 0, 'desc': 'staff'},
        '54a8b8362ebcb16af08c8acf33a2d8d5f335cf5e': {'base_nodin': 3, 'base_spt': 3, 'desc': 'pptk'},
        'ae914d89870f2450ca4c6ca9f34e3080317546e5': {'base_nodin': 5, 'base_spt': 8, 'desc': 'kabid'},
        '8018dcd81ff171aa9629c08d95422c20e45e307b': {'base_nodin': 12, 'base_spt': 15, 'desc': 'asekda'},
        'a4adb04d8392abc79d52ea247fabd8348b97a78a': {'base_nodin': 20, 'base_spt': 25, 'desc': 'sekda'},
    }
            
    end_date = datetime.now().date()
    start_date = end_date - timedelta(days=num_days - 1)
    date_rng = pd.date_range(start=start_date, end=end_date, freq='D')
    
    np.random.seed(42)
    
    for pegawai_id, config in pegawai_configs.items():
        data = []
        base_nodin = config['base_nodin']
        base_spt = config['base_spt']
        
        for dt in date_rng:
            date_str = dt.strftime('%Y-%m-%d')
            day_of_week = dt.weekday()
            month = dt.month
            
            if base_nodin == 0 and base_spt == 0:
                nodin = 0
                spt = 0
            else:
                if day_of_week in [0, 1, 2]: # Senin-Rabu
                    multiplier = np.random.uniform(1.0, 1.3)
                elif day_of_week in [3, 4]: # Kamis-Jumat
                    multiplier = np.random.uniform(0.7, 1.0)
                else: # Sabtu-Minggu libur
                    multiplier = np.random.uniform(0.0, 0.1)
                    
                if month in [11, 12]:
                    multiplier *= 1.3
                elif month in [6, 7]: 
                    multiplier *= 1.2
                    
                nodin = int(base_nodin * multiplier) + np.random.randint(-2, 3)
                spt = int(base_spt * multiplier) + np.random.randint(-2, 3)
                
                # Biarkan ada kemungkinan kosong untuk variasi
                nodin = max(0, nodin)
                spt = max(0, spt)
            
            data.append({
                'tanggal': date_str,
                'nodin': nodin,
                'spt': spt,
                'total': nodin + spt
            })
            
        df = pd.DataFrame(data)
        
        final_csv_path = os.path.join(current_dir, f'historical_data_pegawai_{pegawai_id}.csv')
        df.to_csv(final_csv_path, index=False)
        print(f"Berhasil membuat dataset untuk {config['desc']} -> {final_csv_path}")

if __name__ == '__main__':
    generate_synthetic_data(365)
    