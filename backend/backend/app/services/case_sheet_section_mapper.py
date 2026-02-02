import requests
import json
import logging
from app.models.casesheet import empty_case_sheet

logger = logging.getLogger(__name__)

class CaseSheetSectionMapper:
    OLLAMA_URL = "http://localhost:11434/api/generate"
    MODEL = "llama3.2:3b"

    @staticmethod
    def deep_merge(source, destination):
        """Recursively merges extracted data into the draft case sheet."""
        for key, value in source.items():
            if isinstance(value, dict) and key in destination:
                CaseSheetSectionMapper.deep_merge(value, destination[key])
            else:
                destination[key] = value
        return destination

    @staticmethod
    def update(case_sheet, transcript_text):
        # Ensure we have a dict
        if not isinstance(case_sheet, dict):
            logger.warning("Case sheet was not a dict, creating empty one.")
            case_sheet = empty_case_sheet()

        # 🛡️ FIX: If 'sections' is missing, add it from the template
        if 'sections' not in case_sheet:
            logger.info("Injecting missing 'sections' key into case_sheet")
            template = empty_case_sheet()
            case_sheet['sections'] = template['sections']

        schema_json = json.dumps(case_sheet['sections'])
        
        prompt = f"""
        You are a medical scribe. Map the following clinical transcript into the JSON schema.
        Transcript: "{transcript_text}"
        Schema: {schema_json}
        
        Rules:
        - Output MUST be valid JSON.
        - Set symptom status to 'Now', 'Past', or 'Absent'.
        - Use English only.
        """

        try:
            response = requests.post(
                CaseSheetSectionMapper.OLLAMA_URL,
                json={
                    "model": CaseSheetSectionMapper.MODEL,
                    "prompt": prompt,
                    "format": "json",
                    "stream": False,
                    "options": {"temperature": 0}
                },
                timeout=120
            )
            
            # 🛡️ THE FIX IS HERE:
            res_json = response.json()
            raw_ai_string = res_json.get("response", "{}")
            
            # We must parse the string into a dictionary
            extracted_data = json.loads(raw_ai_string) 

            # Now we merge the parsed dictionary into our case_sheet
            case_sheet['sections'] = CaseSheetSectionMapper.deep_merge(
                extracted_data, 
                case_sheet['sections']
            )
            
            return case_sheet # Now returning a DICT, not a STR
            
        except Exception as e:
            logger.error(f"Ollama process failed: {e}")
            return case_sheet