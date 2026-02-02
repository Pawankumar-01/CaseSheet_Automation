# # app/nlp/clinical_entity_extractor.py

# from app.nlp.clinical_ner_ml_service import ClinicalNERMLService
# from app.nlp.ner_label_mapper import map_ml_labels

# ml_ner = ClinicalNERMLService()

# class ClinicalEntityExtractor:
#     @staticmethod
#     def extract(text: str) -> list[dict]:
#         """
#         Output: list of atomic entities
#         Example:
#         {
#           type: 'SYMPTOM',
#           text: 'fatigue',
#           confidence: 0.82
#         }
#         """
#         ml_entities = ml_ner.extract_entities(text)
#         entities = map_ml_labels(ml_entities)

#         return entities
