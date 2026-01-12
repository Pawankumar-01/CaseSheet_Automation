from fastapi import APIRouter, UploadFile, File
from app.services.audio_service import AudioService

router = APIRouter()

@router.post("/{session_id}")
async def upload_audio_chunk(session_id: str, file: UploadFile = File(...)):
    content = await file.read()
    AudioService.handle_chunk(session_id, content)
    return {"status": "received"}
