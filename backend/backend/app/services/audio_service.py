import logging
from app.services.whisper_service import WhisperService
from app.services.transcript_service import TranscriptService
from app.services.gemma_service import GemmaService
from app.services.session_service import SessionService
from app.services.draft_service import DraftService


logger = logging.getLogger(__name__)

class AudioService:

    @staticmethod
    async def handle_chunk(session_id: str, section: str, chunk: bytes):
        logger.info(
            f"[AUDIO] Session={session_id}, Section={section}, Bytes={len(chunk)}"
        )

        # Transcribe
        result = WhisperService.transcribe(chunk)

        if "text" not in result or not result["text"].strip():
            logger.warning("[WHISPER] Empty transcription")
            return

        transcript_text = result["text"].strip()
        logger.info(f"[WHISPER] {transcript_text}")

        # Append transcript (optional, global log)
        TranscriptService.append(session_id,section, transcript_text)

        # 🔹 SECTION-BASED OLLAMA CALL
        section_output = GemmaService.generate_section(
            section=section,
            transcript=transcript_text  # IMPORTANT: section-only transcript
        )

        # 🔹 Persist into draft
        DraftService.update_section(
            session_id=session_id,
            section=section,
            data=section_output
        )

