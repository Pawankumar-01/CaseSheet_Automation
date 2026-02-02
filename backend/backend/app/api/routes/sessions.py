from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from app.services.session_service import SessionService
from app.services.transcript_service import TranscriptService
from app.storage.in_memory import CASE_SHEETS
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


# @router.get("/{session_id}/draft")
# def get_draft(session_id: str):
#     return SessionService.get_draft(session_id)

@router.get("/{session_id}/draft")
def get_case_sheet_draft(session_id: str):
    draft = SessionService.get_draft(session_id)
    if not draft:
        return {"error": "Draft not found"}
    return draft


class DraftUpdatePayload(BaseModel):
    field: str
    value: str


@router.post("/{session_id}/draft/update")
def update_draft_field(session_id: str, payload: DraftUpdatePayload):
    draft = CASE_SHEETS.get(session_id)

    if not draft:
        raise HTTPException(status_code=404, detail="Session not found")

    if draft.get("finalized"):
        raise HTTPException(status_code=400, detail="Case sheet already finalized")

    # Initialize doctor edits if missing
    if "doctor_edits" not in draft:
        draft["doctor_edits"] = {}

    draft["doctor_edits"][payload.field] = payload.value
    draft["last_updated_by"] = "doctor"

    return {"status": "ok"}

@router.get("/{session_id}/transcript")
def get_transcript(session_id: str):
    return TranscriptService.get(session_id)



@router.post("/{session_id}/finalize")
def finalize_session(session_id: str):
    SessionService.finalize(session_id)
    return {"status": "finalized"}
