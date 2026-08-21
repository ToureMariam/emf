def map_load_condition(condition: str) -> int:
    """
    Maps load condition string from Flutter to numerical value for ML model.
    """
    mapping = {
        "Off-Peak": 0,
        "Average-Peak": 1,
        "Maximum-Peak": 2
    }
    return mapping.get(condition, 1) # Default to Average-Peak if unknown
