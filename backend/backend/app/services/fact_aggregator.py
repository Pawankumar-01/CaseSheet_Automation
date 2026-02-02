# # app/services/fact_aggregator.py

# class FactAggregator:
#     @staticmethod
#     def aggregate(facts: list) -> list:
#         merged = {}

#         for fact in facts:
#             key = (fact.name, fact.body_part)

#             if key not in merged:
#                 merged[key] = fact
#             else:
#                 existing = merged[key]

#                 existing.severity = existing.severity or fact.severity
#                 existing.duration = existing.duration or fact.duration
#                 existing.course = existing.course or fact.course
#                 existing.negated = existing.negated or fact.negated
#                 existing.status = "absent" if existing.negated else "present"

#         return list(merged.values())
