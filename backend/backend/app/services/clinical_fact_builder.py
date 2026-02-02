"""
⚠️ FUTURE USE ONLY

ClinicalFactBuilder is part of a future fact-based
clinical data layer.

Current pipeline maps NLP entities directly
into the case sheet sections (models/casesheet.py).

DO NOT USE in production pipeline yet.
"""
# # app/services/clinical_fact_builder.py

# from app.models.clinical_fact import ClinicalFact
# from uuid import uuid4

# class ClinicalFactBuilder:
#     @staticmethod
#     def build(entities: list, session_id: str) -> list[ClinicalFact]:
#         facts = []
#         current_fact = None

#         for ent in entities:
#             etype = ent["label"]
#             text = ent["text"]

#             if etype == "SYMPTOM":
#                 current_fact = ClinicalFact(
#                     fact_id=str(uuid4()),
#                     session_id=session_id,
#                     fact_type="symptom",
#                     name=text,
#                     status="present",
#                     negated=False,
#                     confidence=ent.get("confidence", 0.7)
#                 )
#                 facts.append(current_fact)

#             elif current_fact:
#                 if etype == "SEVERITY":
#                     current_fact.severity = text

#                 elif etype == "DURATION":
#                     current_fact.duration = text

#                 elif etype == "BODY_PART":
#                     current_fact.body_part = text

#                 elif etype == "NEGATION":
#                     current_fact.status = "absent"
#                     current_fact.negated = True

#                 elif etype == "COURSE":
#                     current_fact.course = text

#         return facts
