import os
from pydantic_settings import BaseSettings, SettingsConfigDict
from typing import Optional

class Settings(BaseSettings):
    # API Keys
    OPENROUTER_API_KEY: str
    
    # App Settings
    PROJECT_NAME: str = "Clinical Case Sheet AI"
    DEBUG: bool = False
    
    # API Configuration
    OPENROUTER_URL: str = "https://openrouter.ai/api/v1/chat/completions"
    MODEL_ID: str = "google/gemma-3-27b-it:free"
    
    # Storage Path (If you use local storage for audio temp files)
    TEMP_AUDIO_DIR: str = "temp_audio"

    # This allows the settings to read from a .env file automatically
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

# Initialize settings
settings = Settings()

# Ensure temp directory exists
if not os.path.exists(settings.TEMP_AUDIO_DIR):
    os.makedirs(settings.TEMP_AUDIO_DIR)