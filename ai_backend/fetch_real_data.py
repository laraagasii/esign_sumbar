import requests
import json
import pandas as pd
from datetime import datetime
import os

# List of users from Login.json
USERS = [
    {"id": "1a2394378ddbb186f6f622e8b3c872ee6872623f", "group": "1"}, # staff
    {"id": "54a8b8362ebcb16af08c8acf33a2d8d5f335cf5e", "group": "1"}, # pptk
    {"id": "ae914d89870f2450ca4c6ca9f34e3080317546e5", "group": "3"}, # kabid
    {"id": "8018dcd81ff171aa9629c08d95422c20e45e307b", "group": "5"}, # asekda
    {"id": "a4adb04d8392abc79d52ea247fabd8348b97a78a", "group": "6"}  # sekda
]

BASE_URL = "https://espj.sumbarprov.go.id/sumbarapis/spj"

def fetch_data():
    date_counts = {} # Format: {'2023-10-01': {'nodin': 2, 'spt': 1}}
    
    def add_count(date_str, type_doc):
        if not date_str or len(date_str) < 10:
            return
        
        # Simple extraction of YYYY-MM-DD
        try:
            # handle formats like "2023-10-01 10:00:00" or just date
            d = str(date_str).strip()[:10]
            # test parsing
            datetime.strptime(d, "%Y-%m-%d")
        except:
            return
            
        if d not in date_counts:
            date_counts[d] = {'nodin': 0, 'spt': 0}
        
        date_counts[d][type_doc] += 1

    for user in USERS:
        uid = user["id"]
        group = user["group"]
        
        # 1. Nodin MBB
        url_nodin_mbb = f"{BASE_URL}/nota-dinas/list/id/{uid}/group/{group}/status/MBB"
        try:
            res = requests.get(url_nodin_mbb)
            if res.status_code == 200:
                data = res.json()
                if data.get('response') == 1 and data.get('result'):
                    for item in data['result']:
                        add_count(item.get('tglnota'), 'nodin')
        except Exception as e:
            print(f"Error fetching nodin MBB for {uid}: {e}")

        # 2. Nodin MSB
        url_nodin_msb = f"{BASE_URL}/nota-dinas/list/id/{uid}/group/{group}/status/MSB"
        try:
            res = requests.get(url_nodin_msb)
            if res.status_code == 200:
                data = res.json()
                if data.get('response') == 1 and data.get('result'):
                    for item in data['result']:
                        add_count(item.get('tglnota'), 'nodin')
        except:
            pass
            
        # 3. SPT NEW
        url_spt_new = f"{BASE_URL}/surat-tugas/list/id/{uid}/status/NEW"
        try:
            res = requests.get(url_spt_new)
            if res.status_code == 200:
                data = res.json()
                if data.get('response') == 1 and data.get('result'):
                    for item in data['result']:
                        date_val = item.get('pergi') or item.get('tglspt') or item.get('tanggal') or item.get('tgl')
                        add_count(date_val, 'spt')
        except:
            pass

        # 4. SPT List
        url_spt_list = f"{BASE_URL}/surat-tugas/list/id/{uid}"
        try:
            res = requests.get(url_spt_list)
            if res.status_code == 200:
                data = res.json()
                if data.get('response') == 1 and data.get('result'):
                    for item in data['result']:
                        date_val = item.get('pergi') or item.get('tglspt') or item.get('tanggal') or item.get('tgl')
                        add_count(date_val, 'spt')
        except:
            pass

    # Convert to dataframe
    rows = []
    for d, counts in date_counts.items():
        rows.append({
            'tanggal': d,
            'nodin': counts['nodin'],
            'spt': counts['spt'],
            'total': counts['nodin'] + counts['spt']
        })
        
    df = pd.DataFrame(rows)
    if not df.empty:
        df = df.sort_values('tanggal').reset_index(drop=True)
        
    current_dir = os.path.dirname(os.path.abspath(__file__))
    csv_path = os.path.join(current_dir, 'actual_data.csv')
    df.to_csv(csv_path, index=False)
    print(f"Berhasil menarik data aktual! Ditemukan {len(df)} hari dengan transaksi.")
    if not df.empty:
        print(df.tail(10))

if __name__ == '__main__':
    fetch_data()
