import re

class SentenceService:

    @staticmethod
    def split(text: str) -> list[str]:
        if not text:
            return []

        # Step 1: normalize
        text = text.strip()

        # Step 2: split on strong sentence boundaries
        sentences = re.split(r'[.?!]\s+', text)

        final_sentences = []

        for s in sentences:
            # Step 3: split on clinical conjunctions
            clauses = re.split(
                r'\s+(and|but|also|with)\s+',
                s,
                flags=re.IGNORECASE
            )

            # Step 4: clean clauses
            for c in clauses:
                c = c.strip()
                if c.lower() in ["and", "but", "also", "with"]:
                    continue
                if len(c) > 3:
                    final_sentences.append(c)

        return final_sentences
