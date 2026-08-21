import joblib
import os
import numpy as np

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"

model = joblib.load(model_path)

# Test distances: 0, 10, 20, 50, 100
distances = [0, 10, 20, 50, 100]
height = 1.5
load = 1 # Average

print("Testing Distance Decay (Height=1.5, Load=1, Voltage=161, Frequency=50)")
for d in distances:
    # Hypothesis: [Dist, Height, Load, 161, 50]
    features = np.array([[d, height, load, 161, 50]])
    prediction = model.predict(features)
    print(f"Dist: {d}m -> B: {prediction[0][0]:.4f} uT, E: {prediction[0][1]:.4f} V/m")

print("\nTesting Load variation (Dist=10, Height=1.5)")
for l in [0, 1, 2]:
    features = np.array([[10, 1.5, l, 161, 50]])
    prediction = model.predict(features)
    print(f"Load: {l} -> B: {prediction[0][0]:.4f} uT, E: {prediction[0][1]:.4f} V/m")

print("\nTesting Height variation (Dist=10, Load=1)")
for h in [1.0, 1.5, 1.8]:
    features = np.array([[10, h, 1, 161, 50]])
    prediction = model.predict(features)
    print(f"Height: {h}m -> B: {prediction[0][0]:.4f} uT, E: {prediction[0][1]:.4f} V/m")
