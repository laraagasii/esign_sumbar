import os
import sys

# Tambahkan folder ai_backend ke path agar import di dalamnya tidak error
sys.path.append(os.path.join(os.path.dirname(__file__), "ai_backend"))

from ai_backend.app import app

# Hugging Face Gradio SDK secara otomatis akan mencari variabel bernama 'app'
# dan menjalankannya dengan uvicorn jika itu adalah instance FastAPI.
