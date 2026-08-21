import joblib
import os
import numpy as np

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"
model = joblib.load(model_path)

print("Final Mapping Check: [Dist, Height, Load, 1.0, 1.0]")

for l_name, l_val in [("Off-Peak", 0.0), ("Average", 1.0), ("Maximum", 2.0)]:
    print(f"\nLoad: {l_name}")
    for d in [0.0, 20.0, 50.0, 100.0]:
        feat = [d, 1.5, l_val, 1.0, 1.0]
        pred = model.predict([feat])[0]
        b, e = pred[0], pred[1]
        print(f"  Dist {d}m -> B: {b:.4f} uT, E: {e:.4f} V/m {'[COMPLIANT]' if b <= 0.4 else ''}")
