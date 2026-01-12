from fastapi import APIRouter
from app.api.routes import sessions, audio

api_router = APIRouter()

api_router.include_router(sessions.router, prefix="/sessions", tags=["Sessions"])
api_router.include_router(audio.router, prefix="/audio", tags=["Audio"])
