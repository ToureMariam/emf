import joblib
import os
import numpy as np

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"
model = joblib.load(model_path)

print("Testing Index 4 for distance decay (Height at 0, Load at 1, V at 2, F at 3)")
for d in [0, 1, 2, 5, 10, 20, 50, 100, 200, 500]:
    feat = [1.5, 1.0, 161.0, 50.0, float(d)]
    pred = model.predict([feat])[0]
    print(f"Val {d} at Idx 4 -> B: {pred[0]:.4f}")

print("\nTesting Index 2 for distance decay (H=0, L=1, V=3, F=4, Dist=2)")
for d in [0, 1, 2, 5, 10, 20, 50, 100]:
    feat = [1.5, 1.0, float(d), 161.0, 50.0]
    pred = model.predict([feat])[0]
    print(f"Val {d} at Idx 2 -> B: {pred[0]:.4f}")
