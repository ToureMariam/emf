import joblib
import os
import numpy as np

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"
model = joblib.load(model_path)

print("Checking Screenshot 1: Dist 20m, Height 1.5m, Load 1 (Average)")
feat1 = [20.0, 1.5, 1.0, 161.0, 50.0]
pred1 = model.predict([feat1])[0]
print(f"Result -> B: {pred1[0]:.4f}, E: {pred1[1]:.4f}")

print("\nChecking Screenshot 2: Dist 29m, Height 1.2m, Load 1 (Average)")
feat2 = [29.0, 1.2, 1.0, 161.0, 50.0]
pred2 = model.predict([feat2])[0]
print(f"Result -> B: {pred2[0]:.4f}, E: {pred2[1]:.4f}")

print("\nChecking Screenshot 2 with Max Load: Dist 29m, Height 1.2m, Load 2 (Max)")
feat3 = [29.0, 1.2, 2.0, 161.0, 50.0]
pred3 = model.predict([feat3])[0]
print(f"Result -> B: {pred3[0]:.4f}, E: {pred3[1]:.4f}")
