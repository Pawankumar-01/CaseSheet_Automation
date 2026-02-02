# # app/nlp/ner_label_mapper.py

# ML_TO_CLINICAL_LABEL = {
#     "PROBLEM": "SYMPTOM",
#     "NEGATION": "NEGATION",
#     "SEVERITY": "SEVERITY",
#     "TEMPORAL": "DURATION",
#     "ANATOMY": "BODY_PART",
#     "DRUG": "MEDICATION"
# }

# def map_ml_labels(ml_entities):
#     """
#     Converts ML labels into locked clinical labels.
#     Ignores unsupported labels safely.
#     """
#     mapped = []

#     for ent in ml_entities:
#         clinical_label = ML_TO_CLINICAL_LABEL.get(ent["label"])
#         if not clinical_label:
#             continue

#         mapped.append({
#             "label": clinical_label,
#             "text": ent["text"],
#             "confidence": ent["confidence"]
#         })

#     return mapped
