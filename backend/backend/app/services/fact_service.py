from app.storage.in_memory import FACTS
from app.services.fact_model import create_fact
from app.services.clinical_ner_service import ClinicalNERService

class FactService:

    @staticmethod
    def process_sentence(session_id: str, intent: str, sentence: str):
        entities = ClinicalNERService.extract(sentence)

        FACTS.setdefault(session_id, [])

        # --- SYMPTOMS ---
        for symptom in entities["symptoms"]:
            existing = next(
                (
                    f for f in FACTS[session_id]
                    if f["fact_type"] == "symptom"
                    and f["name"] == symptom["name"]
                ),
                None
            )

            if existing:
                # Enrich existing fact
                if entities["severity"]:
                    existing["severity"] = entities["severity"]
                if entities["duration"]:
                    existing["duration"] = entities["duration"]
            else:
                fact = create_fact(
                    session_id=session_id,
                    intent=intent,
                    fact_type="symptom",
                    name=symptom["name"],
                    status="absent" if symptom["negated"] else "present",
                    negated=symptom["negated"],
                    duration=entities["duration"],
                    severity=entities["severity"],
                    body_part=None,
                    confidence=0.85,
                    source_text=sentence
                )
                FACTS[session_id].append(fact)
                print(f"[FACT] {fact}")

        # --- MEDICATION ---
        if entities["medication"]:
            med_fact = create_fact(
                session_id=session_id,
                intent=intent,
                fact_type="medication",
                name=entities["medication"],
                status="taken",
                source_text=sentence
            )
            FACTS[session_id].append(med_fact)
            print(f"[FACT] {med_fact}")
