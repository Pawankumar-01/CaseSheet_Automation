def empty_case_sheet():
    return {
        "metadata": {"finalized": False},
        "sections": {  # <--- This MUST be here
            "chief_complaints": {
                "major_complaint": "", 
                "duration": "", 
                "aggravating_factors": "", 
                "relieving_factors": ""
            },
            "anamnesis": {
                "disease_history": "",
                "surgical_history": "",
                "medications": ""
            },
            "review_of_systems": {},
            "physical_examination": {
                "bp": "", 
                "pulse": "", 
                "respiratory": ""
            }
        }
    }