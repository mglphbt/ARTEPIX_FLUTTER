from typing import List, Union
from pydantic import AnyHttpUrl, validator
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    PROJECT_NAME: str = "Artepix API"
    PROJECT_VERSION: str = "1.0.0"
    API_V1_STR: str = "/api/v1"
    
    # CORS
    BACKEND_CORS_ORIGINS: List[AnyHttpUrl] = []

    @validator("BACKEND_CORS_ORIGINS", pre=True)
    def assemble_cors_origins(cls, v: Union[str, List[str]]) -> Union[List[str], str]:
        if isinstance(v, str) and not v.startswith("["):
            return [i.strip() for i in v.split(",")]
        elif isinstance(v, (list, str)):
            return v
        raise ValueError(v)

    # Database (Postgres)
    POSTGRES_SERVER: str = "db"
    POSTGRES_USER: str = "postgres"
    POSTGRES_PASSWORD: str = "postgres"
    POSTGRES_DB: str = "artepix_db"
    DATABASE_URL: str = ""

    @validator("DATABASE_URL", pre=True)
    def assemble_db_connection(cls, v: str, values: dict) -> str:
        if isinstance(v, str) and v:
            return v
        return str(f"postgresql+asyncpg://{values.get('POSTGRES_USER')}:{values.get('POSTGRES_PASSWORD')}@{values.get('POSTGRES_SERVER')}/{values.get('POSTGRES_DB')}")

    # Database (MongoDB)
    MONGODB_URL: str = "mongodb://mongo:27017"
    MONGODB_DB_NAME: str = "artepix_mongo"
    
    # Security
    SECRET_KEY: str = "supersecretkey_change_me_in_production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    
    # Google OAuth
    GOOGLE_CLIENT_ID: str = "694993836560-maf4lvbbmrr5crt5ckd6ucg3f8ljkuh5.apps.googleusercontent.com"
    
    # SMTP Email Configuration
    SMTP_HOST: str = "smtp.hostinger.com"
    SMTP_PORT: int = 465
    SMTP_EMAIL: str = "no-reply@artepix.co.id"
    SMTP_PASSWORD: str = "$UAPaamHNM2025$"
    
    # Google Gemini AI
    GEMINI_API_KEY: str = ""  # Set via environment variable
    
    # OTP Settings
    OTP_EXPIRE_MINUTES: int = 5

    class Config:
        case_sensitive = True
        env_file = ".env"

settings = Settings()

