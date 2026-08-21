import joblib
import os
import numpy as np

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"
model = joblib.load(model_path)

# Hypothesis: Index 0 = Dist, Index 2 = Load
# Other features: Index 1 = Height, Index 3 = Voltage, Index 4 = Frequency ?
# Or Index 1 = Height, Index 3 = Frequency, Index 4 = Voltage ?
# Let's try [Dist, Height, Load, 161, 50]

print("Testing Distance Decay at Maximum Load (Load=2)")
for d in range(0, 101, 10):
    feat = [float(d), 1.5, 2.0, 161.0, 50.0]
    pred = model.predict([feat])[0]
    print(f"Dist {d}m -> B: {pred[0]:.4f}, E: {pred[1]:.4f}")

print("\nTesting Distance Decay at Average Load (Load=1)")
for d in range(0, 101, 10):
    feat = [float(d), 1.5, 1.0, 161.0, 50.0]
    pred = model.predict([feat])[0]
    print(f"Dist {d}m -> B: {pred[0]:.4f}, E: {pred[1]:.4f}")

print("\nTesting Distance Decay at Off-Peak Load (Load=0)")
for d in range(0, 101, 10):
    feat = [float(d), 1.5, 0.0, 161.0, 50.0]
    pred = model.predict([feat])[0]
    print(f"Dist {d}m -> B: {pred[0]:.4f}, E: {pred[1]:.4f}")
