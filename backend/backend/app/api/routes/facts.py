# from fastapi import APIRouter, HTTPException
# from app.storage.in_memory import FACTS
# from app.services.fact_model import create_fact

# router = APIRouter(prefix="/sessions", tags=["Fact Review"])


# @router.get("/{session_id}/facts")
# def get_facts(session_id: str):
#     return {
#         "session_id": session_id,
#         "facts": FACTS.get(session_id, [])
#     }


# @router.post("/{session_id}/facts/{fact_id}")
# def update_fact(session_id: str, fact_id: str, payload: dict):
#     facts = FACTS.get(session_id)

#     if not facts:
#         raise HTTPException(status_code=404, detail="Session not found")

#     for fact in facts:
#         if fact["fact_id"] == fact_id:
#             for key, value in payload.items():
#                 if key in fact:
#                     fact[key] = value

#             # doctor-edited facts have higher confidence
#             fact["confidence"] = 1.0
#             return {"status": "updated", "fact": fact}

#     raise HTTPException(status_code=404, detail="Fact not found")



# @router.post("/{session_id}/facts")
# def add_fact(session_id: str, payload: dict):
#     fact = create_fact(
#         session_id=session_id,
#         intent=payload.get("intent"),
#         fact_type=payload.get("fact_type"),
#         name=payload.get("name"),
#         status=payload.get("status", "present"),
#         duration=payload.get("duration"),
#         severity=payload.get("severity"),
#         source_text="doctor_manual_entry",
#         confidence=1.0
#     )

#     FACTS.setdefault(session_id, []).append(fact)

#     return {"status": "created", "fact": fact}
