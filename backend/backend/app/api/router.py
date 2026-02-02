from fastapi import APIRouter
from app.api.routes import sessions, audio, images

api_router = APIRouter()

api_router.include_router(sessions.router, prefix="/sessions", tags=["Sessions"])
api_router.include_router(audio.router, prefix="/audio", tags=["Audio"])
api_router.include_router(images.router)