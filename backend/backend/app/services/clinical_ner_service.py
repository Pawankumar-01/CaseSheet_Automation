import re
from app.services.clinical_vocab import (
    SYMPTOMS,
    SEVERITY_WORDS,
    NEGATION_WORDS,
    DURATION_PATTERNS,
    MEDICATION_KEYWORDS
)

class ClinicalNERService:

    @staticmethod
    def extract(sentence: str) -> dict:
        s = sentence.lower()

        entities = {
            "symptoms": [],   # list of {name, system, negated}
            "duration": None,
            "severity": None,
            "medication": None
        }

        # --- SEVERITY ---
        for sev in SEVERITY_WORDS:
            if sev in s:
                entities["severity"] = sev
                break

        # --- DURATION ---
        for pattern in DURATION_PATTERNS:
            match = re.search(pattern, s)
            if match:
                entities["duration"] = match.group()
                break

        # --- MEDICATION (LIGHT DETECTION) ---
        for med in MEDICATION_KEYWORDS:
            if med in s:
                entities["medication"] = med
                break

        # --- SYMPTOMS + LOCAL NEGATION ---
        for symptom_name, meta in SYMPTOMS.items():
            for variant in meta["variants"]:
                if variant in s:
                    symptom_index = s.find(variant)

                    negation_positions = [
                        s.find(n) for n in NEGATION_WORDS if n in s
                    ]
                    negation_index = min(negation_positions) if negation_positions else -1

                    negated = (
                        negation_index != -1 and symptom_index > negation_index
                    )

                    entities["symptoms"].append({
                        "name": symptom_name,
                        "system": meta["system"],
                        "negated": negated
                    })

                    break  # stop after first variant match

        return entities
