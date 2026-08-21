import joblib
import os
import numpy as np

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"
model = joblib.load(model_path)

print("Testing with Voltage=1.0 (Normalized) instead of 161.0")
print("Conditions: Height=1.5, Freq=1.0 (Normalized?) or 50.0")

for f in [1.0, 50.0]:
    print(f"\nFrequency: {f}")
    for l in [0.0, 1.0, 2.0]:
        feat = [100.0, 1.5, l, 1.0, f]
        pred = model.predict([feat])[0]
        b = pred[0]
        print(f"  Load {l} -> B: {b:.4f} {'[COMPLIANT]' if b <= 0.4 else ''}")

print("\nTesting with all features in [0, 1, 2] range (e.g. categorical)")
for d_cat in [0, 1, 2]: # Maybe distance was categorical?
    feat = [float(d_cat), 1.5, 1.0, 1.0, 1.0]
    b = model.predict([feat])[0][0]
    print(f"  Dist_Cat {d_cat} -> B: {b:.4f}")
