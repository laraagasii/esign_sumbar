import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import os

def generate_synthetic_data(num_days=365):
    current_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Konfigurasi beban per group
    group_configs = {
        1: {'base_nodin': 0, 'base_spt': 0, 'desc': 'Staff/PPTK (Hanya pengajuan)'},
        2: {'base_nodin': 2, 'base_spt': 2, 'desc': 'Kasubbag'},
        3: {'base_nodin': 5, 'base_spt': 8, 'desc': 'Kabid'},
        4: {'base_nodin': 8, 'base_spt': 12, 'desc': 'Sekretaris Dinas'},
        5: {'base_nodin': 12, 'base_spt': 15, 'desc': 'Asekda'},
        6: {'base_nodin': 20, 'base_spt': 25, 'desc': 'Sekda'},
        7: {'base_nodin': 0, 'base_spt': 0, 'desc': 'Gubernur / Wagub (Tidak menyetujui)'},
    }
            
    end_date = datetime.now().date()
    start_date = end_date - timedelta(days=num_days - 1)
    date_rng = pd.date_range(start=start_date, end=end_date, freq='D')
    
    np.random.seed(42)
    
    for group_id, config in group_configs.items():
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
        
        final_csv_path = os.path.join(current_dir, f'historical_data_group_{group_id}.csv')
        df.to_csv(final_csv_path, index=False)
        print(f"Berhasil membuat dataset untuk Group {group_id} ({config['desc']}) -> {final_csv_path}")

if __name__ == '__main__':
    generate_synthetic_data(365)
