import joblib
import os
import numpy as np

# Mock map_load_condition
def map_load_condition(condition):
    mapping = {"Off-Peak": 0, "Average-Peak": 1, "Maximum-Peak": 2}
    return mapping.get(condition, 1)

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"
model = joblib.load(model_path)

def predict_logic(distance, height, load_condition):
    load_numeric = map_load_condition(load_condition)
    features = [[distance, height, load_numeric, 161.0, 50.0]]
    prediction = model.predict(features)
    b = float(prediction[0][0])
    e = float(prediction[0][1])
    is_compliant = (b <= 0.4) and (e <= 5000.0)
    return b, e, is_compliant

def safe_zone_logic(height, load_condition):
    load_numeric = map_load_condition(load_condition)
    safe_distance = 100.0
    for d in range(0, 101):
        features = [[float(d), height, load_numeric, 161.0, 50.0]]
        prediction = model.predict(features)
        b = float(prediction[0][0])
        if b <= 0.4:
            safe_distance = float(d)
            break
    return safe_distance

print("Test Case 1: Dist 0, Height 1.5, Max Load")
b, e, c = predict_logic(0, 1.5, "Maximum-Peak")
print(f"B: {b:.4f}, E: {e:.4f}, Compliant: {c}")

print("\nTest Case 2: Dist 50, Height 1.5, Off-Peak")
b, e, c = predict_logic(50, 1.5, "Off-Peak")
print(f"B: {b:.4f}, E: {e:.4f}, Compliant: {c}")

print("\nSafe Zone Analysis (Height 1.5, Max Load)")
sz = safe_zone_logic(1.5, "Maximum-Peak")
print(f"Safe Zone Distance: {sz}m")
