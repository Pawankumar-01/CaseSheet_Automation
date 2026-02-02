from fastapi import APIRouter, UploadFile, File, HTTPException
from uuid import uuid4
from datetime import datetime
import os

from app.storage.in_memory import CASE_SHEETS

router = APIRouter()

UPLOAD_DIR = "app/storage/uploads/lab_reports"
os.makedirs(UPLOAD_DIR, exist_ok=True)


@router.post("/sessions/{session_id}/sections/{section}/images")
def upload_section_image(
    session_id: str,
    section: str,
    file: UploadFile = File(...)
):
    draft = CASE_SHEETS.get(session_id)
    if not draft:
        raise HTTPException(status_code=404, detail="Session not found")

    if draft.get("finalized"):
        raise HTTPException(status_code=400, detail="Case sheet finalized")

    image_id = str(uuid4())
    filename = f"{image_id}_{file.filename}"
    path = os.path.join(UPLOAD_DIR, filename)

    with open(path, "wb") as f:
        f.write(file.file.read())

    sections = draft.setdefault("sections", {})
    section_data = sections.setdefault(section, {})
    images = section_data.setdefault("images", [])

    images.append({
        "id": image_id,
        "filename": filename,
        "mime": file.content_type,
        "uploaded_at": datetime.utcnow().isoformat()
    })

    return {"status": "ok"}
