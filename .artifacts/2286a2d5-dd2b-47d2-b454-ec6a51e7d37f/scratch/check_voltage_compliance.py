import joblib
import os
import numpy as np

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"
model = joblib.load(model_path)

print("Checking Voltage impact on B-field (Dist=100, Height=1.5, Load=0)")
for v in range(0, 161, 10):
    feat = [100.0, 1.5, 0.0, float(v), 50.0]
    pred = model.predict([feat])[0]
    b = pred[0]
    print(f"Volt {v} kV -> B: {b:.4f} {'[COMPLIANT]' if b <= 0.4 else ''}")

print("\nChecking Frequency impact on B-field (Dist=100, Height=1.5, Load=0, V=161)")
for f in range(0, 61, 5):
    feat = [100.0, 1.5, 0.0, 161.0, float(f)]
    pred = model.predict([feat])[0]
    b = pred[0]
    print(f"Freq {f} Hz -> B: {b:.4f} {'[COMPLIANT]' if b <= 0.4 else ''}")
