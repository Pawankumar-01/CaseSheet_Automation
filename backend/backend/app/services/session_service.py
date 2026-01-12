from app.models.session import create_session
from app.models.casesheet import empty_case_sheet
from app.storage.in_memory import SESSIONS, CASE_SHEETS

class SessionService:

    @staticmethod
    def start_session(patient_id=None, doctor_id=None):
        session = create_session(patient_id, doctor_id)
        SESSIONS[session["id"]] = session
        CASE_SHEETS[session["id"]] = empty_case_sheet()
        return session

    @staticmethod
    def get_draft(session_id: str):
        return CASE_SHEETS.get(session_id)

    @staticmethod
    def finalize(session_id: str):
        CASE_SHEETS[session_id]["finalized"] = True
        SESSIONS[session_id]["finalized"] = True
