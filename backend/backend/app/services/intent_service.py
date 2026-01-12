class IntentService:

    @staticmethod
    def classify(sentence: str) -> str:
        s = sentence.lower()

        # Review of systems (NEGATIONS FIRST)
        if any(k in s for k in [
            "no history of", "denies", "no ", "without"
        ]):
            return "review_of_systems"

        # Chief complaint (explicit)
        if any(k in s for k in [
            "complains of", "chief complaint", "presenting with"
        ]):
            return "chief_complaint"

        # History of present illness (HPI)
        if any(k in s for k in [
            "reports", "associated with", "began", "started",
            "since", "for the past", "duration", "progressive",
            "intermittent", "onset", "aggravated", "relieved",
            "improving", "worsening"
        ]):
            return "history_of_present_illness"

        # Past history
        if any(k in s for k in [
            "history of", "previously", "in the past", "earlier"
        ]):
            return "past_medical_history"

        return "other"
