from app.services.whisper_service import WhisperService
from app.services.transcript_service import TranscriptService
from app.services.sentence_service import SentenceService
from app.services.intent_service import IntentService
from app.services.fact_service import FactService
import logging

logger = logging.getLogger(__name__)

class AudioService:

    @staticmethod
    def handle_chunk(session_id: str, chunk: bytes):
        logger.info(f"[AUDIO] Received chunk for session {session_id}, size={len(chunk)} bytes")

        result = WhisperService.transcribe(chunk)

        if "text" in result:
            logger.info(f"[WHISPER] Transcript: {result['text']}")
            TranscriptService.append(
                session_id=session_id,
                text=result["text"].strip()
            )

        sentences = SentenceService.split(result["text"])

        last_intent = None

        for sentence in sentences:
            intent = IntentService.classify(sentence)

            if intent == "other" and last_intent:
                intent = last_intent

            if intent != "other":
                last_intent = intent

            print(f"[INTENT] {intent.upper()} → {sentence}")

            # NER + FACT CREATION
            FactService.process_sentence(
                session_id=session_id,
                intent=intent,
                sentence=sentence
            )
