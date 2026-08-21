import joblib
import os
import numpy as np

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"
model = joblib.load(model_path)

print("Scanning for Safe Zone (B <= 0.4) up to 1000m")
print("Conditions: Height=1.5, Voltage=161, Frequency=50")

for load_name, load_val in [("Off-Peak", 0), ("Average", 1), ("Maximum", 2)]:
    print(f"\nLoad: {load_name}")
    for d in range(0, 1001, 50):
        feat = [float(d), 1.5, float(load_val), 161.0, 50.0]
        pred = model.predict([feat])[0]
        b = pred[0]
        if b <= 0.4:
            print(f"  [SAFE] reached at {d}m: B={b:.4f}")
            break
    else:
        # Check if it *ever* decays
        feat0 = [0.0, 1.5, float(load_val), 161.0, 50.0]
        feat1000 = [1000.0, 1.5, float(load_val), 161.0, 50.0]
        b0 = model.predict([feat0])[0][0]
        b1000 = model.predict([feat1000])[0][0]
        print(f"  No safe zone in 1000m. B(0m)={b0:.4f}, B(1000m)={b1000:.4f}")
