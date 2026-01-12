# --- CORE SYMPTOMS (UNIVERSAL) ---
SYMPTOMS = {
    "fever": {
        "system": "general",
        "variants": ["fever", "pyrexia", "temperature"]
    },
    "chills": {
        "system": "general",
        "variants": ["chills", "rigors"]
    },
    "sore throat": {
        "system": "ent",
        "variants": ["sore throat", "throat pain", "odynophagia"]
    },
    "cough": {
        "system": "respiratory",
        "variants": ["cough"]
    },
    "breathlessness": {
        "system": "respiratory",
        "variants": ["breathlessness", "shortness of breath", "dyspnea"]
    },
    "vomiting": {
        "system": "gi",
        "variants": ["vomiting", "emesis"]
    },
    "diarrhea": {
        "system": "gi",
        "variants": ["diarrhea", "loose stools"]
    },
    "rash": {
        "system": "skin",
        "variants": ["rash"]
    },
    "body ache": {
        "system": "musculoskeletal",
        "variants": ["body ache", "myalgia"]
    },
    "headache": {
        "system": "neurologic",
        "variants": ["headache", "head pain"]
    }
}

# --- SEVERITY ---
SEVERITY_WORDS = [
    "mild", "moderate", "severe",
    "high grade", "low grade"
]

# --- NEGATION ---
NEGATION_WORDS = [
    "no", "not", "denies", "without", "never"
]

# --- DURATION (NUMERIC + WORD BASED) ---
DURATION_PATTERNS = [
    r"\b\d+\s*(day|days|week|weeks|month|months|year|years)\b",
    r"\b(one|two|three|four|five|six|seven|eight|nine|ten)\s+"
    r"(day|days|week|weeks|month|months|year|years)\b",
    r"\bbegan\s+(one|two|three|four|five|six|seven|eight|nine|ten)\s+"
    r"(day|days|week|weeks)\s+ago\b",
    r"\bsince\s+\w+\b",
    r"\bfor\s+the\s+past\s+\w+\b"
]

# --- MEDICATION (LIGHT, UNIVERSAL) ---
MEDICATION_KEYWORDS = [
    "antibiotic", "paracetamol", "acetaminophen",
    "ibuprofen", "tablet", "capsule"
]
