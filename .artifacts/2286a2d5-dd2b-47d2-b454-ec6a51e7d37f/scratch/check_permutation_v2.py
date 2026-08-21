import joblib
import os
import numpy as np

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"
model = joblib.load(model_path)

print("Testing Permutation: [Volt, Freq, Dist, Height, Load]")
print("Dist 0m, Height 1.5, Load 1")
feat0 = [161.0, 50.0, 0.0, 1.5, 1.0]
pred0 = model.predict([feat0])[0]
print(f"  Result -> B: {pred0[0]:.4f}, E: {pred0[1]:.4f}")

print("Dist 100m, Height 1.5, Load 1")
feat100 = [161.0, 50.0, 100.0, 1.5, 1.0]
pred100 = model.predict([feat100])[0]
print(f"  Result -> B: {pred100[0]:.4f}, E: {pred100[1]:.4f}")

print("\nTesting Permutation: [Dist, Volt, Freq, Height, Load]")
feat_d0 = [0.0, 161.0, 50.0, 1.5, 1.0]
feat_d100 = [100.0, 161.0, 50.0, 1.5, 1.0]
b0 = model.predict([feat_d0])[0][0]
b100 = model.predict([feat_d100])[0][0]
print(f"Dist 0m -> B: {b0:.4f}, Dist 100m -> B: {b100:.4f}")
