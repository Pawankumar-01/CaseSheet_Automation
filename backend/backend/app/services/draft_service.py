import logging
from ..storage.in_memory import CASE_SHEETS

logger = logging.getLogger(__name__)

SECTIONS = [
    "chief_complaint",
    "anamnesis",
    "treatment_and_background",
    "personal_history",
    "review_of_systems",
    "systemic_examination",
    "past_medical_history",
    "assessment_and_plan",
]


def _empty_sections():
    return {section: {} for section in SECTIONS}


class DraftService:
    @staticmethod
    def _ensure_draft(session_id: str):
        """
        Create a clean draft structure if missing.
        """
        if session_id not in CASE_SHEETS:
            CASE_SHEETS[session_id] = {}

        CASE_SHEETS[session_id].setdefault(
            "metadata",
            {"finalized": False},
        )

        CASE_SHEETS[session_id].setdefault(
            "sections",
            _empty_sections(),
        )

        # 🔥 Remove any legacy / invalid sections silently
        for key in list(CASE_SHEETS[session_id]["sections"].keys()):
            if key not in SECTIONS:
                del CASE_SHEETS[session_id]["sections"][key]

    # -------------------------
    # READ
    # -------------------------

    @staticmethod
    def get(session_id: str) -> dict:
        DraftService._ensure_draft(session_id)
        return CASE_SHEETS[session_id]

    # -------------------------
    # WRITE (OLLAMA)
    # -------------------------

    @staticmethod
    def update_section(session_id: str, section: str, data: dict):
        if section not in SECTIONS:
            logger.warning(f"[DRAFT] Unknown section ignored: {section}")
            return

        DraftService._ensure_draft(session_id)

        CASE_SHEETS[session_id]["sections"][section] = data

        logger.info(
            f"[DRAFT UPDATED] session={session_id}, section={section}"
        )

    # -------------------------
    # WRITE (UI EDIT)
    # -------------------------

    @staticmethod
    def update_field(session_id: str, field_path: str, value):
        """
        field_path example:
        - chief_complaint.summary
        - review_of_systems.general.present
        """
        DraftService._ensure_draft(session_id)

        parts = field_path.split(".")
        section = parts[0]

        if section not in SECTIONS:
            raise ValueError("Invalid section")

        target = CASE_SHEETS[session_id]["sections"][section]

        for key in parts[1:-1]:
            target = target.setdefault(key, {})

        target[parts[-1]] = value

        logger.info(
            f"[DRAFT FIELD UPDATED] session={session_id}, field={field_path}"
        )
