from datetime import datetime
from uuid import uuid4

def create_session(patient_id=None, doctor_id=None):
    return {
        "id": str(uuid4()),
        "patient_id": patient_id,
        "doctor_id": doctor_id,
        "created_at": datetime.utcnow(),
        "finalized": False,
    }
