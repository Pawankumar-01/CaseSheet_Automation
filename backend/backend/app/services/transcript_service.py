from datetime import datetime
from app.storage.in_memory import TRANSCRIPTS

class TranscriptService:

    @staticmethod
    def append(session_id: str, text: str):
        TRANSCRIPTS.setdefault(session_id, []).append({
            "text": text,
            "timestamp": datetime.utcnow().isoformat()
        })

    @staticmethod
    def get(session_id: str):
        return TRANSCRIPTS.get(session_id, [])
