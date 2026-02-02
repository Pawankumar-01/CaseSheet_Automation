from fastapi import APIRouter, UploadFile, File, Query
from app.services.audio_service import AudioService

router = APIRouter()

@router.post("/{session_id}")
async def upload_audio_chunk(
    session_id: str,
    section: str = Query(...),
    file: UploadFile = File(...)
):
    content = await file.read()

    # 🔹 Added 'await' here
    await AudioService.handle_chunk(
        session_id=session_id,
        section=section,
        chunk=content
    )

    return {"status": "ok"}
