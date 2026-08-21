import joblib
import os
import numpy as np

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"
model = joblib.load(model_path)

print("Checking Index 0 for extreme values (Height=1.5, Load=1, V=161, F=50)")
# Note: I used [d, 1.5, 1.0, 161, 50] in previous tests
# But in check_index2_decay.py I used [val, 1.5, 1.0, 50.0, 1.0]

for d in [0, 10, 50, 100, 500, 1000, 5000]:
    feat = [float(d), 1.5, 1.0, 161.0, 50.0]
    pred = model.predict([feat])[0]
    print(f"Val {d} at Idx 0 -> B: {pred[0]:.4f}")
