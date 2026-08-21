import joblib
import os
import numpy as np

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"
model = joblib.load(model_path)

print("Fine scan of Index 0 (Height=1.5, Load=1, V=161, F=50)")
for d in range(0, 11):
    feat = [float(d), 1.5, 1.0, 161.0, 50.0]
    pred = model.predict([feat])[0]
    print(f"Dist {d}m -> B: {pred[0]:.4f}, E: {pred[1]:.4f}")
