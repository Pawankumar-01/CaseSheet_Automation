import requests, json, re, logging
from app.services.ollama_section_prompts import SECTION_PROMPTS

logger = logging.getLogger(__name__)

OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "llama3.2:3b"

class OllamaService:

    @staticmethod
    def _extract_json(text: str) -> dict:
        """
        Safely extract JSON even if Ollama truncates output.
        """
        try:
            # Try direct parse first
            return json.loads(text)
        except Exception:
            pass

        # Fallback: extract largest valid JSON block
        match = re.search(r"\{[\s\S]*", text)
        if not match:
            raise ValueError("No JSON start found")

        candidate = match.group()

        # Attempt to auto-close braces
        open_braces = candidate.count("{")
        close_braces = candidate.count("}")

        if close_braces < open_braces:
            candidate += "}" * (open_braces - close_braces)

        return json.loads(candidate)


    @staticmethod
    def generate_section(section: str, transcript: str) -> dict:
        prompt = SECTION_PROMPTS.get(section)
        if not prompt:
            raise ValueError(f"No prompt defined for {section}")

        payload = {
            "model": MODEL,
            "prompt": f"""
You are a clinical documentation engine.
Return ONLY valid JSON.

TRANSCRIPT:
<<<
{transcript}
>>>

{prompt}
""",
            "stream": False,
            "options": { "temperature": 0.1 }
        }

        logger.info(f"[OLLAMA] Section={section}")
        res = requests.post(OLLAMA_URL, json=payload, timeout=120)
        res.raise_for_status()

        raw = res.json().get("response", "")
        logger.info(f"[OLLAMA RAW OUTPUT] {raw}")

        try:
            parsed = OllamaService._extract_json(raw)
        except Exception as e:
            logger.error("[OLLAMA PARSE ERROR]")
            logger.error(raw)
            return {}


        logger.info(f"[OLLAMA PARSED OUTPUT] {parsed}")

        return parsed
