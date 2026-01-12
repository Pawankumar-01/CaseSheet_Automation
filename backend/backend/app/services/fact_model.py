from uuid import uuid4
from datetime import datetime

def create_fact(
    session_id: str,
    intent: str,
    fact_type: str,
    name: str,
    value=None,
    status="present",
    temporal="current",
    duration=None,
    severity=None,
    body_part=None,
    negated=False,
    confidence=0.8,
    source_text=""
):
    return {
        "fact_id": str(uuid4()),
        "session_id": session_id,
        "intent": intent,
        "fact_type": fact_type,
        "name": name,
        "value": value,
        "status": status,
        "temporal": temporal,
        "duration": duration,
        "severity": severity,
        "body_part": body_part,
        "negated": negated,
        "confidence": confidence,
        "source_text": source_text,
        "created_at": datetime.utcnow().isoformat()
    }
