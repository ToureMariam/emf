import joblib
import os
import numpy as np

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"
model = joblib.load(model_path)

print("Exhaustive Search for Compliance (B <= 0.4) within Study Range")
print("Range: Dist [0, 100], Height [1.0, 1.8], Load [0, 1, 2]")
print("Fixed: Volt=161, Freq=50")

found = False
min_b = 999.0
best_feat = None

for d in range(0, 101, 1):
    for h in [1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8]:
        for l in [0.0, 1.0, 2.0]:
            feat = [float(d), float(h), float(l), 161.0, 50.0]
            pred = model.predict([feat])[0]
            b = pred[0]
            if b < min_b:
                min_b = b
                best_feat = feat
            if b <= 0.4:
                print(f"  [FOUND COMPLIANT] Dist: {d}, Height: {h}, Load: {l} -> B: {b:.4f}")
                found = True

if not found:
    print(f"\nNo compliant inputs found in study range. Min B found: {min_b:.4f} at {best_feat}")

print("\nSearching if B <= 0.4 is reachable by varying Voltage or Frequency...")
for v in range(0, 162, 10):
    feat = [100.0, 1.0, 0.0, float(v), 50.0]
    b = model.predict([feat])[0][0]
    if b <= 0.4:
        print(f"  [FOUND] Volt: {v} -> B: {b:.4f}")
