import joblib
import os
import numpy as np

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"
model = joblib.load(model_path)

def test_idx(idx):
    print(f"\nTesting Index {idx} for distance decay:")
    for d in [0, 10, 20, 50, 100, 200]:
        feat = [161.0, 1.5, 1.0, 50.0, 1.0] # Dummy
        feat[idx] = float(d)
        pred = model.predict([feat])[0]
        print(f"Val {d} at Idx {idx} -> B: {pred[0]:.4f}")

for i in range(5):
    test_idx(i)
