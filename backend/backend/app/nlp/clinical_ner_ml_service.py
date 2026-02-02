
# # app/nlp/clinical_ner_ml_service.py

# from transformers import AutoTokenizer, AutoModelForTokenClassification, pipeline
# from typing import List, Dict

# MODEL_NAME = "emilyalsentzer/Bio_ClinicalBERT"  # locked class

# class ClinicalNERMLService:
#     def __init__(self):
#         self.tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
#         self.model = AutoModelForTokenClassification.from_pretrained(MODEL_NAME)

#         self.ner_pipeline = pipeline(
#             "token-classification",
#             model=self.model,
#             tokenizer=self.tokenizer,
#             aggregation_strategy="simple"
#         )

#     def extract_entities(self, text: str) -> List[Dict]:
#         """
#         Output format:
#         [
#           { 'label': 'PROBLEM', 'text': 'fever' },
#           { 'label': 'NEGATION', 'text': 'no' }
#         ]
#         """
#         raw_entities = self.ner_pipeline(text)

#         return [
#             {
#                 "label": ent["entity_group"],
#                 "text": ent["word"],
#                 "confidence": float(ent["score"])
#             }
#             for ent in raw_entities
#         ]
