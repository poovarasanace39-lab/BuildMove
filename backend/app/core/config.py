from pydantic_settings import BaseSettings
from typing import Optional

class Settings(BaseSettings):
    PROJECT_NAME: str = "BuildMove Backend API"
    VERSION: str = "1.0.0"
    API_V1_STR: str = "/api/v1"

    # PostgreSQL Database URL
    DATABASE_URL: str = "postgresql+asyncpg://postgres:postgres@localhost:5432/buildmove_db"

    # JWT Security
    SECRET_KEY: str = "buildmove_super_secret_production_key_change_in_env"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 30  # 30 days

    # Firebase Admin SDK Credentials
    FIREBASE_CREDENTIALS_PATH: Optional[str] = None

    # Razorpay Secrets (Stored on Server ONLY)
    RAZORPAY_KEY_ID: Optional[str] = None
    RAZORPAY_KEY_SECRET: Optional[str] = None

    # Cloudinary Document & Image Storage
    CLOUDINARY_CLOUD_NAME: Optional[str] = None
    CLOUDINARY_API_KEY: Optional[str] = None
    CLOUDINARY_API_SECRET: Optional[str] = None

    class Config:
        case_sensitive = True
        env_file = ".env"

settings = Settings()
