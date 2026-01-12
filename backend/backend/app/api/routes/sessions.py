from fastapi import APIRouter
from pydantic import BaseModel
from app.services.session_service import SessionService
from app.services.transcript_service import TranscriptService
router = APIRouter()

class StartSessionRequest(BaseModel):
    patient_id: str | None = None
    doctor_id: str | None = None

@router.post("/start")
def start_session(payload: StartSessionRequest):
    session = SessionService.start_session(
        patient_id=payload.patient_id,
        doctor_id=payload.doctor_id,
    )
    return {"session_id": session["id"]}


@router.get("/{session_id}/draft")
def get_draft(session_id: str):
    return SessionService.get_draft(session_id)


@router.get("/{session_id}/transcript")
def get_transcript(session_id: str):
    return TranscriptService.get(session_id)



@router.post("/{session_id}/finalize")
def finalize_session(session_id: str):
    SessionService.finalize(session_id)
    return {"status": "finalized"}
