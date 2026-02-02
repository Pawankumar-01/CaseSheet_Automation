import os
import json
import re
import logging
import dotenv
import requests
import os
from app.services.ollama_section_prompts import SECTION_PROMPTS, BASE_RULES
dotenv.load_dotenv()

logger = logging.getLogger(__name__)

# -----------------------------
# CONFIG
# -----------------------------

OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"
MODEL = "google/gemma-3-27b-it:free"

OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")

if not OPENROUTER_API_KEY:
    raise RuntimeError("OPENROUTER_API_KEY not set in environment")

HEADERS = {
    "Authorization": f"Bearer {OPENROUTER_API_KEY}",
    "Content-Type": "application/json",
    # Optional but recommended
    "HTTP-Referer": "http://localhost",
    "X-Title": "Clinical AI Backend",
}

# -----------------------------
# SERVICE
# -----------------------------

class GemmaService:
    """
    Drop-in replacement for OllamaService.
    Input  : section (str), transcript (str)
    Output : dict (strict JSON)
    """

    @staticmethod
    def _extract_json(text: str) -> dict:
        # Remove markdown fences
        text = text.strip()
        text = re.sub(r"^```json", "", text)
        text = re.sub(r"^```", "", text)
        text = re.sub(r"```$", "", text)
        text = text.strip()

        try:
            return json.loads(text)
        except json.JSONDecodeError:
            raise ValueError(f"Invalid JSON from Gemma:\n{text}")

    
    @staticmethod
    def generate_section(section: str, transcript: str) -> dict:
        prompt = SECTION_PROMPTS.get(section)
        if not prompt:
            raise ValueError(f"No prompt defined for section: {section}")

        messages = [
            {
                "role": "system",
                "content": BASE_RULES.strip(),
            },
            {
                "role": "user",
                "content": f"""
    TRANSCRIPT:
    <<<
    {transcript}
    >>>

    {prompt}

    IMPORTANT:
    - Respond with ONLY valid JSON
    - Do NOT include explanations
    - Do NOT include markdown
    """.strip(),
            },
        ]

        payload = {
            "model": MODEL,
            "messages": messages,
            "temperature": 0.1,
            # ❌ response_format REMOVED
        }

        logger.info(f"[GEMMA] Section={section}")

        try:
            res = requests.post(
                OPENROUTER_URL,
                headers=HEADERS,
                json=payload,
                timeout=120,
            )

            if res.status_code != 200:
                logger.error(f"[GEMMA HTTP {res.status_code}] {res.text}")
                res.raise_for_status()

            data = res.json()
            raw = data["choices"][0]["message"]["content"]

            logger.info(f"[GEMMA RAW OUTPUT] {raw}")

            parsed = GemmaService._extract_json(raw)

            logger.info(f"[GEMMA PARSED OUTPUT] {parsed}")

            return parsed

        except Exception:
            logger.exception(f"[GEMMA ERROR] section={section}")
            raise
