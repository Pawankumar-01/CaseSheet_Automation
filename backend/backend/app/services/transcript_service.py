from app.storage.in_memory import TRANSCRIPTS

class TranscriptService:

    @staticmethod
    def append(session_id: str, section: str, text: str):
        TRANSCRIPTS.setdefault(session_id, {})
        TRANSCRIPTS[session_id].setdefault(section, [])
        TRANSCRIPTS[session_id][section].append(text)

    @staticmethod
    def get(session_id: str, section: str) -> list[str]:
        return TRANSCRIPTS.get(session_id, {}).get(section, [])
